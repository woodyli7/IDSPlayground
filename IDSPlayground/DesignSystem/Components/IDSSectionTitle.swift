//
//  IDSSectionTitle.swift
//  IDSPlayground
//
//  IDS reusable section title component — maps to Figma "IDS.SectionTitle".
//  3 hierarchies (Headline, Title, Subtitle) × contained/not-contained,
//  with optional secondary text, leading slot, and trailing slot.
//

import SwiftUI

// MARK: - Hierarchy

/// The typography level of an IDSSectionTitle.
enum IDSSectionTitleHierarchy: String, CaseIterable {
    case headline
    case title
    case subtitle

    /// Human-readable name for previews and catalog.
    var displayName: String {
        switch self {
        case .headline: return "Headline"
        case .title: return "Title"
        case .subtitle: return "Subtitle"
        }
    }

    /// Font for the title text.
    var font: Font {
        switch self {
        case .headline: return IDSTypography.headline
        case .title: return IDSTypography.title
        case .subtitle: return IDSTypography.subtitle
        }
    }

    /// Line height for the title text.
    var lineHeight: CGFloat {
        switch self {
        case .headline: return IDSTypography.headlineLineHeight
        case .title: return IDSTypography.titleLineHeight
        case .subtitle: return IDSTypography.subtitleLineHeight
        }
    }
}

// MARK: - IDSSectionTitle

/// A section header with a title, optional secondary text, and optional
/// leading/trailing content slots.
///
/// Usage:
/// ```
/// // Headline — contained (default)
/// IDSSectionTitle("Headline section")
///
/// // Title with secondary text
/// IDSSectionTitle("Section title", hierarchy: .title, secondaryText: "Description")
///
/// // Subtitle, not contained, with trailing compact button
/// IDSSectionTitle("Section title", hierarchy: .subtitle, isContained: false) {
///     IDSButton("Action", type: .tertiary, size: .compact) {}
/// }
///
/// // With both leading and trailing content
/// IDSSectionTitle("Section title", hierarchy: .title, leading: {
///     Image("IDS-icon-marker")
///         .renderingMode(.template)
///         .frame(width: 24, height: 24)
/// }) {
///     IDSButton("Action", type: .tertiary, size: .compact) {}
/// }
/// ```
struct IDSSectionTitle<Leading: View, Trailing: View>: View {

    let title: String
    let hierarchy: IDSSectionTitleHierarchy
    let isContained: Bool
    let secondaryText: String?
    let titleColor: Color
    let leading: Leading
    let trailing: Trailing

    // MARK: Init — Leading + Trailing

    init(
        _ title: String,
        hierarchy: IDSSectionTitleHierarchy = .headline,
        isContained: Bool = true,
        secondaryText: String? = nil,
        titleColor: Color = IDSColors.grayscale80,
        @ViewBuilder leading: () -> Leading,
        @ViewBuilder trailing: () -> Trailing
    ) {
        self.title = title
        self.hierarchy = hierarchy
        self.isContained = isContained
        self.secondaryText = secondaryText
        self.titleColor = titleColor
        self.leading = leading()
        self.trailing = trailing()
    }

    // MARK: Body

    var body: some View {
        HStack(spacing: IDSSpacing.sm) {
            // Leading slot
            leading

            // Text content
            VStack(alignment: .leading, spacing: IDSSpacing.none) {
                Text(title)
                    .font(hierarchy.font)
                    .foregroundColor(titleColor)

                if let secondaryText {
                    Text(secondaryText)
                        .font(IDSTypography.bodyRegular)
                        .foregroundColor(IDSColors.grayscale80)
                }
            }

            // Push trailing content to the right edge
            Spacer(minLength: IDSSpacing.none)

            // Trailing slot
            trailing
        }
        .padding(
            .horizontal,
            isContained ? IDSSpacing.lg : IDSSpacing.none
        )
        .padding(
            .vertical,
            isContained ? IDSSpacing.sm : IDSSpacing.none
        )
        .frame(minWidth: 240)
    }
}

// MARK: - Convenience Inits

extension IDSSectionTitle where Leading == EmptyView, Trailing == EmptyView {

    /// Section title with no leading or trailing content.
    init(
        _ title: String,
        hierarchy: IDSSectionTitleHierarchy = .headline,
        isContained: Bool = true,
        secondaryText: String? = nil,
        titleColor: Color = IDSColors.grayscale80
    ) {
        self.init(
            title,
            hierarchy: hierarchy,
            isContained: isContained,
            secondaryText: secondaryText,
            titleColor: titleColor,
            leading: { EmptyView() },
            trailing: { EmptyView() }
        )
    }
}

extension IDSSectionTitle where Leading == EmptyView {

    /// Section title with trailing content only (most common).
    init(
        _ title: String,
        hierarchy: IDSSectionTitleHierarchy = .headline,
        isContained: Bool = true,
        secondaryText: String? = nil,
        titleColor: Color = IDSColors.grayscale80,
        @ViewBuilder trailing: () -> Trailing
    ) {
        self.init(
            title,
            hierarchy: hierarchy,
            isContained: isContained,
            secondaryText: secondaryText,
            titleColor: titleColor,
            leading: { EmptyView() },
            trailing: trailing
        )
    }
}

// Note: No leading-only convenience init to avoid Swift trailing-closure
// ambiguity with the trailing-only init. For leading content without
// trailing, use the full init with explicit labels:
//   IDSSectionTitle("Title", leading: { icon }, trailing: { EmptyView() })

// MARK: - Preview

#Preview("All Hierarchies — Contained") {
    VStack(spacing: IDSSpacing.lg) {
        IDSSectionTitle("Headline section")
        IDSSectionTitle("Section title in title", hierarchy: .title)
        IDSSectionTitle("Section title in subtitle", hierarchy: .subtitle)
    }
    .padding(.vertical, IDSSpacing.xl)
    .background(IDSColors.grayscale00)
}

#Preview("All Hierarchies — Not Contained") {
    VStack(spacing: IDSSpacing.lg) {
        IDSSectionTitle("Headline section", isContained: false)
        IDSSectionTitle("Section title in title", hierarchy: .title, isContained: false)
        IDSSectionTitle("Section title in subtitle", hierarchy: .subtitle, isContained: false)
    }
    .padding(.horizontal, IDSSpacing.lg)
    .padding(.vertical, IDSSpacing.xl)
    .background(IDSColors.grayscale00)
}

#Preview("With Secondary Text") {
    VStack(spacing: IDSSpacing.lg) {
        IDSSectionTitle(
            "Headline section",
            secondaryText: "Secondary text"
        )
        IDSSectionTitle(
            "Section title in title",
            hierarchy: .title,
            secondaryText: "Secondary text"
        )
        IDSSectionTitle(
            "Section title in subtitle",
            hierarchy: .subtitle,
            secondaryText: "Secondary text"
        )
    }
    .padding(.vertical, IDSSpacing.xl)
    .background(IDSColors.grayscale00)
}

#Preview("With Trailing Button") {
    VStack(spacing: IDSSpacing.lg) {
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
    .padding(.vertical, IDSSpacing.xl)
    .background(IDSColors.grayscale00)
}

#Preview("Not Contained + Trailing Button") {
    VStack(spacing: IDSSpacing.lg) {
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
    .padding(.horizontal, IDSSpacing.lg)
    .padding(.vertical, IDSSpacing.xl)
    .background(IDSColors.grayscale00)
}
