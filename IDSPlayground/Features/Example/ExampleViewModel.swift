//
//  ExampleViewModel.swift
//  IDSPlayground
//
//  ViewModel and step enum for the Example flow.
//  Multi-screen flow: FirstScreenView → HubView (tabbed).
//

import SwiftUI

// MARK: - Flow Steps

/// Navigation steps for the Example flow.
/// The first screen is the root of NavigationStack (not in this enum).
enum ExampleStep: Hashable {
    case hub
}

// MARK: - View Model

@Observable
class ExampleViewModel {

    /// Navigation path for the flow
    var path: [ExampleStep] = []

    // MARK: State Properties

    /// Text entered in the address input field.
    var addressText: String = "" {
        didSet {
            // Clear invalid state when the user starts typing
            if !addressText.isEmpty {
                addressIsInvalid = false
            }
        }
    }

    /// Whether the address field is in an invalid state.
    var addressIsInvalid: Bool = false

    /// Whether the address field is currently focused (active editing mode).
    var isAddressActive: Bool = false

    /// Selected tab index on HubView (0 = First tab, 1 = Second tab).
    var selectedTabIndex: Int = 0

    // MARK: Computed Properties

    /// Whether the CTA button should be enabled (address field has text).
    var isCTAEnabled: Bool {
        !addressText.isEmpty
    }

    // MARK: Actions

    /// Validates and submits the address. Sets invalid if empty.
    func submitAddress() {
        if addressText.isEmpty {
            addressIsInvalid = true
        }
    }

    func navigateToStep(_ step: ExampleStep) {
        if step == .hub {
            selectedTabIndex = 0
        }
        path.append(step)
    }

    func navigateBack() {
        if !path.isEmpty {
            path.removeLast()
        }
    }

    func resetFlow() {
        path = []
    }
}
