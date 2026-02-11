//
//  ComponentCatalogView.swift
//  IDSPlayground
//
//  A scrollable catalog of all IDS components and their states.
//  Use this to visually verify every component in a real app context.
//
//  How to add a new component:
//  1. Build your IDS{Name}.swift with a #Preview block
//  2. Add a new section below using the catalogSection helper
//  3. Show all states/variants of the component
//

import SwiftUI

struct ComponentCatalogView: View {
    var showHeader: Bool = true

    var body: some View {
        ScrollView {
            VStack(spacing: IDSSpacing.none) {

                // -- Header --
                if showHeader {
                    catalogHeader
                }

                // ============================================
                // Add new component sections below this line.
                // Use catalogSection for consistent formatting.
                // ============================================

                idsButtonSection

                idsButtonSmallSection

                idsButtonCompactSection

                idsSectionTitleSection

                idsContentRowSection

                idsImageSection

                idsTopNavSection

                idsBadgeSection

                idsTabsSection

                idsAddressFieldSection
            }
        }
        .background(IDSColors.brandTertiaryLight)
    }
}

// MARK: - Header

private extension ComponentCatalogView {

    var catalogHeader: some View {
        VStack(spacing: IDSSpacing.sm) {
            Text("Component Catalog")
                .font(IDSTypography.headline)
                .foregroundColor(IDSColors.grayscale80)

            Text("All IDS components and their states")
                .font(IDSTypography.bodyRegular)
                .foregroundColor(IDSColors.contentSecondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, IDSSpacing.xxl)
        .background(IDSColors.grayscale00)
    }
}

// MARK: - IDSButton Section

private extension ComponentCatalogView {

    var idsButtonSection: some View {
        VStack(spacing: IDSSpacing.xl) {
            // Default state — all types
            catalogSection("IDSButton — Default") {
                ForEach(IDSButtonType.allCases, id: \.rawValue) { type in
                    IDSButton(type.displayName, type: type) {}
                }
            }

            // Loading state — all types
            catalogSection("IDSButton — Loading") {
                ForEach(IDSButtonType.allCases, id: \.rawValue) { type in
                    IDSButton(type.displayName, type: type, isLoading: true) {}
                }
            }

            // Disabled state — all types
            catalogSection("IDSButton — Disabled") {
                ForEach(IDSButtonType.allCases, id: \.rawValue) { type in
                    IDSButton(type.displayName, type: type, isEnabled: false) {}
                }
            }
        }
    }
}

// MARK: - IDSButton Small Section

private extension ComponentCatalogView {

    var idsButtonSmallSection: some View {
        VStack(spacing: IDSSpacing.xl) {
            // Default state — all types
            catalogSection("IDSButton Small — Default") {
                ForEach(IDSButtonType.allCases, id: \.rawValue) { type in
                    IDSButton(type.displayName, type: type, size: .small) {}
                }
            }

            // Loading state — all types
            catalogSection("IDSButton Small — Loading") {
                ForEach(IDSButtonType.allCases, id: \.rawValue) { type in
                    IDSButton(type.displayName, type: type, size: .small, isLoading: true) {}
                }
            }

            // Disabled state — all types
            catalogSection("IDSButton Small — Disabled") {
                ForEach(IDSButtonType.allCases, id: \.rawValue) { type in
                    IDSButton(type.displayName, type: type, size: .small, isEnabled: false) {}
                }
            }
        }
    }
}

// MARK: - IDSButton Compact Section

private extension ComponentCatalogView {

    var idsButtonCompactSection: some View {
        VStack(spacing: IDSSpacing.xl) {
            // Default state — all types
            catalogSection("IDSButton Compact — Default") {
                HStack(spacing: IDSSpacing.sm) {
                    ForEach(IDSButtonType.allCases, id: \.rawValue) { type in
                        IDSButton(type.displayName, type: type, size: .compact) {}
                    }
                }
            }

            // Loading state — all types
            catalogSection("IDSButton Compact — Loading") {
                HStack(spacing: IDSSpacing.sm) {
                    ForEach(IDSButtonType.allCases, id: \.rawValue) { type in
                        IDSButton(type.displayName, type: type, size: .compact, isLoading: true) {}
                    }
                }
            }

            // Disabled state — all types
            catalogSection("IDSButton Compact — Disabled") {
                HStack(spacing: IDSSpacing.sm) {
                    ForEach(IDSButtonType.allCases, id: \.rawValue) { type in
                        IDSButton(type.displayName, type: type, size: .compact, isEnabled: false) {}
                    }
                }
            }
        }
    }
}

// MARK: - IDSSectionTitle Section

private extension ComponentCatalogView {

