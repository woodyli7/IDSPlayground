//
//  ContentView.swift
//  IDSPlayground
//
//  Root view for the app. Routes between the landing page
//  and active flows / screens.
//

import SwiftUI

// MARK: - App Flow

enum AppFlow {
    case example
    case componentCatalog
}

// MARK: - Content View

struct ContentView: View {
    @State private var activeFlow: AppFlow?

    var body: some View {
        if let flow = activeFlow {
            switch flow {
            case .example:
                ExampleFlow(onDismiss: { activeFlow = nil })
            case .componentCatalog:
                VStack(spacing: IDSSpacing.none) {
                    IDSTopNav(
                        title: "Component Catalog",
                        leadingIcon: "IDS.Icon.ArrowLeft",
                        leadingAction: { activeFlow = nil }
                    )
                    ComponentCatalogView(showHeader: false)
                }
            }
        } else {
            LandingView(
                onStartExampleFlow: { activeFlow = .example },
                onStartYourFlow: { /* leave for now */ },
                onComponentCatalog: { activeFlow = .componentCatalog }
            )
        }
    }
}

#Preview {
    ContentView()
}
