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
    
    let animationCurve: Animation = .easeOut(duration: 0.5)
    
    @Environment(\.dismiss) var dismiss
    @State var viewModel = ViewModel()
    @State var viewState: ViewState = .loading
    
    @State var isRecipeExpanded = false
    @State var recipeURL: URL?
    @State var selectedSection = SectionId.info
    
    public var body: some View {
        // ScrollViewReader is used to jump to different sections of the view
        ScrollViewReader { proxy in
            DessertDetailBackground(url: viewModel.dessert?.thumbnail) {
                switch viewState {
                case .loading:
                    ProgressView()
                        .transition(.blurReplace)
                case .success:
                    if let dessert = viewModel.dessert {
                        details(for: dessert, proxy)
                            .transition(.move(edge: .trailing))
                    }
                case .failure(let message):
                    ErrorView(
                        image: "RecipeUnavailable",
                        title: "Recipe unavailable :(",
                        message: message
                    ) {
                        await getDessertDetails()
                    }
                    .transition(.blurReplace)
                }
            }
            .navigationTitle("")
            .navigationBarTitleDisplayMode(.inline)
            .safeAreaInset(edge: .bottom) {
                if !viewModel.sections.isEmpty {
                    sectionPicker(proxy)
                        .transition(.move(edge: .bottom))
                }
            }
            .sheet(item: $recipeURL) { url in
                WebView(url: url)
                    .ignoresSafeArea()
            }
            .task {
                await getDessertDetails()
            }
        }
    }
    
    private func getDessertDetails() async {
        withAnimation(animationCurve) {
            self.viewState = .loading
        }
        
        let newState = await viewModel.getDessertDetails(for: id)
        withAnimation(animationCurve) {
            viewState = newState
            viewModel.updateSections()
        }
    }
    
    private func details(for dessert: DessertDetail, _ proxy: ScrollViewProxy) -> some View {
        List {
            Section {
                Text(dessert.name).bold()
                image(for: dessert.thumbnail)
                buildTags(from: dessert.formattedTags)
            }
            .id(SectionId.info)
            
            // If ingredients are missing, skip this section
            if viewModel.sections.contains(.items) {
                Section {
                    buildRecipeItems(from: dessert.ingredients)
                } header: {
                    header(for: SectionId.items.rawValue)
                }
                .id(SectionId.items)
            }
            
            // If instructions are missing, skip this section
            if viewModel.sections.contains(.recipe) {
                Section {
                    buildRecipe(from: dessert.instructions, proxy: proxy)
                } header: {
                    header(for: SectionId.recipe.rawValue)
                }
                .id(SectionId.recipe)
            }
            
            // If both youtube and recipe links are missing, skip this section
            if viewModel.sections.contains(.links) {
                Section {
                    // Opens the recipe website in a WebView through .sheet() modifier
                    recipeLink(for: dessert.sourceLink)
                    // Opens the youtube link in a browser
                    youtubeLink(for: dessert.youtubeLink)
                } header: {
                    header(for: SectionId.links.rawValue)
                }
                .id(SectionId.links)
            }
        }
        .shadow(radius: 10)
        .scrollContentBackground(.hidden)
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
            withAnimation(animationCurve) {
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
