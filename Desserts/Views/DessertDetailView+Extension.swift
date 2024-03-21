//
//  DessertDetailView+Extension.swift
//  Desserts
//
//  Created by Sameer Mungole on 3/19/24.
//

import SwiftUI

extension DessertDetailView {
    func backButton(_ action: @escaping () -> Void) -> some View {
        HStack {
            Button("Back", systemImage: "chevron.left") {
                action()
            }
            .foregroundStyle(.primary)
            
            Spacer()
        }
        .padding([.bottom, .horizontal])
        .background(.thinMaterial)
    }
    
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
    
    func loadItems(from ingredients: [Ingredient]) -> some View {
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
    func youtubeLink(for url: URL?) -> some View {
        // Show Link if youtube url is present
        if let url {
            Link(destination: url) {
                Label("Youtube", systemImage: "rectangle.portrait.and.arrow.forward")
            }
            .foregroundStyle(.red.opacity(0.7))
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
                    .ignoresSafeArea()
                }
                
                content()
            }
        }
    }
}
