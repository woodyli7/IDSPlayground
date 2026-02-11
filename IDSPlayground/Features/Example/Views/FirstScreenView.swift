//
//  FirstScreenView.swift
//  IDSPlayground
//
//  First (and only) screen of the Example flow.
//  Demonstrates IDSTopNav, IDSSectionTitle, IDSContentRow,
//  IDSAddress, and IDSButton in a sticky header/footer layout.
//

import SwiftUI

// MARK: - First Screen View

struct FirstScreenView: View {
    @Environment(ExampleViewModel.self) private var viewModel
    var onDismiss: () -> Void

    var body: some View {
        @Bindable var viewModel = viewModel

        VStack(spacing: IDSSpacing.none) {

            // -- Sticky Header --
            IDSTopNav(
                leadingIcon: "IDS.Icon.ArrowLeft",
                leadingAction: { onDismiss() }
            )

            // -- Scrollable Content --
            ScrollView {
                VStack(spacing: IDSSpacing.none) {
                    IDSSectionTitle("Input something please")
                        .opacity(viewModel.isAddressActive ? 0 : 1)
                        .frame(maxHeight: viewModel.isAddressActive ? 0 : nil)
                        .clipped()
                        .allowsHitTesting(!viewModel.isAddressActive)

                    IDSAddress(
                        text: $viewModel.addressText,
                        placeholder: "Add some text",
                        isInvalid: viewModel.addressIsInvalid,
                        errorText: "Street address cannot be empty",
                        onSubmit: { viewModel.submitAddress() },
                        onFocusChange: { focused in
                            withAnimation(.easeInOut(duration: 0.25)) {
                                viewModel.isAddressActive = focused
                            }
                        }
                    )

                    IDSContentRow(
                        title: "If iPhone keyboard doesn't pop up when you input",
                        subtitle: "In the Simulator menu, navigate to I/O > Keyboard and uncheck Connect Hardware Keyboard"
                    ) {
                        Image("IDS-icon-marker")
                            .renderingMode(.template)
                            .frame(width: 24, height: 24)
                    }
                    .opacity(viewModel.isAddressActive ? 0 : 1)
                    .frame(maxHeight: viewModel.isAddressActive ? 0 : nil)
                    .clipped()
                    .allowsHitTesting(!viewModel.isAddressActive)
                }
            }

            // -- Sticky Footer --
            IDSButton("CTA", type: .primary, isEnabled: viewModel.isCTAEnabled) {
                viewModel.navigateToStep(.hub)
            }
                .padding(.horizontal, IDSSpacing.lg)
                .padding(.bottom, IDSSpacing.sm)
        }
        .background(IDSColors.grayscale00)
        .navigationBarHidden(true)
    }
}

// MARK: - Preview

#Preview {
    NavigationStack {
        FirstScreenView(onDismiss: {})
            .environment(ExampleViewModel())
    }
}