    var idsSectionTitleSection: some View {
        VStack(spacing: IDSSpacing.xl) {
            // All hierarchies — contained
            catalogSection("IDSSectionTitle — Contained") {
                IDSSectionTitle("Headline section")
                IDSSectionTitle("Section title in title", hierarchy: .title)
                IDSSectionTitle("Section title in subtitle", hierarchy: .subtitle)
            }

            // All hierarchies — not contained
            catalogSection("IDSSectionTitle — Not Contained") {
                IDSSectionTitle("Headline section", isContained: false)
                IDSSectionTitle("Section title in title", hierarchy: .title, isContained: false)
                IDSSectionTitle("Section title in subtitle", hierarchy: .subtitle, isContained: false)
            }

            // With secondary text
            catalogSection("IDSSectionTitle — Secondary Text") {
                IDSSectionTitle(
                    "Headline section",
                    secondaryText: "Secondary text"
                )
                IDSSectionTitle(
                    "Section title in title",
                    hierarchy: .title,
                    secondaryText: "Secondary text"
                )
            }

            // With trailing compact button
            catalogSection("IDSSectionTitle — Trailing Button") {
                IDSSectionTitle("Headline section") {
                    IDSButton("Compact", type: .tertiary, size: .compact) {}
                }
                IDSSectionTitle("Section title in title", hierarchy: .title) {
                    IDSButton("Compact", type: .tertiary, size: .compact) {}
                }
                IDSSectionTitle("Section title in subtitle", hierarchy: .subtitle) {
                    IDSButton("Compact", type: .tertiary, size: .compact) {}
                }
            }

            // Not contained with trailing button
            catalogSection("IDSSectionTitle — Not Contained + Button") {
                IDSSectionTitle("Headline section", isContained: false) {
                    IDSButton("Compact", type: .tertiary, size: .compact) {}
                }
                IDSSectionTitle("Section title in title", hierarchy: .title, isContained: false) {
                    IDSButton("Compact", type: .tertiary, size: .compact) {}
                }
                IDSSectionTitle("Section title in subtitle", hierarchy: .subtitle, isContained: false) {
                    IDSButton("Compact", type: .tertiary, size: .compact) {}
                }
            }
        }
    }
}

// MARK: - IDSContentRow Section

private extension ComponentCatalogView {

    var idsContentRowSection: some View {
        VStack(spacing: IDSSpacing.xl) {
            // String only — Standard
            catalogSection("IDSContentRow — String Only") {
                IDSContentRow(
                    title: "Title line is optional",
                    subtitle: "Optional secondary content"
                )
                IDSContentRow(
                    subtitle: "Optional secondary content"
                )
            }

            // Icon — Standard
            catalogSection("IDSContentRow — Icon") {
                IDSContentRow(
                    title: "Title line is optional",
                    subtitle: "Optional secondary content"
                ) {
                    Image("IDS-icon-marker")
                        .renderingMode(.template)
                        .frame(width: 24, height: 24)
                }
                IDSContentRow(
                    subtitle: "Optional secondary content"
                ) {
                    Image("IDS-icon-marker")
                        .renderingMode(.template)
                        .frame(width: 24, height: 24)
                }
            }

            // Avatar — Standard
            catalogSection("IDSContentRow — Avatar") {
                IDSContentRow(
                    title: "Title line is optional",
                    subtitle: "Optional secondary content"
                ) {
                    Image("IDS-avatar-retailer")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 48, height: 36)
                        .clipShape(RoundedRectangle(cornerRadius: IDSSpacing.sm))
                }
                IDSContentRow(
                    subtitle: "Optional secondary content"
                ) {
                    Image("IDS-avatar-retailer")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 48, height: 36)
                        .clipShape(RoundedRectangle(cornerRadius: IDSSpacing.sm))
                }
            }

            // Card style
            catalogSection("IDSContentRow — Card") {
                IDSContentRow(
                    title: "Title line is optional",
                    subtitle: "Optional secondary content",
                    isCard: true
                )
                IDSContentRow(
                    title: "Title line is optional",
                    subtitle: "Optional secondary content",
                    isCard: true
                ) {
                    Image("IDS-icon-marker")
                        .renderingMode(.template)
                        .frame(width: 24, height: 24)
                }
                IDSContentRow(
                    title: "Title line is optional",
                    subtitle: "Optional secondary content",
                    isCard: true
                ) {
                    Image("IDS-avatar-retailer")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 48, height: 36)
                        .clipShape(RoundedRectangle(cornerRadius: IDSSpacing.sm))
                }
            }

            // Compact inset
            catalogSection("IDSContentRow — Compact") {
                IDSContentRow(
                    title: "Title line is optional",
                    subtitle: "Optional secondary content",
                    inset: .compact
                )
                IDSContentRow(
                    title: "Title line is optional",
                    subtitle: "Optional secondary content",
                    inset: .compact
                ) {
                    Image("IDS-icon-marker")
                        .renderingMode(.template)
                        .frame(width: 24, height: 24)
                }
            }

