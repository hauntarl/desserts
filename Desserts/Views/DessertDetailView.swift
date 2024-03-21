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
    @State private var viewState: ViewState<DessertDetail> = .loading
    
    @State private var dessert: DessertDetail?
    @State private var isRecipeExpanded = false
    @State private var recipeURL: URL?
    
    @State private var sections = [SectionId]()
    @State private var selectedSection = SectionId.info
    
    public var body: some View {
        // ScrollViewReader is used to jump to different sections of the view
        DessertDetailBackground(url: dessert?.thumbnail) {
            switch viewState {
            case .loading:
                ProgressView()
                    .transition(.opacity)
            case .success(let dessert):
                details(for: dessert)
                    .transition(.move(edge: .trailing))
            case .failure(let message):
                ErrorView(
                    image: "RecipeUnavailable",
                    title: "Recipe unavailable :(",
                    message: message
                ) {
                    await getDessertDetails()
                }
                .transition(.opacity)
            }
        }
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
        .sheet(item: $recipeURL) { url in
            WebView(url: url)
                .ignoresSafeArea()
        }
        .task {
            await getDessertDetails()
        }
    }
    
    private func getDessertDetails() async {
        withAnimation {
            self.viewState = .loading
        }
        
        let viewState = await viewModel.getDessertDetails(for: id)
        withAnimation(.easeOut(duration: 0.5)) {
            self.viewState = viewState
            switch viewState {
            case .success(let dessert):
                self.dessert = dessert
                self.sections = viewModel.updateSections(for: dessert)
            default:
                break
            }
        }
    }
    
    private func details(for dessert: DessertDetail) -> some View {
        ScrollViewReader { proxy in
            List {
                Section {
                    Text(dessert.name).bold()
                    image(from: dessert.thumbnail)
                    tags(from: dessert.formattedTags)
                }
                .id(SectionId.info)
                
                // If ingredients are missing, skip this section
                if sections.contains(.items) {
                    Section {
                        loadItems(from: dessert.ingredients)
                    } header: {
                        header(for: SectionId.items.rawValue)
                    }
                    .id(SectionId.items)
                }
                
                // If instructions are missing, skip this section
                if sections.contains(.recipe) {
                    Section {
                        loadRecipe(from: dessert.instructions, proxy: proxy)
                    } header: {
                        header(for: SectionId.recipe.rawValue)
                    }
                    .id(SectionId.recipe)
                }
                
                // If both youtube and recipe links are missing, skip this section
                if sections.contains(.links) {
                    Section {
                        // Opens the recipe website in a WebView through .sheet() modifier
                        webView(for: dessert.sourceLink)
                        // Opens the youtube link in a browser
                        youtubeLink(for: dessert.youtubeLink)
                    } header: {
                        header(for: SectionId.links.rawValue)
                    }
                    .id(SectionId.links)
                }
            }
            .shadow(radius: 10)
            .safeAreaInset(edge: .bottom) {
                sectionPicker(proxy)
            }
            .scrollContentBackground(.hidden)
        }
    }
    
    @ViewBuilder
    private func loadRecipe(from instructions: [String], proxy: ScrollViewProxy) -> some View {
        let steps = isRecipeExpanded ? instructions[...] : instructions[0..<1]
        ForEach(steps, id: \.self) { step in
            Text(step)
        }
        
        // If there's only one step in the instructions then skip this button
        if instructions.count > 1 {
            Button(isRecipeExpanded ? "Close" : "Read more") {
                withAnimation(.bouncy(duration: 0.5)) {
                    isRecipeExpanded.toggle()
                    proxy.scrollTo(SectionId.recipe, anchor: .top)
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
            .foregroundStyle(.mint.opacity(0.7))
        }
    }
    
    private func sectionPicker(_ proxy: ScrollViewProxy) -> some View {
        // Creates a segmented picker view that allows a user to jump between sections.
        Picker("", selection: $selectedSection) {
            ForEach(sections, id: \.self) { section in
                Text(section.rawValue.uppercased())
                    .tag(section)
            }
        }
        .pickerStyle(.segmented)
        .padding([.top, .horizontal])
        .background(.thinMaterial)
        .onChange(of: selectedSection) {
            withAnimation(.bouncy(duration: 0.5)) {
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
    .preferredColorScheme(.dark)
}
