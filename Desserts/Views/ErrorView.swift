//
//  ErrorView.swift
//  Desserts
//
//  Created by Sameer Mungole on 3/20/24.
//

import SwiftUI

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
                
                (Text(message) + Text("**Tap to retry!**"))
                    .font(.callout)
            }
            .padding()
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
            message: "**[themealdb](https://themealdb.com/api/json/v1/1/filter.php?c=Dessert)** returned either empty or invalid data."
        ) {
            // Do nothing
        }
    }
    .preferredColorScheme(.dark)
}
