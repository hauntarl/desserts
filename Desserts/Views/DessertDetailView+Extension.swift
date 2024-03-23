//
//  DessertDetailView+Extension.swift
//  Desserts
//
//  Created by Sameer Mungole on 3/19/24.
//

import SwiftUI

extension DessertDetailView {
    func header(for title: String) -> some View {
        Text(title)
            .font(.caption)
            .foregroundStyle(.background)
            .padding(6)
            .background {
                RoundedRectangle(cornerRadius: 10)
                    .foregroundStyle(.primary)
            }
    }
    
    func image(from url: URL?) -> some View {
        NetworkImage(url: url) { image in
            image
                .resizable()
                .scaledToFit()
        } placeholder: {
            // When the container don't explicitly suggest a size for the images, the images size themselves based on
            // their intrinsic dimensions. If the placeholder image has different dimensions, the transition will
            // cause a jump in the container dimensions.
            //
            // In order to get rid of this unintended stutter, I've added a `Placeholder` image in the project's
            // asset. When you apply a .hidden() modifier on a view, and overlay the hidden view with some other
            // view, this overlay can take up to the dimensions of the hidden view.
            //
            // The above process makes sure that the placeholder view will result in same size as the actual image
            // and this helps avoid any stutter or jump while transitioning from placeholder to content.
            Image("Placeholder")
                .resizable()
                .scaledToFit()
                .hidden()
                .overlay {
                    Rectangle().foregroundStyle(.thinMaterial)
                }
        }
        .clipShape(.rect(cornerRadius: 10))
    }
    
    @ViewBuilder
    func tags(from formattedTags: String) -> some View {
        if !formattedTags.isEmpty {
            Text(formattedTags)
                .font(.subheadline)
        }
    }
    
    func loadRecipeItems(from ingredients: [Ingredient]) -> some View {
        ForEach(ingredients, id: \.self) { ingredient in
            HStack {
                Text(ingredient.name)
                    .bold()
                
                Spacer()
                
                Text(ingredient.quantity)
            }
        }
        .font(.subheadline)
    }
    
    @ViewBuilder
    func loadRecipe(from instructions: [String], proxy: ScrollViewProxy) -> some View {
        let steps = isRecipeExpanded ? instructions[...] : instructions[0..<1]
        ForEach(steps, id: \.self) { step in
            Text(step)
        }
        
        // If there's only one step in the instructions then skip this button
        if instructions.count > 1 {
            Button(isRecipeExpanded ? "Close" : "Read more") {
                withAnimation(animationCurve) {
                    isRecipeExpanded.toggle()
                    proxy.scrollTo(SectionId.recipe, anchor: .top)
                }
            }
        }
    }
    
    @ViewBuilder
    func recipeLink(for url: URL?) -> some View {
        // Show WebView button if recipe url is present
        if let url {
            Button {
                recipeURL = url
            } label: {
                Label("Recipe", systemImage: "book.pages")
            }
            .foregroundStyle(.mint)
            .colorMultiply(.white)
        }
    }
    
    @ViewBuilder
    func youtubeLink(for url: URL?) -> some View {
        // Show Link if youtube url is present
        if let url {
            Link(destination: url) {
                Label("Youtube", systemImage: "video.badge.checkmark")
            }
            .foregroundStyle(.red)
            .colorMultiply(.white)
        }
    }
    
    /**
     A variation of the `BackgroundView`, instead of loading the image from assets,
     it loads them from the provided image url.
     */
    struct DessertDetailBackground<Content: View>: View {
        let url: URL?
        @ViewBuilder let content: () -> Content
        
        var body: some View {
            ZStack {
                GeometryReader { _ in
                    NetworkImage(url: url) { image in
                        image
                            .resizable()
                            .scaledToFill()
                    } placeholder: {
                        Image("DessertsBackground")
                            .resizable()
                            .scaledToFill()
                    }
                    .scaleEffect(1.1)
                    .overlay {
                        Rectangle()
                            .foregroundStyle(.ultraThinMaterial)
                    }
                }
                .ignoresSafeArea()
                
                content()
            }
        }
    }
}
