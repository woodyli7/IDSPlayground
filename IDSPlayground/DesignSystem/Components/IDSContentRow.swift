//
//  IDSContentRow.swift
//  IDSPlayground
//
//  IDS reusable content row component — maps to Figma "IDS.Row / Content Row".
//  Displays static information with text and optional visual elements.
//
//  3 leading types (String only, Icon, Avatar)
//  × 2 vertical insets (Standard, Compact)
//  × 2 containers (Plain, Card)
//  × 2 states (Default, Disabled)
//

import SwiftUI

// MARK: - Vertical Inset

/// Vertical padding mode for an IDSContentRow.
enum IDSContentRowInset: String, CaseIterable {
    case standard
    case compact

    /// Human-readable name for previews and catalog.
    var displayName: String {
        switch self {
        case .standard: return "Standard"
        case .compact: return "Compact"
        }
    }

    /// Vertical padding value.
    var verticalPadding: CGFloat {
        switch self {
        case .standard: return IDSSpacing.md  // 12px
        case .compact: return IDSSpacing.sm   // 8px
        }
    }
}

// MARK: - IDSContentRow

/// A content row for displaying static information with text and optional visual elements.
/// Maps to Figma "IDS.Row / Content Row".
///
/// Usage:
/// ```
/// // String only
/// IDSContentRow(title: "Order #1234", subtitle: "Delivered")
///
/// // With icon
/// IDSContentRow(title: "Location", subtitle: "123 Main St") {
///     Image("IDS-icon-marker")
///         .renderingMode(.template)
///         .frame(width: 24, height: 24)
/// }
///
/// // With avatar
/// IDSContentRow(title: "Sprouts", subtitle: "Grocery") {
///     Image("IDS-avatar-retailer")
///         .resizable()
///         .aspectRatio(contentMode: .fill)
///         .frame(width: 48, height: 36)
///         .clipShape(RoundedRectangle(cornerRadius: 8))
/// }
///
/// // Card style with trailing content
/// IDSContentRow(
///     title: "Subtotal",
///     trailingTitle: "$12.99",
///     isCard: true
/// )
/// ```
struct IDSContentRow<Leading: View>: View {

    let title: String?
    let subtitle: String?
    let tertiaryText: String?
    let trailingTitle: String?
    let trailingSubtitle: String?
    let inset: IDSContentRowInset
    let isCard: Bool
    let isDisabled: Bool
    let leading: Leading

    init(
        title: String? = nil,
        subtitle: String? = nil,
        tertiaryText: String? = nil,
        trailingTitle: String? = nil,
        trailingSubtitle: String? = nil,
        inset: IDSContentRowInset = .standard,
        isCard: Bool = false,
        isDisabled: Bool = false,
        @ViewBuilder leading: () -> Leading
    ) {
        self.title = title
        self.subtitle = subtitle
        self.tertiaryText = tertiaryText
        self.trailingTitle = trailingTitle
        self.trailingSubtitle = trailingSubtitle
        self.inset = inset
        self.isCard = isCard
        self.isDisabled = isDisabled
        self.leading = leading()
    }

    // MARK: Resolved Colors

    /// Effective color for primary text (title, trailing title).
    private var resolvedPrimaryColor: Color {
        isDisabled ? IDSColors.buttonDisabledContent : IDSColors.grayscale80
    }

    /// Effective color for secondary text (subtitle, tertiary, trailing subtitle).
    private var resolvedSecondaryColor: Color {
        isDisabled ? IDSColors.buttonDisabledContent : IDSColors.contentSecondary
    }

    // MARK: Computed

    /// Whether a leading element is present (icon or avatar).
    private var hasLeading: Bool {
        Leading.self != EmptyView.self
    }

    /// Whether trailing content is present.
    private var hasTrailing: Bool {
        trailingTitle != nil || trailingSubtitle != nil
    }

    // MARK: Body

    var body: some View {
        if isCard {
            rowContent
                .background(IDSColors.grayscale00)
                .clipShape(RoundedRectangle(cornerRadius: IDSSpacing.sm))
                .overlay(
                    RoundedRectangle(cornerRadius: IDSSpacing.sm)
                        .stroke(IDSColors.grayscale20, lineWidth: 1)
                )
                .padding(.horizontal, IDSSpacing.lg)
        } else {
            rowContent
                .background(IDSColors.grayscale00)
        }
    }
}

