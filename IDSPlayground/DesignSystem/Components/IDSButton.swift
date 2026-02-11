//
//  IDSButton.swift
//  IDSPlayground
//
//  IDS reusable button component — maps to Figma "IDS.Button".
//  3 sizes (Standard, Small, Compact) × 5 types (Primary, Secondary,
//  Tertiary, Detrimental, Instacart+) × 3 states (Default, Loading,
//  Disabled) = 45 variants.
//

import SwiftUI

// MARK: - Button Size

/// The size variant of an IDSButton.
enum IDSButtonSize: String, CaseIterable {
    case standard
    case small
    case compact

    /// Human-readable name for previews and catalog.
    var displayName: String {
        switch self {
        case .standard: return "Standard"
        case .small: return "Small"
        case .compact: return "Compact"
        }
    }

    /// Fixed height for this size.
    var height: CGFloat {
        switch self {
        case .standard: return 56
        case .small: return 40
        case .compact: return 32
        }
    }

    /// Font used for the button label.
    var font: Font {
        switch self {
        case .standard: return IDSTypography.button
        case .small: return IDSTypography.buttonSmall
        case .compact: return IDSTypography.bodyEmphasized
        }
    }

    /// Diameter of each loading dot for this size.
    var loadingDotSize: CGFloat {
        switch self {
        case .standard: return 12
        case .small: return 8
        case .compact: return 6
        }
    }

    /// Whether this size uses full-width layout.
    var isFullWidth: Bool {
        self == .standard
    }

    /// Minimum width constraint (nil for standard — uses full-width instead).
    var minWidth: CGFloat? {
        switch self {
        case .standard: return nil
        case .small: return 80
        case .compact: return 60
        }
    }

    /// Maximum width constraint (.infinity for standard — fills container).
    var maxWidth: CGFloat {
        switch self {
        case .standard: return .infinity
        case .small: return 192
        case .compact: return 188
        }
    }
}

// MARK: - Button Type

/// The visual type of an IDSButton.
enum IDSButtonType: String, CaseIterable {
    case primary
    case secondary
    case tertiary
    case detrimental
    case instacartPlus

    /// Human-readable name for previews and catalog.
    var displayName: String {
        switch self {
        case .primary: return "Primary"
        case .secondary: return "Secondary"
        case .tertiary: return "Tertiary"
        case .detrimental: return "Detrimental"
        case .instacartPlus: return "Instacart+"
        }
    }

    // MARK: Default Colors

    /// Background color in the Default state.
    var backgroundColor: Color {
        switch self {
        case .primary: return IDSColors.buttonPrimaryBg
        case .secondary: return IDSColors.buttonSecondaryBg
        case .tertiary: return IDSColors.buttonTertiaryBg
        case .detrimental: return IDSColors.buttonDetrimentalBg
        case .instacartPlus: return IDSColors.buttonInstacartPlusBg
        }
    }

    /// Text / loading-dot color in the Default state.
    var contentColor: Color {
        switch self {
        case .primary: return IDSColors.buttonPrimaryContent
        case .secondary: return IDSColors.buttonSecondaryContent
        case .tertiary: return IDSColors.buttonTertiaryContent
        case .detrimental: return IDSColors.buttonDetrimentalContent
        case .instacartPlus: return IDSColors.buttonInstacartPlusContent
        }
    }

    // MARK: Loading Colors

    /// Background color in the Loading state.
    var loadingBackgroundColor: Color {
        switch self {
        case .primary: return IDSColors.buttonPrimaryBgLoading
        case .secondary: return IDSColors.buttonSecondaryBgLoading
        case .tertiary: return IDSColors.buttonTertiaryBg // same as default
        case .detrimental: return IDSColors.buttonDetrimentalBgLoading
        case .instacartPlus: return IDSColors.buttonInstacartPlusBgLoading
        }
    }

    // MARK: Border

    /// Whether this type has a visible border.
    var hasBorder: Bool {
        self == .tertiary
    }

    /// Border color (only used when `hasBorder` is true).
    var borderColor: Color {
        IDSColors.buttonTertiaryBorder
    }
}

// MARK: - IDSButton

