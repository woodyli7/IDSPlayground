//
//  ExampleFlow.swift
//  IDSPlayground
//
//  Flow coordinator for the Example flow.
//  Multi-screen flow: HubView → FirstScreenView.
//

import SwiftUI

// MARK: - Example Flow

struct ExampleFlow: View {
    @State private var viewModel = ExampleViewModel()
    var onDismiss: () -> Void

    var body: some View {
        NavigationStack(path: $viewModel.path) {
            HubView(onDismiss: onDismiss)
                .navigationDestination(for: ExampleStep.self) { step in
                    switch step {
                    case .firstScreen:
                        FirstScreenView()
                    }
                }
        }
        .environment(viewModel)
    }
}

// MARK: - Preview

#Preview {
    ExampleFlow(onDismiss: {})
}
