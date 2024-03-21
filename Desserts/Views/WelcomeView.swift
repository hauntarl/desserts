//
//  WelcomeView.swift
//  Desserts
//
//  Created by Sameer Mungole on 3/20/24.
//

import SwiftUI

/**
 The first view of this application, it displays a background image with a message.
 */
struct WelcomeView: View {
    let layouts = [AnyLayout(ZStackLayout()), AnyLayout(GridLayout())]
    let letters = "Making Fetch Happen...".split(separator: " ").map { word in
        word.split(separator: "").map { String($0) }
    }
    
    @State private var showingWelcomeView = true
    @State private var currentLayout = 0

    private var layout: AnyLayout {
        layouts[currentLayout]
    }
    
    var body: some View {
        if showingWelcomeView {
            BackgroundView(image: "DessertsWelcomeBackground") {
                layout {
                    ForEach(0..<letters.count, id: \.self) { i in
                        GridRow {
                            ForEach(0..<letters[i].count, id: \.self) { j in
                                Text(letters[i][j])
                            }
                        }
                    }
                }
                .font(.custom("Copperplate", size: 50))
                .bold()
                .shadow(radius: 5)
                .onAppear(perform: transition)
            }
            .transition(.asymmetric(insertion: .identity, removal: .move(edge: .leading)))
        } else {
            DessertsView()
                .transition(.move(edge: .trailing))
        }
    }
    
    private func transition() {
        withAnimation(
            .bouncy(duration: 0.75)
            .repeatForever(autoreverses: true)
            .delay(1)
        ) {
            currentLayout = 1
        }
        
        withAnimation(
            .easeOut(duration: 0.5)
            .delay(5)
        ) {
            showingWelcomeView = false
        }
    }
}

#Preview {
    WelcomeView()
        .preferredColorScheme(.dark)
}
