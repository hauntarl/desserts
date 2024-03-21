//
//  BackgroundView.swift
//  Desserts
//
//  Created by Sameer Mungole on 3/20/24.
//

import SwiftUI

/**
 A view that wraps the content around a `ZStack` and puts a background image underneath.
 
 - Parameters:
    - image: Loads an image from the assets folder by the `image` value
    - content: The content that needs to be wrapped by this `BackgroundView`
 */
struct BackgroundView<Content: View>: View {
    let image: String
    @ViewBuilder let content: () -> Content
    
    var body: some View {
        ZStack {
            GeometryReader { _ in
                Image(image)
                    .resizable()
                    .scaledToFill()
                    .scaleEffect(1.1)
                    .overlay {
                        Rectangle()
                            .foregroundStyle(.ultraThinMaterial)
                    }
            }
            .clipped()
            .ignoresSafeArea()
            
            content()
        }
    }
}

#Preview {
    BackgroundView(image: "DessertsBackground") {
        Text("Content")
    }
    .preferredColorScheme(.dark)
}
