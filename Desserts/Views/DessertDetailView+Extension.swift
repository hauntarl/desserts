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
        AsyncImage(url: url) { image in
            image
                .resizable()
                .scaledToFit()
        } placeholder: {
            Image(systemName: "photo")
                .resizable()
                .scaledToFit()
                .foregroundStyle(.gray)
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
        }
    }
    
    func drawBackground(using thumbnail: URL?) -> some View {
        GeometryReader { _ in
            AsyncImage(url: thumbnail) { image in
                image
                    .resizable()
                    .scaledToFill()
                    .blur(radius: 20)
                    .ignoresSafeArea()
            } placeholder: {
                Color.secondary
            }
        }
    }
}