/// A pill-shaped button matching IDS.Button.
///
/// Three sizes: `.standard` (56px, full-width), `.small` (40px, flexible),
/// `.compact` (32px, intrinsic). All share 5 types × 3 states.
///
/// Usage:
/// ```
/// IDSButton("Continue", type: .primary) { /* action */ }
/// IDSButton("Details", type: .tertiary, size: .small) { /* action */ }
/// IDSButton("Action", type: .tertiary, size: .compact) { /* action */ }
/// IDSButton("Continue", type: .detrimental, isLoading: true) { /* action */ }
/// IDSButton("Continue", type: .secondary, isEnabled: false) { /* action */ }
/// ```
struct IDSButton: View {

    let label: String
    let type: IDSButtonType
    let size: IDSButtonSize
    var isLoading: Bool = false
    var isEnabled: Bool = true
    let action: () -> Void

    init(
        _ label: String,
        type: IDSButtonType = .primary,
        size: IDSButtonSize = .standard,
        isLoading: Bool = false,
        isEnabled: Bool = true,
        action: @escaping () -> Void
    ) {
        self.label = label
        self.type = type
        self.size = size
        self.isLoading = isLoading
        self.isEnabled = isEnabled
        self.action = action
    }

    // MARK: Resolved Colors

    /// Effective background for the current state.
    private var resolvedBackground: Color {
        if !isEnabled { return IDSColors.buttonDisabledBg }
        if isLoading { return type.loadingBackgroundColor }
        return type.backgroundColor
    }

    /// Effective content (text / dot) color for the current state.
    private var resolvedContentColor: Color {
        if !isEnabled { return IDSColors.buttonDisabledContent }
        return type.contentColor
    }

    /// Whether to show a border.
    private var showBorder: Bool {
        guard type.hasBorder else { return false }
        // Tertiary keeps its border in Default and Loading, but not Disabled.
        return isEnabled
    }

    /// Whether the button should accept taps.
    private var isTappable: Bool {
        isEnabled && !isLoading
    }

    // MARK: Body

    var body: some View {
        Button {
            if isTappable { action() }
        } label: {
            ZStack {
                if isLoading && isEnabled {
                    IDSLoadingDots(
                        color: resolvedContentColor,
                        dotSize: size.loadingDotSize
                    )
                } else {
                    Text(label)
                        .font(size.font)
                        .foregroundColor(resolvedContentColor)
                        .lineLimit(size.isFullWidth ? nil : 1)
                        .truncationMode(.tail)
                }
            }
            .padding(.horizontal, IDSSpacing.lg)
            .buttonSizeFrame(size)
            .background(resolvedBackground)
            .overlay(
                RoundedRectangle(cornerRadius: 999)
                    .stroke(type.borderColor, lineWidth: showBorder ? 1 : 0)
            )
            .clipShape(RoundedRectangle(cornerRadius: 999))
        }
        .buttonStyle(.plain)
        .disabled(!isEnabled)
        .allowsHitTesting(isTappable)
    }
}

// MARK: - Button Size Frame

/// Applies size-specific frame constraints.
/// Standard: full-width, fixed height.
/// Small/Compact: intrinsic width with min/max guardrails, fixed height.
private extension View {
    @ViewBuilder
    func buttonSizeFrame(_ size: IDSButtonSize) -> some View {
        if size.isFullWidth {
            self
                .frame(maxWidth: .infinity)
                .frame(height: size.height)
        } else {
            self
                .frame(minWidth: size.minWidth, maxWidth: size.maxWidth)
                .frame(height: size.height)
        }
    }
}

// MARK: - Loading Dots

/// Three circles that fade in and out sequentially (like the iOS typing indicator).
private struct IDSLoadingDots: View {

    let color: Color
    var dotSize: CGFloat = 12

    /// Stagger delay per dot in seconds.
    private let staggerDelay: Double = 0.2

    /// Total duration of one pulse cycle.
    private let cycleDuration: Double = 0.8

    @State private var isAnimating = false

    var body: some View {
        HStack(spacing: IDSSpacing.sm) {
            ForEach(0..<3, id: \.self) { index in
                Circle()
                    .fill(color)
                    .frame(width: dotSize, height: dotSize)
                    .opacity(isAnimating ? 1.0 : 0.3)
                    .animation(
                        .easeInOut(duration: cycleDuration)
                        .repeatForever(autoreverses: true)
                        .delay(Double(index) * staggerDelay),
                        value: isAnimating
                    )
            }
        }
        .onAppear {
            isAnimating = true
        }
    }
}

