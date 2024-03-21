//
//  WelcomeView.swift
//  Desserts
//
//  Created by Sameer Mungole on 3/20/24.
//

import SwiftUI

struct WelcomeView: View {
    struct TextWithID: Identifiable {
        let id = UUID()
        let text: String
    }
    
    let layouts = [AnyLayout(ZStackLayout()), AnyLayout(GridLayout())]
    let text1: [TextWithID] = "Making"
        .split(separator: "")
        .map { TextWithID(text: String($0)) }
    let text2: [TextWithID] = "Fetch"
        .split(separator: "")
        .map { TextWithID(text: String($0)) }
    let text3: [TextWithID] = "Happen"
        .split(separator: "")
        .map { TextWithID(text: String($0)) }
    
    @State private var showingWelcomeView = true
    @State private var currentLayout = 0

    private var layout: AnyLayout {
        layouts[currentLayout]
    }
    
    var body: some View {
        if showingWelcomeView {
            BackgroundView(image: "DessertsWelcomeBackground") {
                layout {
                    GridRow {
                        ForEach(text1) {
                            Text($0.text)
                        }
                    }
                    GridRow {
                        ForEach(text2) {
                            Text($0.text)
                        }
                    }
                    GridRow {
                        ForEach(text3) {
                            Text($0.text)
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
            .delay(4)
        ) {
            showingWelcomeView = false
        }
    }
}

#Preview {
    WelcomeView()
        .preferredColorScheme(.dark)
}
