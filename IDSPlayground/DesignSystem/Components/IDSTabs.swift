//
//  IDSTabs.swift
//  IDSPlayground
//
//  IDS reusable tabs component — maps to Figma "IDS.Tabs".
//  Two layout modes: Fixed (2 tabs) and Scrollable (3+ tabs),
//  with sliding underline animation via matchedGeometryEffect
//  and badge count-up animation on tab selection.
//

import SwiftUI

// MARK: - Tab Item

/// Data model for a single tab in IDSTabs.
struct IDSTabItem {
    let title: String
    var badgeCount: Int? = nil
}

// MARK: - IDSTabs

/// A segmented-control-style tab bar matching IDS.Tabs.
///
/// Two layout modes based on tab count:
/// - **2 tabs**: Fixed equal-width layout, text truncation, no scroll.
/// - **3+ tabs**: Content-width tabs, horizontal scroll with bounce, no truncation.
///
/// Selected tab indicator slides between tabs via `matchedGeometryEffect`.
/// Optional counter badge support (standard appearance, not outlined).
///
/// Usage:
/// ```
/// IDSTabs(
///     tabs: [IDSTabItem(title: "Tab 1"), IDSTabItem(title: "Tab 2")],
///     selectedIndex: $selectedIndex
/// )
/// IDSTabs(
///     tabs: [
///         IDSTabItem(title: "Orders", badgeCount: 5),
///         IDSTabItem(title: "Returns"),
///         IDSTabItem(title: "History")
///     ],
///     selectedIndex: $selectedIndex
/// )
/// ```
struct IDSTabs: View {

    let tabs: [IDSTabItem]
    @Binding var selectedIndex: Int

    @Namespace private var underlineNamespace

    // MARK: Constants

    /// Tab row height (40px).
    private let tabHeight: CGFloat = 40

    /// Selected indicator stroke height (2px).
    private let underlineHeight: CGFloat = 2

    /// Tab group maximum width constraint.
    private let maxGroupWidth: CGFloat = 512

    /// Animation duration for tab switching (underline slide + text color).
    private let animationDuration: Double = 0.25

    /// Animation duration for badge count-up effect.
    private let badgeCountUpDuration: Double = 0.5

    // MARK: Layout Mode

    /// Whether tabs use fixed equal-width layout (≤2 tabs) or scrollable layout (3+).
    private var isFixedMode: Bool {
        tabs.count <= 2
    }

    // MARK: Body

    var body: some View {
        if isFixedMode {
            fixedLayout
        } else {
            scrollableLayout
        }
    }
}

// MARK: - Fixed Layout (2 Tabs)

private extension IDSTabs {

    var fixedLayout: some View {
        HStack(spacing: IDSSpacing.sm) {
            ForEach(Array(tabs.enumerated()), id: \.offset) { index, tab in
                tabButton(index: index, tab: tab, isFixed: true)
            }
        }
        .frame(maxWidth: maxGroupWidth)
        .padding(.horizontal, IDSSpacing.lg)
        .background(IDSColors.grayscale00)
    }
}

// MARK: - Scrollable Layout (3+ Tabs)

private extension IDSTabs {

    var scrollableLayout: some View {
        ScrollViewReader { proxy in
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: IDSSpacing.none) {
                    ForEach(Array(tabs.enumerated()), id: \.offset) { index, tab in
                        tabButton(index: index, tab: tab, isFixed: false)
                            .id(index)
                    }
                }
                .padding(.horizontal, IDSSpacing.lg)
            }
            .background(IDSColors.grayscale00)
            .onChange(of: selectedIndex) { _, newValue in
                withAnimation(.easeInOut(duration: animationDuration)) {
                    proxy.scrollTo(newValue, anchor: .center)
                }
            }
        }
    }
}

// MARK: - Tab Button

private extension IDSTabs {

    func tabButton(index: Int, tab: IDSTabItem, isFixed: Bool) -> some View {
        let isSelected = index == selectedIndex

        return Button {
            withAnimation(.easeInOut(duration: animationDuration)) {
                selectedIndex = index
            }
        } label: {
            tabLabel(tab: tab, isSelected: isSelected, isFixed: isFixed)
        }
        .buttonStyle(.plain)
        .accessibilityAddTraits(isSelected ? .isSelected : [])
        .accessibilityElement(children: .combine)
    }

