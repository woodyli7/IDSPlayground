//
//  ExampleFlow.swift
//  IDSPlayground
//
//  Flow coordinator for the Example flow.
//  Multi-screen flow: FirstScreenView → HubView (tabbed).
//

import SwiftUI

// MARK: - Example Flow

struct ExampleFlow: View {
    @State private var viewModel = ExampleViewModel()
    var onDismiss: () -> Void

    var body: some View {
        NavigationStack(path: $viewModel.path) {
            FirstScreenView(onDismiss: onDismiss)
                .navigationDestination(for: ExampleStep.self) { step in
                    switch step {
                    case .hub:
                        HubView()
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