            // With trailing content
            catalogSection("IDSContentRow — Trailing") {
                IDSContentRow(
                    title: "Title line is optional",
                    subtitle: "Optional secondary content",
                    trailingTitle: "Right Line 1",
                    trailingSubtitle: "Right Line 2"
                )
                IDSContentRow(
                    title: "Title line is optional",
                    subtitle: "Optional secondary content",
                    trailingTitle: "Right Line 1",
                    trailingSubtitle: "Right Line 2"
                ) {
                    Image("IDS-icon-marker")
                        .renderingMode(.template)
                        .frame(width: 24, height: 24)
                }
            }

            // Disabled state
            catalogSection("IDSContentRow — Disabled") {
                IDSContentRow(
                    title: "Title line is optional",
                    subtitle: "Optional secondary content",
                    isDisabled: true
                )
                IDSContentRow(
                    title: "Title line is optional",
                    subtitle: "Optional secondary content",
                    isDisabled: true
                ) {
                    Image("IDS-icon-marker")
                        .renderingMode(.template)
                        .frame(width: 24, height: 24)
                }
                IDSContentRow(
                    title: "Title line is optional",
                    subtitle: "Optional secondary content",
                    isDisabled: true
                ) {
                    Image("IDS-avatar-retailer")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 48, height: 36)
                        .clipShape(RoundedRectangle(cornerRadius: IDSSpacing.sm))
                }
            }
        }
    }
}

// MARK: - IDSImage Section

private extension ComponentCatalogView {

    var idsImageSection: some View {
        VStack(spacing: IDSSpacing.xl) {
            catalogSection("IDSImage — Standard") {
                IDSImage("ImagePlaceholder")
            }
        }
    }
}

// MARK: - IDSTopNav Section

private extension ComponentCatalogView {

    var idsTopNavSection: some View {
        VStack(spacing: IDSSpacing.xl) {
            // Full — back + title + save + share
            catalogSection("IDSTopNav — Full") {
                IDSTopNav(
                    title: "Surface title",
                    leadingIcon: "IDS.Icon.ArrowLeft",
                    leadingAction: {},
                    trailingSecondaryIcon: "IDS.Icon.Save",
                    trailingSecondaryAction: {},
                    trailingPrimaryIcon: "IDS.Icon.ShareiOS",
                    trailingPrimaryAction: {}
                )
            }

            // Back + title only
            catalogSection("IDSTopNav — Back + Title") {
                IDSTopNav(
                    title: "Surface title",
                    leadingIcon: "IDS.Icon.ArrowLeft",
                    leadingAction: {}
                )
            }

            // Title only
            catalogSection("IDSTopNav — Title Only") {
                IDSTopNav(title: "Surface title")
            }

            // Title + trailing icons
            catalogSection("IDSTopNav — Title + Trailing") {
                IDSTopNav(
                    title: "Surface title",
                    trailingSecondaryIcon: "IDS.Icon.Save",
                    trailingSecondaryAction: {},
                    trailingPrimaryIcon: "IDS.Icon.ShareiOS",
                    trailingPrimaryAction: {}
                )
            }

            // Long title truncation
            catalogSection("IDSTopNav — Long Title") {
                IDSTopNav(
                    title: "This is a very long surface title that truncates",
                    leadingIcon: "IDS.Icon.ArrowLeft",
                    leadingAction: {},
                    trailingSecondaryIcon: "IDS.Icon.Save",
                    trailingSecondaryAction: {},
                    trailingPrimaryIcon: "IDS.Icon.ShareiOS",
                    trailingPrimaryAction: {}
                )
            }
        }
    }
}

// MARK: - IDSBadge Section

private extension ComponentCatalogView {