// MARK: - Preview (Standard)

#Preview("Standard — Default") {
    ScrollView {
        VStack(spacing: IDSSpacing.lg) {
            ForEach(IDSButtonType.allCases, id: \.rawValue) { type in
                IDSButton(type.displayName, type: type) {}
            }
        }
        .padding(.horizontal, IDSSpacing.lg)
        .padding(.vertical, IDSSpacing.xl)
    }
    .background(IDSColors.grayscale00)
}

#Preview("Standard — Loading") {
    ScrollView {
        VStack(spacing: IDSSpacing.lg) {
            ForEach(IDSButtonType.allCases, id: \.rawValue) { type in
                IDSButton(type.displayName, type: type, isLoading: true) {}
            }
        }
        .padding(.horizontal, IDSSpacing.lg)
        .padding(.vertical, IDSSpacing.xl)
    }
    .background(IDSColors.grayscale00)
}

#Preview("Standard — Disabled") {
    ScrollView {
        VStack(spacing: IDSSpacing.lg) {
            ForEach(IDSButtonType.allCases, id: \.rawValue) { type in
                IDSButton(type.displayName, type: type, isEnabled: false) {}
            }
        }
        .padding(.horizontal, IDSSpacing.lg)
        .padding(.vertical, IDSSpacing.xl)
    }
    .background(IDSColors.grayscale00)
}

// MARK: - Preview (Small)

#Preview("Small — Default") {
    ScrollView {
        VStack(spacing: IDSSpacing.lg) {
            ForEach(IDSButtonType.allCases, id: \.rawValue) { type in
                IDSButton(type.displayName, type: type, size: .small) {}
            }
        }
        .padding(.horizontal, IDSSpacing.lg)
        .padding(.vertical, IDSSpacing.xl)
    }
    .background(IDSColors.grayscale00)
}

#Preview("Small — Loading") {
    ScrollView {
        VStack(spacing: IDSSpacing.lg) {
            ForEach(IDSButtonType.allCases, id: \.rawValue) { type in
                IDSButton(type.displayName, type: type, size: .small, isLoading: true) {}
            }
        }
        .padding(.horizontal, IDSSpacing.lg)
        .padding(.vertical, IDSSpacing.xl)
    }
    .background(IDSColors.grayscale00)
}

#Preview("Small — Disabled") {
    ScrollView {
        VStack(spacing: IDSSpacing.lg) {
            ForEach(IDSButtonType.allCases, id: \.rawValue) { type in
                IDSButton(type.displayName, type: type, size: .small, isEnabled: false) {}
            }
        }
        .padding(.horizontal, IDSSpacing.lg)
        .padding(.vertical, IDSSpacing.xl)
    }
    .background(IDSColors.grayscale00)
}

// MARK: - Preview (Compact)

#Preview("Compact — Default") {
    ScrollView {
        HStack(spacing: IDSSpacing.lg) {
            ForEach(IDSButtonType.allCases, id: \.rawValue) { type in
                IDSButton(type.displayName, type: type, size: .compact) {}
            }
        }
        .padding(.horizontal, IDSSpacing.lg)
        .padding(.vertical, IDSSpacing.xl)
    }
    .background(IDSColors.grayscale00)
}

#Preview("Compact — Loading") {
    ScrollView {
        HStack(spacing: IDSSpacing.lg) {
            ForEach(IDSButtonType.allCases, id: \.rawValue) { type in
                IDSButton(type.displayName, type: type, size: .compact, isLoading: true) {}
            }
        }
        .padding(.horizontal, IDSSpacing.lg)
        .padding(.vertical, IDSSpacing.xl)
    }
    .background(IDSColors.grayscale00)
}

#Preview("Compact — Disabled") {
    ScrollView {
        HStack(spacing: IDSSpacing.lg) {
            ForEach(IDSButtonType.allCases, id: \.rawValue) { type in
                IDSButton(type.displayName, type: type, size: .compact, isEnabled: false) {}
            }
        }
        .padding(.horizontal, IDSSpacing.lg)
        .padding(.vertical, IDSSpacing.xl)
    }
    .background(IDSColors.grayscale00)
}
