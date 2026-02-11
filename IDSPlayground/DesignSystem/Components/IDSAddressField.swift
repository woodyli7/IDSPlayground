//
//  IDSAddressField.swift
//  IDSPlayground
//
//  IDS address input component — maps to Figma "IDS.Input/IDS.Address".
//  4 visual states: Default, Active, Filled, Invalid.
//
//  Behavior:
//  - Tapping the field activates the keyboard.
//  - Close icon clears all input.
//  - Submitting with empty text transitions to Invalid state.
//

import SwiftUI

// MARK: - Visual State

/// The derived visual state of an IDSAddressField.
/// Internal so previews and the component catalog can force a state.
enum IDSAddressFieldVisualState {
    case `default`
    case active
    case filled
    case invalid

    /// Human-readable name for previews and catalog.
    var displayName: String {
        switch self {
        case .default: return "Default"
        case .active: return "Active"
        case .filled: return "Filled"
        case .invalid: return "Invalid"
        }
    }
}

// MARK: - IDSAddressField

/// An address text field matching IDS.Input/IDS.Address.
///
/// Four states: Default (empty, unfocused), Active (focused),
/// Filled (has text, unfocused), Invalid (empty submit, unfocused).
///
/// Usage:
/// ```
/// IDSAddressField(
///     text: $address,
///     placeholder: "Add a new address",
///     label: "Street address",
///     hintText: "Optional description or clarification",
///     errorText: "Street address cannot be empty"
/// )
/// ```
struct IDSAddressField: View {

    @Binding var text: String
    var placeholder: String
    var label: String
    var hintText: String?
    var errorText: String
    var onSubmit: (() -> Void)?

    @FocusState private var isFocused: Bool
    @State private var isInvalid: Bool = false

    /// Preview-only override — forces a visual state without requiring actual
    /// focus or validation. `nil` at runtime; set via the `previewState` modifier.
    var _previewState: IDSAddressFieldVisualState? = nil

    init(
        text: Binding<String>,
        placeholder: String = "Add a new address",
        label: String = "Street address",
        hintText: String? = "Optional description or clarification",
        errorText: String = "Street address cannot be empty",
        onSubmit: (() -> Void)? = nil
    ) {
        self._text = text
        self.placeholder = placeholder
        self.label = label
        self.hintText = hintText
        self.errorText = errorText
        self.onSubmit = onSubmit
    }

    // MARK: Computed Visual State

    /// Derives the current visual state from focus, text, and validation.
    private var visualState: IDSAddressFieldVisualState {
        if let override = _previewState { return override }
        if isFocused { return .active }
        if isInvalid { return .invalid }
        if !text.isEmpty { return .filled }
        return .default
    }

    // MARK: Resolved Styling

    /// Border color for the current visual state.
    private var resolvedBorderColor: Color {
        switch visualState {
        case .default, .filled: return IDSColors.inputBorder
        case .active: return IDSColors.inputBorderActive
        case .invalid: return IDSColors.inputBorderInvalid
        }
    }

    /// Border width for the current visual state.
    private var resolvedBorderWidth: CGFloat {
        switch visualState {
        case .default, .filled: return 1
        case .active, .invalid: return 2
        }
    }

    /// Background color for the input box.
    private var resolvedBackground: Color {
        switch visualState {
        case .invalid: return IDSColors.inputBackgroundInvalid
        default: return IDSColors.inputBackground
        }
    }

    /// Whether the trailing icon should be visible.
    private var showTrailingIcon: Bool {
        switch visualState {
        case .default, .invalid: return true
        case .filled: return true
        case .active: return !text.isEmpty
        }
    }

    /// Whether the trailing icon is the close (clear) button.
    private var isTrailingClose: Bool {
        switch visualState {
        case .active, .filled: return true
        case .default, .invalid: return false
        }
    }

    // MARK: Body

    var body: some View {
        VStack(alignment: .leading, spacing: IDSSpacing.xs) {
            // Input box
            inputBox

            // Hint text
            if let hintText {
                Text(hintText)
                    .font(IDSTypography.accentRegular)
                    .foregroundColor(IDSColors.inputHintText)
                    .lineSpacing(IDSTypography.accentLineHeight - 10)
            }

            // Error row (Invalid only)
            if visualState == .invalid {
                errorRow
            }
        }
        .padding(.horizontal, IDSSpacing.md)
        .padding(.vertical, IDSSpacing.md)
        .onChange(of: isFocused) { _, newValue in
            if newValue {
                isInvalid = false
            }
        }
        .onChange(of: text) {
            if isInvalid {
                isInvalid = false
            }
        }
    }
}