    var idsBadgeSection: some View {
        VStack(spacing: IDSSpacing.xl) {
            // Standard — Outlined
            catalogSection("IDSBadge — Standard Outlined") {
                HStack(spacing: IDSSpacing.lg) {
                    IDSBadge(type: .counter(99), appearance: .standard, isOutlined: true)
                    IDSBadge(type: .dot, appearance: .standard, isOutlined: true)
                    IDSBadge(type: .new, appearance: .standard, isOutlined: true)
                }
            }

            // Standard — Not Outlined
            catalogSection("IDSBadge — Standard") {
                HStack(spacing: IDSSpacing.lg) {
                    IDSBadge(type: .counter(99), appearance: .standard, isOutlined: false)
                    IDSBadge(type: .dot, appearance: .standard, isOutlined: false)
                    IDSBadge(type: .new, appearance: .standard, isOutlined: false)
                }
            }

            // Critical — Outlined
            catalogSection("IDSBadge — Critical Outlined") {
                HStack(spacing: IDSSpacing.lg) {
                    IDSBadge(type: .counter(99), appearance: .critical, isOutlined: true)
                    IDSBadge(type: .dot, appearance: .critical, isOutlined: true)
                    IDSBadge(type: .new, appearance: .critical, isOutlined: true)
                }
            }

            // Critical — Not Outlined
            catalogSection("IDSBadge — Critical") {
                HStack(spacing: IDSSpacing.lg) {
                    IDSBadge(type: .counter(99), appearance: .critical, isOutlined: false)
                    IDSBadge(type: .dot, appearance: .critical, isOutlined: false)
                    IDSBadge(type: .new, appearance: .critical, isOutlined: false)
                }
            }
        }
    }
}

// MARK: - IDSTabs Section

private extension ComponentCatalogView {

    var idsTabsSection: some View {
        VStack(spacing: IDSSpacing.xl) {
            // 2 Tabs — fixed equal-width
            catalogSection("IDSTabs — 2 Tabs") {
                IDSTabsCatalogItem(tabs: [
                    IDSTabItem(title: "Tab"),
                    IDSTabItem(title: "Tab")
                ])
            }

            // 3 Tabs — scrollable
            catalogSection("IDSTabs — 3 Tabs") {
                IDSTabsCatalogItem(tabs: [
                    IDSTabItem(title: "Tab"),
                    IDSTabItem(title: "Tab"),
                    IDSTabItem(title: "Tab")
                ])
            }

            // 4+ Tabs — scrollable
            catalogSection("IDSTabs — 4+ Tabs") {
                IDSTabsCatalogItem(tabs: [
                    IDSTabItem(title: "Tab"),
                    IDSTabItem(title: "Tab"),
                    IDSTabItem(title: "Tab"),
                    IDSTabItem(title: "Tab"),
                    IDSTabItem(title: "Tab")
                ])
            }

            // With badges
            catalogSection("IDSTabs — With Badges") {
                IDSTabsCatalogItem(tabs: [
                    IDSTabItem(title: "Tab", badgeCount: 99),
                    IDSTabItem(title: "Tab", badgeCount: 99)
                ])
            }

            // Long names — scrollable
            catalogSection("IDSTabs — Long Names") {
                IDSTabsCatalogItem(tabs: [
                    IDSTabItem(title: "this is a long name"),
                    IDSTabItem(title: "This is another long name"),
                    IDSTabItem(title: "This is even longer")
                ])
            }
        }
    }
}

/// Interactive wrapper providing @State for IDSTabs in the catalog.
private struct IDSTabsCatalogItem: View {
    let tabs: [IDSTabItem]
    @State private var selectedIndex = 0

    var body: some View {
        IDSTabs(tabs: tabs, selectedIndex: $selectedIndex)
    }
}

// MARK: - IDSAddressField Section

private extension ComponentCatalogView {

    var idsAddressFieldSection: some View {
        VStack(spacing: IDSSpacing.xl) {
            // Default — empty field
            catalogSection("IDSAddressField — Default") {
                IDSAddressField(text: .constant(""))
            }

            // Filled — pre-populated text
            catalogSection("IDSAddressField — Filled") {
                IDSAddressField(text: .constant("14 North Moore Street"))
            }

            // Invalid — empty submit (forced via preview state)
            catalogSection("IDSAddressField — Invalid") {
                IDSAddressField(text: .constant(""))
                    .previewState(.invalid)
            }
        }
    }
}

// MARK: - Section Helper

/// Reusable section wrapper for each component in the catalog.
/// Usage:
///   catalogSection("IDSButton") {
///       IDSButton("Continue", style: .primary) {}
///       IDSButton("Continue", style: .primary, isEnabled: false) {}
///   }
extension ComponentCatalogView {

    func catalogSection<Content: View>(
        _ title: String,
        @ViewBuilder content: () -> Content
    ) -> some View {
        VStack(alignment: .leading, spacing: IDSSpacing.lg) {

            // Section title
            Text(title)
                .font(IDSTypography.title)
                .foregroundColor(IDSColors.grayscale80)
                .padding(.horizontal, IDSSpacing.lg)

            // Component variants
            VStack(spacing: IDSSpacing.md) {
                content()
            }
            .frame(maxWidth: .infinity)
            .padding(IDSSpacing.lg)
            .background(IDSColors.grayscale00)
            .cornerRadius(12)
            .padding(.horizontal, IDSSpacing.lg)
        }
        .padding(.top, IDSSpacing.xl)
    }
}

#Preview {
    ComponentCatalogView()
}
