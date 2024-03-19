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
    
    @Environment(\.dismiss) private var dismiss
    @State private var viewModel = ViewModel()
    @State private var steps = 1
    @State private var recipeURL: URL?
    @State private var selectedSection = SectionId.info
    
    public var body: some View {
        // ScrollViewReader is used to jump to different sections of the view
        ZStack {
            drawBackground(using: viewModel.dessert?.thumbnail)
            details
        }
        .navigationBarBackButtonHidden()
        .sheet(item: $recipeURL) { url in
            WebView(url: url)
                .ignoresSafeArea()
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
                    Section {
                        Text(dessert.name).bold()
                        image(from: dessert.thumbnail)
                        tags(from: dessert.formattedTags)
                    }
                    .id(SectionId.info)
                    
                    // If ingredients are missing, skip this section
                    if viewModel.sections.contains(.items) {
                        Section {
                            loadItems(from: dessert.ingredients)
                        } header: {
                            header(for: SectionId.items.rawValue)
                        }
                        .id(SectionId.items)
                    }
                    
                    // If instructions are missing, skip this section
                    if viewModel.sections.contains(.recipe) {
                        Section {
                            loadRecipe(from: dessert.instructions, proxy: proxy)
                        } header: {
                            header(for: SectionId.recipe.rawValue)
                        }
                        .id(SectionId.recipe)
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
            .safeAreaInset(edge: .top) {
                backButton {
                    dismiss()
                }
            }
            .safeAreaInset(edge: .bottom) {
                sectionPicker(proxy)
            }
            .scrollContentBackground(.hidden)
        }
    }
    
    @ViewBuilder
    private func loadRecipe(from instructions: [String], proxy: ScrollViewProxy) -> some View {
        ForEach(instructions[0..<steps], id: \.self) { step in
            Text(step)
        }
        
        // If there's only one step in the instructions then skip this button
        if instructions.count > 1 {
            Button(steps < instructions.count ? "Read more" : "Close") {
                withAnimation(.bouncy) {
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
            ForEach(viewModel.sections, id: \.self) { section in
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
