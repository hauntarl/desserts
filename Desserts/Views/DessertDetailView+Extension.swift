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
            // As the parent doesn't explicitly specify a size of the images, the images size themselves based on
            // their intrinsic dimensions. If the placeholder view has different dimensions, the transition will
            // cause a jump in the container dimensions.
            //
            // In order to get rid of this unintended effect, I've added a Placeholder image in the project's
            // asset. When you apply a .hidden() modifier on a view, and overlay the hidden view with some other
            // view, this view can take up to the dimensions of the hidden view.
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
                Label("Youtube", systemImage: "video.fill.badge.checkmark")
            }
            .foregroundStyle(.red.opacity(0.7))
        }
    }
    
    func drawBackground(using url: URL?) -> some View {
        GeometryReader { _ in
            NetworkImage(url: url) { image in
                image
                    .resizable()
                    .scaledToFill()
                    .overlay { Color.black.opacity(0.4) }
                    .blur(radius: 20)
                    .ignoresSafeArea()
            } placeholder: {
                Image("Placeholder")
                    .resizable()
                    .scaledToFill()
                    .hidden()
                    .overlay {
                        Rectangle().foregroundStyle(.thinMaterial)
                    }
                    .ignoresSafeArea()
            }
        }
    }
}
