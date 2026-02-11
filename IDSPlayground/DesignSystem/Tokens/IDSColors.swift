//
//  IDSColors.swift
//  IDSPlayground
//
//  Design tokens: Colors from the Instacart Design System (IDS).
//  Source: Figma IDS color tokens.
//

import SwiftUI

// MARK: - Color Hex Extension

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 6: // RGB
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

// MARK: - Design System Colors

enum IDSColors {

    // MARK: Brand

    /// BrandTertiaryLight - warm off-white background
    static let brandTertiaryLight = Color(hex: "#f7f5f0")

    // MARK: Grayscale

    /// SystemGrayscale00 - white background
    static let grayscale00 = Color.white

    /// SystemGrayscale80 - title text, primary content
    static let grayscale80 = Color(hex: "#242529")

    /// tkn/row/color/content/secondary - body text, descriptions
    static let contentSecondary = Color(hex: "#56595e")

    // MARK: Button - Enabled

    /// pantry/component/button/primary/color/background
    static let buttonPrimaryBg = Color(hex: "#108910")

    /// pantry/component/button/primary/color/content
    static let buttonPrimaryContent = Color.white

    // MARK: Button - Primary (Loading)

    /// pantry/component/button/primary/color/background-hover (loading state)
    static let buttonPrimaryBgLoading = Color(hex: "#0d720d")

    // MARK: Button - Secondary

    /// pantry/component/button/secondary/color/background
    static let buttonSecondaryBg = Color(hex: "#e8e9eb")

    /// pantry/component/button/secondary/color/content
    static let buttonSecondaryContent = Color(hex: "#242529")

    /// pantry/component/button/secondary/color/background-hover (loading state)
    static let buttonSecondaryBgLoading = Color(hex: "#c7c8cd")

    // MARK: Button - Tertiary

    /// pantry/component/button/tertiary/color/background
    static let buttonTertiaryBg = Color(hex: "#f6f7f8")

    /// pantry/component/button/tertiary/color/border (1px)
    static let buttonTertiaryBorder = Color(hex: "#e8e9eb")

    /// pantry/component/button/tertiary/color/content
    static let buttonTertiaryContent = Color(hex: "#242529")

    // MARK: Button - Detrimental

    /// pantry/component/button/detrimental/color/background
    static let buttonDetrimentalBg = Color(hex: "#de3534")

    /// pantry/component/button/detrimental/color/content
    static let buttonDetrimentalContent = Color.white

    /// pantry/component/button/detrimental/color/background-hover (loading state)
    static let buttonDetrimentalBgLoading = Color(hex: "#bb1c1b")

    // MARK: Button - Instacart+

    /// BrandPlusDark - Instacart+ button background
    static let buttonInstacartPlusBg = Color(hex: "#530038")

    /// Instacart+ button content
    static let buttonInstacartPlusContent = Color.white

    /// BrandPlusRegular - Instacart+ button background (loading state)
    static let buttonInstacartPlusBgLoading = Color(hex: "#750046")

    // MARK: Button - Disabled

    /// pantry/component/button/disabled/color/background
    static let buttonDisabledBg = Color(hex: "#f6f7f8")

    /// pantry/component/button/disabled/color/content
    static let buttonDisabledContent = Color(hex: "#c7c8cd")

    // MARK: Input - Default

    /// pantry/component/input/color/border (1px)
    static let inputBorder = Color(hex: "#8f939b")

    /// pantry/component/input/color/background
    static let inputBackground = Color.white

    /// pantry/component/input/color/text-label
    static let inputTextLabel = Color(hex: "#242529")

    /// pantry/component/input/color/text-input
    static let inputTextInput = Color(hex: "#242529")

    /// pantry/component/input/color/text-hint
    static let inputHintText = Color(hex: "#56595e")

    // MARK: Input - Active

    /// pantry/component/input/color/border-active (2px)
    static let inputBorderActive = Color(hex: "#242529")

    // MARK: Input - Invalid

    /// pantry/component/input/invalid/color/border (2px)
    static let inputBorderInvalid = Color(hex: "#de3534")

    /// pantry/component/input/invalid/color/background
    static let inputBackgroundInvalid = Color(hex: "#fef0f0")

    /// pantry/component/input/invalid/color/content - error text
    static let inputErrorContent = Color(hex: "#de3534")

    // MARK: Badge

    /// pantry/component/badge/color/background - standard badge background
    static let badgeBackground = Color(hex: "#242529")

    /// pantry/component/badge/color/background-critical - critical badge background
    static let badgeBackgroundCritical = Color(hex: "#de3534")

    /// pantry/component/badge/color/content - badge text and dot color
    static let badgeContent = Color.white

    /// pantry/component/badge/color/border - outlined badge border
    static let badgeBorder = Color.white

    // MARK: Grayscale - Extended

    /// SystemGrayscale20 - selector borders, subtle dividers
    static let grayscale20 = Color(hex: "#e8e9eb")

    /// SystemGrayscale70 - ModalHeader title text, ColorSelector selected ring
    static let grayscale70 = Color(hex: "#343538")

    // MARK: Vehicle Colors

    /// Vehicle color: Black
    static let vehicleBlack = Color(hex: "#343538")

    /// Vehicle color: Cashew (light beige)
    static let vehicleCashew = Color(hex: "#e8dcc8")

    /// Vehicle color: Lemon (bright yellow)
    static let vehicleLemon = Color(hex: "#f5d547")

    /// Vehicle color: Kale (dark green)
    static let vehicleKale = Color(hex: "#1b6631")

    /// Vehicle color: Plum (deep purple)
    static let vehiclePlum = Color(hex: "#6b1d5e")

    /// Vehicle color: Blue (periwinkle)
    static let vehicleBlue = Color(hex: "#7b8dc8")

    /// Vehicle color: Red (dark red)
    static let vehicleRed = Color(hex: "#8b1a1a")
}