    @ViewBuilder
    func tabLabel(tab: IDSTabItem, isSelected: Bool, isFixed: Bool) -> some View {
        HStack(spacing: IDSSpacing.sm) {
            Text(tab.title)
                .font(IDSTypography.bodyEmphasized)
                .foregroundColor(isSelected ? IDSColors.grayscale80 : IDSColors.contentSecondary)
                .lineLimit(1)
                .truncationMode(.tail)

            if let count = tab.badgeCount {
                IDSTabBadge(
                    count: count,
                    isSelected: isSelected,
                    countUpDuration: badgeCountUpDuration
                )
            }
        }
        .padding(.horizontal, isFixed ? IDSSpacing.none : IDSSpacing.md)
        .frame(maxWidth: isFixed ? .infinity : nil)
        .frame(height: tabHeight)
        .clipped()
        .overlay(alignment: .bottom) {
            if isSelected {
                Rectangle()
                    .fill(IDSColors.grayscale80)
                    .frame(height: underlineHeight)
                    .matchedGeometryEffect(id: "tabUnderline", in: underlineNamespace)
            }
        }
    }
}

// MARK: - Badge Count-Up Animation

/// Manages badge count-up animation state for a single tab.
///
/// When `isSelected` transitions from `false` → `true`, the displayed
/// count animates from 0 to the target value (easeOut). When deselected,
/// the badge snaps to the full value immediately.
private struct IDSTabBadge: View {

    let count: Int
    let isSelected: Bool
    let countUpDuration: Double

    @State private var animatedValue: Double

    init(count: Int, isSelected: Bool, countUpDuration: Double) {
        self.count = count
        self.isSelected = isSelected
        self.countUpDuration = countUpDuration
        self._animatedValue = State(initialValue: Double(count))
    }

    var body: some View {
        IDSCountingBadge(value: animatedValue)
            .onChange(of: isSelected) { oldValue, newValue in
                if newValue && !oldValue {
                    // Became selected → count up from 0
                    animatedValue = 0
                    withAnimation(.easeOut(duration: countUpDuration)) {
                        animatedValue = Double(count)
                    }
                } else if !newValue && oldValue {
                    // Became unselected → snap to full value
                    var transaction = Transaction()
                    transaction.disablesAnimations = true
                    withTransaction(transaction) {
                        animatedValue = Double(count)
                    }
                }
            }
    }
}

/// Animatable wrapper around IDSBadge that interpolates the counter value.
///
/// SwiftUI calls the `animatableData` setter at each animation frame,
/// producing a smooth numeric count-up when the value transitions.
private struct IDSCountingBadge: View, Animatable {

    var value: Double

    var animatableData: Double {
        get { value }
        set { value = newValue }
    }

    var body: some View {
        IDSBadge(
            type: .counter(max(0, Int(value.rounded()))),
            appearance: .standard,
            isOutlined: false
        )
    }
}

// MARK: - Preview Helper

/// Interactive wrapper for IDSTabs previews with @State.
private struct IDSTabsPreview: View {
    let tabs: [IDSTabItem]
    @State private var selectedIndex: Int

    init(tabs: [IDSTabItem], selectedIndex: Int = 0) {
        self.tabs = tabs
        self._selectedIndex = State(initialValue: selectedIndex)
    }

    var body: some View {
        VStack(spacing: IDSSpacing.none) {
            IDSTabs(tabs: tabs, selectedIndex: $selectedIndex)
            Spacer()
        }
        .background(IDSColors.brandTertiaryLight)
    }
}

// MARK: - Previews

#Preview("2 Tabs") {
    IDSTabsPreview(tabs: [
        IDSTabItem(title: "Tab"),
        IDSTabItem(title: "Tab")
    ])
}

#Preview("3 Tabs") {
    IDSTabsPreview(tabs: [
        IDSTabItem(title: "Tab"),
        IDSTabItem(title: "Tab"),
        IDSTabItem(title: "Tab")
    ])
}

#Preview("4+ Tabs") {
    IDSTabsPreview(tabs: [
        IDSTabItem(title: "Tab"),
        IDSTabItem(title: "Tab"),
        IDSTabItem(title: "Tab"),
        IDSTabItem(title: "Tab"),
        IDSTabItem(title: "Tab")
    ])
}

#Preview("With Badges") {
    IDSTabsPreview(tabs: [
        IDSTabItem(title: "Tab", badgeCount: 99),
        IDSTabItem(title: "Tab", badgeCount: 99)
    ])
}

#Preview("Long Names & Scrollable") {
    IDSTabsPreview(tabs: [
        IDSTabItem(title: "this is a long name"),
        IDSTabItem(title: "This is another long name"),
        IDSTabItem(title: "This is even longer")
    ])
}
