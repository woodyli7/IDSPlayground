//
//  IDSBadge.swift
//  IDSPlayground
//
//  IDS reusable badge component — maps to Figma "IDS.Badge".
//  3 types (Counter, Dot, New) × 2 appearances (Standard, Critical)
//  × 2 outline states (Outlined, Not Outlined) = 12 variants.
//

import SwiftUI

// MARK: - Badge Appearance

/// The color appearance of an IDSBadge.
enum IDSBadgeAppearance: String, CaseIterable {
    case standard
    case critical

    /// Human-readable name for previews and catalog.
    var displayName: String {
        switch self {
        case .standard: return "Standard"
        case .critical: return "Critical"
        }
    }

    /// Background color for this appearance.
    var backgroundColor: Color {
        switch self {
        case .standard: return IDSColors.badgeBackground
        case .critical: return IDSColors.badgeBackgroundCritical
        }
    }
}

// MARK: - Badge Type

/// The content type of an IDSBadge.
enum IDSBadgeType {
    /// Displays a numeric count (e.g., 3, 99).
    case counter(Int)
    /// Displays a small dot indicator.
    case dot
    /// Displays the text "New".
    case new
}

// MARK: - IDSBadge

/// A small pill-shaped indicator matching IDS.Badge.
///
/// Three types: `.counter(Int)` (shows a number), `.dot` (small circle),
/// `.new` (shows "New" text). Two appearances × two outline states.
///
/// Usage:
/// ```
/// IDSBadge(type: .counter(3))
/// IDSBadge(type: .dot, appearance: .critical)
/// IDSBadge(type: .new, appearance: .critical, isOutlined: false)
/// ```
struct IDSBadge: View {

    let type: IDSBadgeType
    var appearance: IDSBadgeAppearance = .standard
    var isOutlined: Bool = true

    init(
        type: IDSBadgeType,
        appearance: IDSBadgeAppearance = .standard,
        isOutlined: Bool = true
    ) {
        self.type = type
        self.appearance = appearance
        self.isOutlined = isOutlined
    }

    // MARK: Constants

    /// Badge height for all types.
    private let badgeHeight: CGFloat = 16

    /// Dot indicator size (width and height of inner circle).
    private let dotSize: CGFloat = 4

    /// Corner radius (pill shape).
    private let cornerRadius: CGFloat = 999

    /// Border width when outlined.
    private let borderWidth: CGFloat = 2

    // MARK: Body

    var body: some View {
        badgeContent
            .background(appearance.backgroundColor)
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .stroke(
                        IDSColors.badgeBorder,
                        lineWidth: isOutlined ? borderWidth : 0
                    )
            )
            .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
    }

    // MARK: Content

    @ViewBuilder
    private var badgeContent: some View {
        switch type {
        case .counter(let count):
            counterContent(count)
        case .dot:
            dotContent
        case .new:
            newContent
        }
    }

    /// Counter badge: number text with min-width, horizontal padding 2px.
    private func counterContent(_ count: Int) -> some View {
        Text("\(count)")
            .font(IDSTypography.accentEmphasized)
            .lineSpacing(IDSTypography.accentEmphasizedLineHeight - 10)
            .foregroundColor(IDSColors.badgeContent)
            .lineLimit(1)
            .truncationMode(.tail)
            .frame(minWidth: 12)
            .padding(.horizontal, IDSSpacing.xxs)
            .frame(height: badgeHeight)
    }

    /// Dot badge: 4×4 circle centered in a 16×16 container.
    private var dotContent: some View {
        Circle()
            .fill(IDSColors.badgeContent)
            .frame(width: dotSize, height: dotSize)
            .frame(width: badgeHeight, height: badgeHeight)
    }

    /// New badge: "New" text with horizontal padding 4px.
    private var newContent: some View {
        Text("New")
            .font(IDSTypography.accentEmphasized)
            .lineSpacing(IDSTypography.accentEmphasizedLineHeight - 10)
            .foregroundColor(IDSColors.badgeContent)
            .lineLimit(1)
            .padding(.horizontal, IDSSpacing.xs)
            .frame(height: badgeHeight)
    }
}

// MARK: - Preview (All Variants)

#Preview("Standard — Outlined") {
    HStack(spacing: IDSSpacing.lg) {
        IDSBadge(type: .counter(99), appearance: .standard, isOutlined: true)
        IDSBadge(type: .dot, appearance: .standard, isOutlined: true)
        IDSBadge(type: .new, appearance: .standard, isOutlined: true)
    }
    .padding(IDSSpacing.xl)
    .background(IDSColors.brandTertiaryLight)
}

#Preview("Standard — Not Outlined") {
    HStack(spacing: IDSSpacing.lg) {
        IDSBadge(type: .counter(99), appearance: .standard, isOutlined: false)
        IDSBadge(type: .dot, appearance: .standard, isOutlined: false)
        IDSBadge(type: .new, appearance: .standard, isOutlined: false)
    }
    .padding(IDSSpacing.xl)
    .background(IDSColors.brandTertiaryLight)
}

#Preview("Critical — Outlined") {
    HStack(spacing: IDSSpacing.lg) {
        IDSBadge(type: .counter(99), appearance: .critical, isOutlined: true)
        IDSBadge(type: .dot, appearance: .critical, isOutlined: true)
        IDSBadge(type: .new, appearance: .critical, isOutlined: true)
    }
    .padding(IDSSpacing.xl)
    .background(IDSColors.brandTertiaryLight)
}

#Preview("Critical — Not Outlined") {
    HStack(spacing: IDSSpacing.lg) {
        IDSBadge(type: .counter(99), appearance: .critical, isOutlined: false)
        IDSBadge(type: .dot, appearance: .critical, isOutlined: false)
        IDSBadge(type: .new, appearance: .critical, isOutlined: false)
    }
    .padding(IDSSpacing.xl)
    .background(IDSColors.brandTertiaryLight)
}
