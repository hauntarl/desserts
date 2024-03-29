//
//  NetworkImage.swift
//  Desserts
//
//  Created by Sameer Mungole on 3/19/24.
//

import SwiftUI

/**
 An alternative to `AsyncImage` view. This view utilizes a custom `ImageCache` object to cache
 network images for fast retrieval of images through app.
 */
struct NetworkImage<I: View, P: View>: View {
    private let imageCache = ImageCache.shared
    
    let url: URL?
    @ViewBuilder let content: (Image) -> I
    @ViewBuilder let placeholder: () -> P
    
    @State private var image: Image?
    
    var body: some View {
        if let url, let uiImage = imageCache.image(for: url.absoluteString) {
            // Directly display the image from cache
            content(Image(uiImage: uiImage))
                .transition(.opacity)
        } else if let image {
            // Display image once it's available
            content(image)
                .transition(.opacity)
        } else {
            // Display placeholder and fetch image from the network
            placeholder()
                .transition(.opacity)
                .task { await fetchImage() }
        }
    }
    
    private func fetchImage() async {
        guard let url,
              let (data, _) = try? await URLSession.shared.data(from: url),
              let uiImage = UIImage(data: data)
        else {
            return
        }
        
        imageCache.setImage(uiImage, for: url.absoluteString)
        withAnimation(.easeOut) {
            image = Image(uiImage: uiImage)
        }
    }
}

#Preview {
    NetworkImage(
        url: URL(string: "https://www.themealdb.com/images/media/meals/adxcbq1619787919.jpg")
    ) { image in
        image
            .resizable()
            .scaledToFit()
    } placeholder: {
        ProgressView()
    }
}
