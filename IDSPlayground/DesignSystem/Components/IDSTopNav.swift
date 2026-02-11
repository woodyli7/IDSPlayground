//
//  IDSTopNav.swift
//  IDSPlayground
//
//  IDS reusable top navigation bar — maps to Figma "IDS.TopNav / Standard".
//  White 48px bar with an optional leading icon button, title,
//  and up to two trailing icon buttons. Each slot is independently togglable.
//

import SwiftUI

// MARK: - IDSTopNav

/// A top navigation bar with optional leading icon, title, and up to two
/// trailing icon buttons.
///
/// Usage:
/// ```
/// // Full nav: back + title + save + share
/// IDSTopNav(
///     title: "Surface title",
///     leadingIcon: "IDS.Icon.ArrowLeft",
///     leadingAction: { /* go back */ },
///     trailingSecondaryIcon: "IDS.Icon.Save",
///     trailingSecondaryAction: { /* save */ },
///     trailingPrimaryIcon: "IDS.Icon.ShareiOS",
///     trailingPrimaryAction: { /* share */ }
/// )
///
/// // Back button + title only
/// IDSTopNav(
///     title: "Surface title",
///     leadingIcon: "IDS.Icon.ArrowLeft",
///     leadingAction: { /* go back */ }
/// )
///
/// // Title only
/// IDSTopNav(title: "Surface title")
/// ```
struct IDSTopNav: View {

    // MARK: Properties

    /// Title text displayed in the center. Nil hides the title.
    let title: String?

    /// Leading icon asset name (e.g. "IDS.Icon.ArrowLeft"). Nil hides the slot.
    let leadingIcon: String?

    /// Action for the leading icon button.
    let leadingAction: (() -> Void)?

    /// Secondary trailing icon asset name (e.g. "IDS.Icon.Save"). Nil hides the slot.
    /// Positioned to the left of the primary trailing icon.
    let trailingSecondaryIcon: String?

    /// Action for the secondary trailing icon button.
    let trailingSecondaryAction: (() -> Void)?

    /// Primary trailing icon asset name (e.g. "IDS.Icon.ShareiOS"). Nil hides the slot.
    /// Positioned at the far right.
    let trailingPrimaryIcon: String?

    /// Action for the primary trailing icon button.
    let trailingPrimaryAction: (() -> Void)?

    // MARK: Constants

    private let navHeight: CGFloat = 48
    private let iconButtonSize: CGFloat = 40
    private let iconSize: CGFloat = 24

    // MARK: Init

    init(
        title: String? = nil,
        leadingIcon: String? = nil,
        leadingAction: (() -> Void)? = nil,
        trailingSecondaryIcon: String? = nil,
        trailingSecondaryAction: (() -> Void)? = nil,
        trailingPrimaryIcon: String? = nil,
        trailingPrimaryAction: (() -> Void)? = nil
    ) {
        self.title = title
        self.leadingIcon = leadingIcon
        self.leadingAction = leadingAction
        self.trailingSecondaryIcon = trailingSecondaryIcon
        self.trailingSecondaryAction = trailingSecondaryAction
        self.trailingPrimaryIcon = trailingPrimaryIcon
        self.trailingPrimaryAction = trailingPrimaryAction
    }

    // MARK: Body

    var body: some View {
        HStack(spacing: IDSSpacing.sm) {

            // Leading action slot
            if let leadingIcon {
                iconButton(named: leadingIcon, action: leadingAction)
            }

            // Title
            if let title {
                Text(title)
                    .font(IDSTypography.title)
                    .foregroundColor(IDSColors.grayscale80)
                    .lineLimit(1)
                    .truncationMode(.tail)
                    .frame(maxWidth: .infinity, alignment: .leading)
            } else {
                Spacer(minLength: IDSSpacing.none)
            }

            // Trailing action slot
            if trailingSecondaryIcon != nil || trailingPrimaryIcon != nil {
                trailingActions
            }
        }
        .frame(height: navHeight)
        .padding(.horizontal, IDSSpacing.sm)
        .background(IDSColors.grayscale00)
    }

    // MARK: - Subviews

    /// Trailing actions container with secondary and/or primary icon buttons.
    private var trailingActions: some View {
        HStack(spacing: IDSSpacing.sm) {
            if let trailingSecondaryIcon {
                iconButton(named: trailingSecondaryIcon, action: trailingSecondaryAction)
            }

            if let trailingPrimaryIcon {
                iconButton(named: trailingPrimaryIcon, action: trailingPrimaryAction)
            }
        }
    }

    /// A single icon button — 40×40 tap target with a 24×24 template icon.
    private func iconButton(named iconName: String, action: (() -> Void)?) -> some View {
        Button {
            action?()
        } label: {
            Image(iconName)
                .renderingMode(.template)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: iconSize, height: iconSize)
                .foregroundColor(IDSColors.grayscale80)
                .frame(width: iconButtonSize, height: iconButtonSize)
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Preview

#Preview("Full — Back + Title + Save + Share") {
    VStack(spacing: IDSSpacing.none) {
        IDSTopNav(
            title: "Surface title",
            leadingIcon: "IDS.Icon.ArrowLeft",
            leadingAction: {},
            trailingSecondaryIcon: "IDS.Icon.Save",
            trailingSecondaryAction: {},
            trailingPrimaryIcon: "IDS.Icon.ShareiOS",
            trailingPrimaryAction: {}
        )
        Spacer()
    }
}

#Preview("Back + Title Only") {
    VStack(spacing: IDSSpacing.none) {
        IDSTopNav(
            title: "Surface title",
            leadingIcon: "IDS.Icon.ArrowLeft",
            leadingAction: {}
        )
        Spacer()
    }
}

#Preview("Title Only") {
    VStack(spacing: IDSSpacing.none) {
        IDSTopNav(title: "Surface title")
        Spacer()
    }
}

#Preview("Title + Trailing Icons") {
    VStack(spacing: IDSSpacing.none) {
        IDSTopNav(
            title: "Surface title",
            trailingSecondaryIcon: "IDS.Icon.Save",
            trailingSecondaryAction: {},
            trailingPrimaryIcon: "IDS.Icon.ShareiOS",
            trailingPrimaryAction: {}
        )
        Spacer()
    }
}

#Preview("Back + Title + One Trailing") {
    VStack(spacing: IDSSpacing.none) {
        IDSTopNav(
            title: "Surface title",
            leadingIcon: "IDS.Icon.ArrowLeft",
            leadingAction: {},
            trailingPrimaryIcon: "IDS.Icon.ShareiOS",
            trailingPrimaryAction: {}
        )
        Spacer()
    }
}

#Preview("Long Title Truncation") {
    VStack(spacing: IDSSpacing.none) {
        IDSTopNav(
            title: "This is a very long surface title that should truncate",
            leadingIcon: "IDS.Icon.ArrowLeft",
            leadingAction: {},
            trailingSecondaryIcon: "IDS.Icon.Save",
            trailingSecondaryAction: {},
            trailingPrimaryIcon: "IDS.Icon.ShareiOS",
            trailingPrimaryAction: {}
        )
        Spacer()
    }
}

#Preview("Icons Only — No Title") {
    VStack(spacing: IDSSpacing.none) {
        IDSTopNav(
            leadingIcon: "IDS.Icon.ArrowLeft",
            leadingAction: {},
            trailingPrimaryIcon: "IDS.Icon.ShareiOS",
            trailingPrimaryAction: {}
        )
        Spacer()
    }
}