// MARK: - Row Layout

private extension IDSContentRow {

    var rowContent: some View {
        HStack(spacing: hasLeading ? IDSSpacing.sm : IDSSpacing.none) {
            // Leading element (icon or avatar)
            if hasLeading {
                leading
                    .foregroundStyle(resolvedPrimaryColor)
            }

            // Text content (title + subtitle + tertiary)
            textContent
                .frame(maxWidth: .infinity, alignment: .leading)

            // Trailing content (right-side text)
            if hasTrailing {
                trailingContent
            }
        }
        .padding(.horizontal, IDSSpacing.lg)
        .padding(.vertical, inset.verticalPadding)
    }

    @ViewBuilder
    var textContent: some View {
        VStack(alignment: .leading, spacing: IDSSpacing.none) {
            if let title {
                // Primary line — emphasized weight, primary color
                Text(title)
                    .font(IDSTypography.bodyEmphasized)
                    .foregroundColor(resolvedPrimaryColor)

                // Secondary + tertiary below the title
                if let subtitle {
                    Text(subtitle)
                        .font(IDSTypography.bodyRegular)
                        .foregroundColor(resolvedSecondaryColor)

                    if let tertiaryText {
                        Text(tertiaryText)
                            .font(IDSTypography.bodyRegular)
                            .foregroundColor(resolvedSecondaryColor)
                    }
                }
            } else if let subtitle {
                // No title — subtitle is the sole content in regular weight
                Text(subtitle)
                    .font(IDSTypography.bodyRegular)
                    .foregroundColor(resolvedSecondaryColor)

                if let tertiaryText {
                    Text(tertiaryText)
                        .font(IDSTypography.bodyRegular)
                        .foregroundColor(resolvedSecondaryColor)
                }
            }
        }
    }

    var trailingContent: some View {
        VStack(alignment: .trailing, spacing: IDSSpacing.none) {
            if let trailingTitle {
                Text(trailingTitle)
                    .font(IDSTypography.bodyEmphasized)
                    .foregroundColor(resolvedPrimaryColor)
            }
            if let trailingSubtitle {
                Text(trailingSubtitle)
                    .font(IDSTypography.bodyRegular)
                    .foregroundColor(resolvedSecondaryColor)
            }
        }
    }
}

// MARK: - String Only Convenience Init

extension IDSContentRow where Leading == EmptyView {

    /// Creates a content row with no leading element (String only type).
    init(
        title: String? = nil,
        subtitle: String? = nil,
        tertiaryText: String? = nil,
        trailingTitle: String? = nil,
        trailingSubtitle: String? = nil,
        inset: IDSContentRowInset = .standard,
        isCard: Bool = false,
        isDisabled: Bool = false
    ) {
        self.init(
            title: title,
            subtitle: subtitle,
            tertiaryText: tertiaryText,
            trailingTitle: trailingTitle,
            trailingSubtitle: trailingSubtitle,
            inset: inset,
            isCard: isCard,
            isDisabled: isDisabled,
            leading: { EmptyView() }
        )
    }
}

// MARK: - Preview Helpers

/// Reusable icon leading view for previews.
private struct PreviewIcon: View {
    var body: some View {
        Image("IDS-icon-marker")
            .renderingMode(.template)
            .frame(width: 24, height: 24)
    }
}

/// Reusable avatar leading view for previews.
private struct PreviewAvatar: View {
    var body: some View {
        Image("IDS-avatar-retailer")
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(width: 48, height: 36)
            .clipShape(RoundedRectangle(cornerRadius: IDSSpacing.sm))
    }
}

// MARK: - Previews

#Preview("String Only — Standard") {
    ScrollView {
        VStack(spacing: IDSSpacing.lg) {
            IDSContentRow(
                title: "Title line is optional",
                subtitle: "Optional secondary content"
            )

            IDSContentRow(
                subtitle: "Optional secondary content"
            )

            IDSContentRow(
                title: "Title line is optional",
                subtitle: "Optional secondary content",
                tertiaryText: "Tertiary content is available if secondary is"
            )
        }
        .padding(.vertical, IDSSpacing.xl)
    }
    .background(IDSColors.brandTertiaryLight)
}

