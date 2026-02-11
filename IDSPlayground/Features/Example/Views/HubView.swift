//
//  HubView.swift
//  IDSPlayground
//
//  Second screen of the Example flow — tabbed hub.
//  Displays user address from FirstScreenView in Tab.FirstTab,
//  and a placeholder image in Tab.SecondTab.
//

import SwiftUI

// MARK: - Hub View

struct HubView: View {
    @Environment(ExampleViewModel.self) private var viewModel

    var body: some View {
        @Bindable var viewModel = viewModel

        VStack(spacing: IDSSpacing.none) {

            // -- Sticky Header --
            IDSTopNav(
                title: "Shopper",
                leadingIcon: "IDS.Icon.ArrowLeft",
                leadingAction: { viewModel.navigateBack() },
                trailingPrimaryIcon: "IDS.Icon.ShareiOS"
            )

            IDSTabs(
                tabs: [
                    IDSTabItem(title: "First tab"),
                    IDSTabItem(title: "Second tab", badgeCount: 77)
                ],
                selectedIndex: $viewModel.selectedTabIndex
            )

            // -- Scrollable Content --
            ScrollView {
                VStack(spacing: IDSSpacing.none) {

                    // 24px top spacer
                    Spacer()
                        .frame(height: IDSSpacing.xl)

                    if viewModel.selectedTabIndex == 0 {
                        firstTabContent
                    } else {
                        secondTabContent
                    }
                }
            }
        }
        .background(IDSColors.grayscale00)
        .navigationBarHidden(true)
    }
}

// MARK: - Tab Content

private extension HubView {

    /// First tab: user address display with "Go back" button.
    var firstTabContent: some View {
        VStack(spacing: IDSSpacing.none) {
            IDSSectionTitle(
                "Nice, you just typed:",
                hierarchy: .subtitle,
                titleColor: IDSColors.contentSecondary
            )

            IDSSectionTitle(viewModel.addressText, hierarchy: .headline) {
                IDSButton("Go back", type: .tertiary, size: .compact) {
                    viewModel.navigateBack()
                }
            }
        }
    }

    /// Second tab: placeholder image.
    var secondTabContent: some View {
        IDSImage("ImagePlaceholder")
    }
}

// MARK: - Preview

#Preview {
    NavigationStack {
        HubView()
            .environment(ExampleViewModel())
    }
}
