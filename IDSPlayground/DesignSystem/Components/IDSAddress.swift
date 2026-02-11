//
//  IDSAddress.swift
//  IDSPlayground
//
//  IDS reusable address input component — maps to Figma "IDS.Input/IDS.Address".
//  A text field with a state-dependent trailing icon. Supports Default, Active,
//  Filled, and Invalid states. Optional hint text and error text below the field.
//

import SwiftUI

// MARK: - IDSAddress

/// An address search input field with a trailing icon and optional hint/error text.
///
/// States are derived automatically from focus, text content, and `isInvalid`:
/// - **Default:** Empty, not focused — placeholder, search icon, 1px border
/// - **Active:** Focused — no trailing icon, 2px dark border
/// - **Filled:** Has text, not focused — close icon (clears text), 1px border
/// - **Invalid:** `isInvalid` is true — search icon, 2px red border, pink background, error row
///
/// Usage:
/// ```
/// IDSAddress(text: $address, placeholder: "Add a new address")
///
/// IDSAddress(
///     text: $address,
///     placeholder: "Add a new address",
///     isInvalid: viewModel.addressIsInvalid,
///     errorText: "Street address cannot be empty",
///     onSubmit: { viewModel.submitAddress() }
/// )
/// ```
struct IDSAddress: View {

    // MARK: Properties

    /// Binding to the text value entered in the field.
    @Binding var text: String

    /// Placeholder text shown when the field is empty.
    let placeholder: String

    /// Optional hint text displayed below the input field.
    var hintText: String?

    /// Whether the field is in an invalid state (red border, pink background).
    var isInvalid: Bool = false

    /// Error text shown below the field when invalid. Requires `isInvalid` to be true.
    var errorText: String?

    /// Called when the user presses Enter/Return on the keyboard.
    var onSubmit: (() -> Void)?

    /// Called when the field gains or loses focus.
    var onFocusChange: ((Bool) -> Void)?

    /// Focus state for tracking Active vs Default/Filled.
    @FocusState private var isFocused: Bool

    // MARK: Constants

    private let inputHeight: CGFloat = 48
    private let cornerRadius: CGFloat = 8
    private let iconSize: CGFloat = 24
    private let errorIconSize: CGFloat = 16

    // MARK: Body

    var body: some View {
        VStack(alignment: .leading, spacing: IDSSpacing.xs) {
            // Input field
            HStack(spacing: IDSSpacing.sm) {
                TextField("", text: $text, prompt: promptText)
                    .font(IDSTypography.bodyRegular)
                    .foregroundColor(IDSColors.inputTextInput)
                    .focused($isFocused)
                    .onSubmit { onSubmit?() }

                trailingIcon
            }
            .padding(.horizontal, IDSSpacing.md)
            .frame(height: inputHeight)
            .background(resolvedBackground)
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .stroke(resolvedBorderColor, lineWidth: resolvedBorderWidth)
            )
            .clipShape(RoundedRectangle(cornerRadius: cornerRadius))

            // Hint text (optional, shown in all non-error states)
            if let hintText, !isInvalid {
                Text(hintText)
                    .font(IDSTypography.accentRegular)
                    .foregroundColor(IDSColors.contentSecondary)
            }

            // Error row (invalid state only)
            if isInvalid, let errorText {
                HStack(spacing: IDSSpacing.xs) {
                    Image("IDS.Icon.Issue")
                        .renderingMode(.template)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: errorIconSize, height: errorIconSize)
                        .foregroundColor(IDSColors.inputErrorContent)

                    Text(errorText)
                        .font(IDSTypography.accentRegular)
                        .foregroundColor(IDSColors.inputErrorContent)
                }
            }
        }
        .padding(.horizontal, IDSSpacing.md)
        .padding(.vertical, IDSSpacing.md)
        .onChange(of: isFocused) { _, newValue in
            onFocusChange?(newValue)
        }
    }

    // MARK: - Subviews

    /// Trailing icon that changes based on component state.
    /// Invalid → search icon, has text → close icon, Active (empty) → none, Default → search icon.
    @ViewBuilder
    private var trailingIcon: some View {
        if isInvalid {
            // Invalid: search icon
            searchIcon
        } else if !text.isEmpty {
            // Has text (focused or not): close icon (tap to clear)
            Button {
                text = ""
            } label: {
                Image("IDS.Icon.Close")
                    .renderingMode(.template)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: iconSize, height: iconSize)
                    .foregroundColor(IDSColors.grayscale80)
            }
            .buttonStyle(.plain)
        } else if isFocused {
            // Active (empty): no trailing icon
            EmptyView()
        } else {
            // Default (empty, not focused): search icon
            searchIcon
        }
    }

    /// Reusable search icon view.
    private var searchIcon: some View {
        Image("IDS.Icon.Search")
            .renderingMode(.template)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: iconSize, height: iconSize)
            .foregroundColor(IDSColors.grayscale80)
    }

    // MARK: - Computed Properties

    /// Styled placeholder text matching the Figma design (dark label color).
    private var promptText: Text {
        Text(placeholder)
            .foregroundColor(IDSColors.inputTextLabel)
    }

    /// Background color: pink when invalid, white otherwise.
    private var resolvedBackground: Color {
        isInvalid ? IDSColors.inputBackgroundInvalid : IDSColors.inputBackground
    }

    /// Border color based on state priority: Invalid > Active > Default/Filled.
    private var resolvedBorderColor: Color {
        if isInvalid {
            return IDSColors.inputBorderInvalid
        }
        return isFocused ? IDSColors.inputBorderActive : IDSColors.inputBorder
    }

    /// Border width: 2px when invalid or active, 1px otherwise.
    private var resolvedBorderWidth: CGFloat {
        (isInvalid || isFocused) ? 2 : 1
    }
}

// MARK: - Previews

#Preview("IDSAddress — Default") {
    IDSAddress(text: .constant(""), placeholder: "Add a new address")
        .background(IDSColors.grayscale00)
}

#Preview("IDSAddress — Filled") {
    IDSAddress(text: .constant("14 North Moore Street"), placeholder: "Add a new address")
        .background(IDSColors.grayscale00)
}

#Preview("IDSAddress — Invalid") {
    IDSAddress(
        text: .constant(""),
        placeholder: "Add a new address",
        isInvalid: true,
        errorText: "Street address cannot be empty"
    )
    .background(IDSColors.grayscale00)
}

#Preview("IDSAddress — With Hint Text") {
    IDSAddress(
        text: .constant(""),
        placeholder: "Add a new address",
        hintText: "Optional description or clarification"
    )
    .background(IDSColors.grayscale00)
}