// MARK: - Subviews

private extension IDSAddressField {

    /// The bordered input box containing text content and trailing icon.
    var inputBox: some View {
        HStack(spacing: IDSSpacing.sm) {
            // Text content area
            textContentArea
                .frame(maxWidth: .infinity, alignment: .leading)

            // Trailing icon
            if showTrailingIcon {
                trailingIcon
            }
        }
        .padding(.horizontal, IDSSpacing.md)
        .frame(height: IDSSpacing.xxxl)
        .background(resolvedBackground)
        .clipShape(RoundedRectangle(cornerRadius: IDSSpacing.sm))
        .overlay(
            RoundedRectangle(cornerRadius: IDSSpacing.sm)
                .stroke(resolvedBorderColor, lineWidth: resolvedBorderWidth)
        )
    }

    /// Text content: floating label (Invalid) + TextField.
    @ViewBuilder
    var textContentArea: some View {
        VStack(alignment: .leading, spacing: IDSSpacing.none) {
            // Floating label — only shown in Invalid state
            if visualState == .invalid {
                Text(label)
                    .font(IDSTypography.accentRegular)
                    .foregroundColor(IDSColors.inputTextLabel)
                    .lineLimit(1)
                    .truncationMode(.tail)
            }

            // TextField
            TextField(
                "",
                text: $text,
                prompt: visualState == .invalid
                    ? nil
                    : Text(placeholder)
                        .font(IDSTypography.bodyRegular)
                        .foregroundColor(IDSColors.inputTextLabel)
            )
            .font(IDSTypography.bodyRegular)
            .foregroundColor(IDSColors.inputTextInput)
            .focused($isFocused)
            .onSubmit {
                if text.isEmpty {
                    isInvalid = true
                }
                onSubmit?()
            }
        }
    }

    /// Trailing icon: Search (Default/Invalid) or Close (Active/Filled).
    @ViewBuilder
    var trailingIcon: some View {
        if isTrailingClose {
            Button {
                text = ""
                isInvalid = false
            } label: {
                Image("IDS.Icon.Close")
                    .renderingMode(.template)
                    .foregroundColor(IDSColors.inputTextLabel)
                    .frame(
                        width: IDSSpacing.xl,
                        height: IDSSpacing.xl
                    )
            }
            .buttonStyle(.plain)
        } else {
            Image("IDS.Icon.Search")
                .renderingMode(.template)
                .foregroundColor(IDSColors.inputTextLabel)
                .frame(
                    width: IDSSpacing.xl,
                    height: IDSSpacing.xl
                )
        }
    }

    /// Error row with issue icon and error message.
    var errorRow: some View {
        HStack(alignment: .center, spacing: IDSSpacing.xs) {
            Image("IDS.Icon.Issue")
                .renderingMode(.template)
                .foregroundColor(IDSColors.inputErrorContent)
                .frame(
                    width: IDSSpacing.lg,
                    height: IDSSpacing.lg
                )

            Text(errorText)
                .font(IDSTypography.accentRegular)
                .foregroundColor(IDSColors.inputErrorContent)
                .lineSpacing(IDSTypography.accentLineHeight - 10)
        }
    }
}

// MARK: - Preview State Modifier

extension IDSAddressField {

    /// Forces a visual state for previews and catalog (bypasses @FocusState).
    /// Do not use in production code — intended for static preview only.
    func previewState(_ state: IDSAddressFieldVisualState) -> IDSAddressField {
        var copy = self
        copy._previewState = state
        return copy
    }
}

// MARK: - Previews

#Preview("Default") {
    VStack {
        IDSAddressField(
            text: .constant("")
        )
    }
    .background(IDSColors.brandTertiaryLight)
}

#Preview("Active") {
    VStack {
        IDSAddressField(
            text: .constant("14 North Moore Street")
        )
        .previewState(.active)
    }
    .background(IDSColors.brandTertiaryLight)
}

#Preview("Filled") {
    VStack {
        IDSAddressField(
            text: .constant("14 North Moore Street")
        )
    }
    .background(IDSColors.brandTertiaryLight)
}

#Preview("Invalid") {
    VStack {
        IDSAddressField(
            text: .constant("")
        )
        .previewState(.invalid)
    }
    .background(IDSColors.brandTertiaryLight)
}
