//
//  IDSTypography.swift
//  IDSPlayground
//
//  Design tokens: Typography from the Instacart Design System (IDS).
//  Font names discovered from TTF PostScript metadata.
//
//  IMPORTANT: These fonts must be registered in Info.plist under
//  "Fonts provided by application" for them to load at runtime.
//

import SwiftUI

enum IDSTypography {

    // MARK: - Font Family Names (PostScript names from TTF files)

    private static let subheadSemiBold = "InstacartSansSubheadv1.1-SemiBold"
    private static let subheadBold = "InstacartSansSubheadv1.1-Bold"
    private static let textRegular = "InstacartSansTextv1.1-Regular"
    private static let textSemiBold = "InstacartSansTextv1.1-SemiBold"
    private static let textBold = "InstacartSansTextv1.1-Bold"

    // MARK: - Type Styles

    /// Headline: Instacart Sans Subhead, SemiBold, 24px, lineHeight 28px
    /// Used for: Screen titles (e.g., "Verify mailing address")
    static let headline = Font.custom(subheadSemiBold, size: 24)
    static let headlineLineHeight: CGFloat = 28

    /// Title: Instacart Sans Subhead, SemiBold, 18px, lineHeight 22px
    /// Used for: Section titles, address display
    static let title = Font.custom(subheadSemiBold, size: 18)
    static let titleLineHeight: CGFloat = 22

    /// Body Regular: Instacart Sans Text, Regular, 12px, lineHeight 18px
    /// Used for: Input fields, placeholder text
    static let bodyRegular = Font.custom(textRegular, size: 12)
    static let bodyLineHeight: CGFloat = 18

    /// Body Emphasized: Instacart Sans Text, SemiBold, 12px, lineHeight 18px
    /// Used for: Content rows, descriptions
    static let bodyEmphasized = Font.custom(textSemiBold, size: 12)
    static let bodyEmphasizedLineHeight: CGFloat = 18

    /// Accent Regular: Instacart Sans Text, Regular, 10px, lineHeight 14px
    /// Used for: Error text, small labels
    static let accentRegular = Font.custom(textRegular, size: 10)
    static let accentLineHeight: CGFloat = 14

    /// Accent Emphasized: Instacart Sans Text, SemiBold, 10px, lineHeight 14px
    /// Used for: Badge counter text, badge "New" label
    static let accentEmphasized = Font.custom(textSemiBold, size: 10)
    static let accentEmphasizedLineHeight: CGFloat = 14

    /// Subtitle: Instacart Sans Text, SemiBold, 14px, lineHeight 20px
    /// Used for: Section subtitles (e.g., "What type of vehicle are you driving?")
    static let subtitle = Font.custom(textSemiBold, size: 14)
    static let subtitleLineHeight: CGFloat = 20

    /// Button: Instacart Sans Subhead, SemiBold, 18px, lineHeight 18px
    /// Used for: Button labels (standard size)
    static let button = Font.custom(subheadSemiBold, size: 18)
    static let buttonLineHeight: CGFloat = 18

    /// Button Small: Instacart Sans Subhead, SemiBold, 14px, lineHeight 18px
    /// Used for: Button labels (small size)
    static let buttonSmall = Font.custom(subheadSemiBold, size: 14)
    static let buttonSmallLineHeight: CGFloat = 18
}
