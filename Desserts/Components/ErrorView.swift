//
//  ErrorView.swift
//  Desserts
//
//  Created by Sameer Mungole on 3/20/24.
//

import SwiftUI

/**
 This view is used when the [themealdb.com](https://themealdb.com/api.php) api responds with
 an error message.
 
 - Parameters:
    - image: Loads an image from the assets folder by the `image` value
    - title: The title text for this view
    - message: A message that supports markdown syntax
    - retryAction: An action to perform when user taps to retry
 */
struct ErrorView: View {
    let image: String
    let title: String
    let message: LocalizedStringKey
    let retryAction: () async -> Void
    
    var body: some View {
        ContentUnavailableView {
            VStack(spacing: 20) {
                Image(image)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 150, height: 150)
                
                Text(title)
                    .font(.title)
                
                (Text(message) + Text("\n**Tap to retry!**"))
                    .font(.callout)
            }
            .padding(40)
            .background {
                RoundedRectangle(cornerRadius: 25)
                    .foregroundStyle(.regularMaterial)
            }
            .shadow(radius: 5)
        }
        .onTapGesture {
            Task { await retryAction() }
        }
    }
}

#Preview {
    BackgroundView(image: "DessertsBackground") {
        ErrorView(
            image: "DessertsUnavailable",
            title: "Content Unavailable",
            message: "**[themealdb.com](https://themealdb.com/api/json/v1/1/filter.php?c=Dessert)** returned either empty or invalid data."
        ) {
            // Do nothing
        }
    }
    .preferredColorScheme(.dark)
}