#Preview("Icon — Standard") {
    ScrollView {
        VStack(spacing: IDSSpacing.lg) {
            IDSContentRow(
                title: "Title line is optional",
                subtitle: "Optional secondary content"
            ) { PreviewIcon() }

            IDSContentRow(
                subtitle: "Optional secondary content"
            ) { PreviewIcon() }

            IDSContentRow(
                title: "Title line is optional",
                subtitle: "Optional secondary content",
                tertiaryText: "Tertiary content is available if secondary is"
            ) { PreviewIcon() }
        }
        .padding(.vertical, IDSSpacing.xl)
    }
    .background(IDSColors.brandTertiaryLight)
}

#Preview("Avatar — Standard") {
    ScrollView {
        VStack(spacing: IDSSpacing.lg) {
            IDSContentRow(
                title: "Title line is optional",
                subtitle: "Optional secondary content"
            ) { PreviewAvatar() }

            IDSContentRow(
                subtitle: "Optional secondary content"
            ) { PreviewAvatar() }

            IDSContentRow(
                title: "Title line is optional",
                subtitle: "Optional secondary content",
                tertiaryText: "Tertiary content is available if secondary is"
            ) { PreviewAvatar() }
        }
        .padding(.vertical, IDSSpacing.xl)
    }
    .background(IDSColors.brandTertiaryLight)
}

#Preview("Card Style") {
    ScrollView {
        VStack(spacing: IDSSpacing.lg) {
            IDSContentRow(
                title: "Title line is optional",
                subtitle: "Optional secondary content",
                isCard: true
            )

            IDSContentRow(
                title: "Title line is optional",
                subtitle: "Optional secondary content",
                isCard: true
            ) { PreviewIcon() }

            IDSContentRow(
                title: "Title line is optional",
                subtitle: "Optional secondary content",
                isCard: true
            ) { PreviewAvatar() }
        }
        .padding(.vertical, IDSSpacing.xl)
    }
    .background(IDSColors.brandTertiaryLight)
}

#Preview("Compact Inset") {
    ScrollView {
        VStack(spacing: IDSSpacing.lg) {
            IDSContentRow(
                title: "Title line is optional",
                subtitle: "Optional secondary content",
                inset: .compact
            )

            IDSContentRow(
                title: "Title line is optional",
                subtitle: "Optional secondary content",
                inset: .compact
            ) { PreviewIcon() }

            IDSContentRow(
                title: "Title line is optional",
                subtitle: "Optional secondary content",
                inset: .compact
            ) { PreviewAvatar() }
        }
        .padding(.vertical, IDSSpacing.xl)
    }
    .background(IDSColors.brandTertiaryLight)
}

#Preview("With Trailing") {
    ScrollView {
        VStack(spacing: IDSSpacing.lg) {
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
            ) { PreviewIcon() }

            IDSContentRow(
                title: "Title line is optional",
                subtitle: "Optional secondary content",
                trailingTitle: "Right Line 1",
                trailingSubtitle: "Right Line 2"
            ) { PreviewAvatar() }
        }
        .padding(.vertical, IDSSpacing.xl)
    }
    .background(IDSColors.brandTertiaryLight)
}

#Preview("Disabled") {
    ScrollView {
        VStack(spacing: IDSSpacing.lg) {
            IDSContentRow(
                title: "Title line is optional",
                subtitle: "Optional secondary content",
                isDisabled: true
            )

            IDSContentRow(
                title: "Title line is optional",
                subtitle: "Optional secondary content",
                isDisabled: true
            ) { PreviewIcon() }

            IDSContentRow(
                title: "Title line is optional",
                subtitle: "Optional secondary content",
                isDisabled: true
            ) { PreviewAvatar() }
        }
        .padding(.vertical, IDSSpacing.xl)
    }
    .background(IDSColors.brandTertiaryLight)
}

#Preview("Disabled — Card") {
    ScrollView {
        VStack(spacing: IDSSpacing.lg) {
            IDSContentRow(
                title: "Title line is optional",
                subtitle: "Optional secondary content",
                isCard: true,
                isDisabled: true
            )

            IDSContentRow(
                title: "Title line is optional",
                subtitle: "Optional secondary content",
                isCard: true,
                isDisabled: true
            ) { PreviewIcon() }

            IDSContentRow(
                title: "Title line is optional",
                subtitle: "Optional secondary content",
                isCard: true,
                isDisabled: true
            ) { PreviewAvatar() }
        }
        .padding(.vertical, IDSSpacing.xl)
    }
    .background(IDSColors.brandTertiaryLight)
}
