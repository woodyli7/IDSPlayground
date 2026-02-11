//
//  LandingView.swift
//  IDSPlayground
//
//  Landing page with navigation to example flow, user flow,
//  and component catalog.
//

import SwiftUI

// MARK: - Landing View

struct LandingView: View {
    var onStartExampleFlow: () -> Void
    var onStartYourFlow: () -> Void
    var onComponentCatalog: () -> Void

    var body: some View {
        ScrollView {
            VStack(spacing: IDSSpacing.none) {

                Spacer().frame(height: 96)

                IDSSectionTitle("👋 IDS Playground")

                IDSContentRow(
                    title: "Slack channel: #idsplayground",
                    subtitle: "@Woody for any questions, thoughts or feature request"
                )

                Spacer().frame(height: 96)

                // CTA buttons
                IDSButton("Start Example Flow", type: .primary) {
                    onStartExampleFlow()
                }
                .padding(.horizontal, IDSSpacing.lg)

                Spacer().frame(height: 24)

                IDSButton("Start Your Flow", type: .secondary) {
                    onStartYourFlow()
                }
                .padding(.horizontal, IDSSpacing.lg)

                Spacer().frame(height: 24)

                IDSButton("Components Catalog", type: .instacartPlus) {
                    onComponentCatalog()
                }
                .padding(.horizontal, IDSSpacing.lg)
            }
        }
        .background(Color.white)
    }
}

// MARK: - Preview

#Preview {
    LandingView(
        onStartExampleFlow: {},
        onStartYourFlow: {},
        onComponentCatalog: {}
    )
}
