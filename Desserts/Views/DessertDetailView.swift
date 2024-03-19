//
//  DessertDetailView.swift
//  Desserts
//
//  Created by Sameer Mungole on 3/18/24.
//

import SwiftUI

/**
 Displays details about the Dessert selected by the user from
 [themealdb.com](https://themealdb.com/api/json/v1/1/lookup.php?i=52894) api.
 */
public struct DessertDetailView: View {
    public let id: String
    
    /**Receives `id` as the only parameter, required to fetch dessert details.*/
    public init(id: String) {
        self.id = id
    }
    
    @State private var viewModel = ViewModel()
    @State private var steps = 1
    @State private var recipeURL: URL?
    @State private var selectedSection = SectionId.ingredients
    
    public var body: some View {
        // ScrollViewReader is used to jump to different sections of the view
        ZStack {
            background
            details
                .navigationTitle(viewModel.dessert?.name ?? id)
                .navigationBarTitleDisplayMode(.inline)
                .sheet(item: $recipeURL) { url in
                    WebView(url: url)
                        .ignoresSafeArea()
                }
        }
        .task {
            await viewModel.getDessertDetails(for: id)
            viewModel.updateSections()
        }
    }
    
    private var details: some View {
        ScrollViewReader { proxy in
            List {
                if let dessert = viewModel.dessert {
                    // If both thumbnail and tags are missing, skip this section
                    if viewModel.sections.contains(.imageAndTags) {
                        Section {
                            image(from: dessert.thumbnail)
                            tags(from: dessert.formattedTags)
                        }
                        .id(SectionId.imageAndTags)
                    }
                    
                    // If ingredients are missing, skip this section
                    if viewModel.sections.contains(.ingredients) {
                        Section {
                            loadIngredients(from: dessert.ingredients)
                        } header: {
                            header(for: SectionId.ingredients.rawValue)
                        }
                        .id(SectionId.ingredients)
                    }
                    
                    // If instructions are missing, skip this section
                    if viewModel.sections.contains(.instructions) {
                        Section {
                            loadSteps(from: dessert.instructions, proxy: proxy)
                        } header: {
                            header(for: SectionId.instructions.rawValue)
                        }
                        .id(SectionId.instructions)
                    }
                    
                    // If both youtube and recipe links are missing, skip this section
                    if viewModel.sections.contains(.links) {
                        Section {
                            // Opens the youtube link in a browser
                            youtubeLink(for: dessert.youtubeLink)
                            // Opens the recipe website in a WebView through .sheet() modifier
                            webView(for: dessert.sourceLink)
                        } header: {
                            header(for: SectionId.links.rawValue)
                        }
                        .id(SectionId.links)
                    }
                }
            }
            .shadow(radius: 10)
            .safeAreaInset(edge: .bottom) {
                sectionPicker(proxy)
            }
            .scrollContentBackground(.hidden)
        }
    }
    
    private func header(for title: String) -> some View {
        Text(title)
            .font(.caption)
            .foregroundStyle(.background)
            .padding(6)
            .background {
                RoundedRectangle(cornerRadius: 10)
                    .foregroundStyle(.primary)
            }
    }
    
    private func image(from url: URL?) -> some View {
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
    private func tags(from formattedTags: String) -> some View {
        if !formattedTags.isEmpty {
            Text(formattedTags)
                .font(.subheadline)
        }
    }
    
    private func loadIngredients(from ingredients: [Ingredient]) -> some View {
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
    private func loadSteps(from instructions: [String], proxy: ScrollViewProxy) -> some View {
        ForEach(instructions[0..<steps], id: \.self) { step in
            Text(step)
        }
        
        // If there's only one step in the instructions then skip this button
        if instructions.count > 1 {
            Button(steps < instructions.count ? "Read more" : "Close") {
                withAnimation(.easeOut(duration: 0.3)) {
                    if steps < instructions.count {
                        steps += 1
                    } else {
                        steps = 1
                    }
                    proxy.scrollTo(SectionId.readMoreButton, anchor: .bottom)
                }
            }
            .id(SectionId.readMoreButton)
        }
    }
    
    @ViewBuilder
    private func youtubeLink(for url: URL?) -> some View {
        // Show Link if youtube url is present
        if let url {
            Link(destination: url) {
                Label("Youtube", systemImage: "video.fill.badge.checkmark")
            }
        }
    }
    
    @ViewBuilder
    private func webView(for url: URL?) -> some View {
        // Show WebView button if recipe url is present
        if let url {
            Button {
                recipeURL = url
            } label: {
                Label("Recipe", systemImage: "book.pages")
            }
        }
    }
    
    private func sectionPicker(_ proxy: ScrollViewProxy) -> some View {
        // Creates a segmented picker view that allows a user to jump between sections.
        Picker("", selection: $selectedSection) {
            ForEach(viewModel.sections.dropFirst(), id: \.self) { section in
                Text(section.rawValue.uppercased())
                    .tag(section)
            }
        }
        .pickerStyle(.segmented)
        .padding([.top, .horizontal])
        .background(.thinMaterial)
        .onChange(of: selectedSection) {
            withAnimation {
                proxy.scrollTo(selectedSection, anchor: .top)
            }
        }
    }
    
    private var background: some View {
        GeometryReader { proxy in
            if let dessert = viewModel.dessert {
                AsyncImage(url: dessert.thumbnail) { image in
                    image
                        .resizable()
                        .scaledToFill()
                        .blur(radius: 20)
                        .ignoresSafeArea()
                } placeholder: {
                    Color.gray.opacity(0.2)
                }
            } else {
                Color.gray.opacity(0.2)
            }
        }
    }
}

/**
 Make `URL` conform to `Identifiable` protocol so that it can be used with the `.sheet()`
 modifier.
 */
extension URL: Identifiable {
    public var id: String { self.absoluteString }
}

#Preview {
    NavigationStack {
        DessertDetailView(id: "52894")
    }
}
