//
//  BackgroundView.swift
//  Desserts
//
//  Created by Sameer Mungole on 3/20/24.
//

import SwiftUI

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
                    .ignoresSafeArea()
            }
            
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
