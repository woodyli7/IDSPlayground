//
//  IDSImage.swift
//  IDSPlayground
//
//  IDS reusable image component — maps to Figma "IDS.Image / Standard".
//  Full-width container with horizontal/vertical padding and rounded corners.
//  Container height is responsive to the image's intrinsic aspect ratio.
//

import SwiftUI

// MARK: - IDSImage

/// A full-width image container with consistent padding and rounded corners.
///
/// The image fills the available width; height scales proportionally based
/// on the image's intrinsic aspect ratio.
///
/// Usage:
/// ```
/// IDSImage("ImagePlaceholder")
/// ```
struct IDSImage: View {

    let imageName: String

    // MARK: Init

    init(_ imageName: String) {
        self.imageName = imageName
    }

    // MARK: Body

    var body: some View {
        Image(imageName)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .padding(.horizontal, IDSSpacing.lg)
            .padding(.vertical, IDSSpacing.md)
            .frame(maxWidth: .infinity)
    }
}

// MARK: - Preview

#Preview("IDSImage — Standard") {
    IDSImage("ImagePlaceholder")
        .background(IDSColors.grayscale00)
}
