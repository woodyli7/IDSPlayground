//
//  IDSSpacing.swift
//  IDSPlayground
//
//  Design tokens: Spacing scale from the Instacart Design System (IDS).
//  Source: Figma "Pantry Space and Scale".
//

import SwiftUI

enum IDSSpacing {

    /// 0px - semantic/space/0
    static let none: CGFloat = 0

    /// 2px
    static let xxs: CGFloat = 2

    /// 4px - pantry/component/input/space/vertical-gap, semantic/space/4
    static let xs: CGFloat = 4

    /// 8px - semantic/space/8, TopNav horizontal padding
    static let sm: CGFloat = 8

    /// 12px - semantic/space/12, row vertical padding, input outer padding
    static let md: CGFloat = 12

    /// 16px - semantic/space/16, row horizontal padding, title padding
    static let lg: CGFloat = 16

    /// 24px
    static let xl: CGFloat = 24

    /// 32px
    static let xxl: CGFloat = 32

    /// 40px - s40
    static let xxxxl: CGFloat = 40

    /// 48px
    static let xxxl: CGFloat = 48
}
