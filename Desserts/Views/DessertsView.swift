//
//  DessertsView.swift
//  Desserts
//
//  Created by Sameer Mungole on 3/18/24.
//

import SwiftUI

/**
 Displays a list of meals in the Dessert category, sorted alphabetically from the
 [themealdb.com](https://themealdb.com/api/json/v1/1/filter.php?c=Dessert) api.
 */
public struct DessertsView: View {
    @State private var viewModel = ViewModel()
    @State private var viewState = ViewState.loading
    
    @State private var desserts = [DessertItem]()  // Stores api results
    @State private var filtered = [DessertItem]()  // Provides filtered view
    @State private var searchText = ""
    
    public var body: some View {
        NavigationStack {
            Group {
                switch viewState {
                case .loading:
                    ProgressView()
                case .success:
                    dessertItems
                case .failure(let message):
                    contentUnavailable(reason: message)
                }
            }
            .navigationTitle("Desserts")
        }
        .task {
            // Load desserts when the view appears
            await getDesserts()
        }
    }
    
    private var dessertItems: some View {
        List(filtered) { item in
            NavigationLink(value: item.id) {
                itemLabel(for: item)
            }
        }
        .refreshable {
            // Pull to refresh
            await getDesserts()
        }
        .searchable(
            text: $searchText,
            prompt: "What are you craving for?"
        )  // Filter results based on user's search query
        .onChange(of: searchText) {
            filterDesserts()
        }
        .navigationDestination(for: String.self) { id in
            // Push DessertsDetail view
            DessertDetailView(id: id)
        }
    }
    
    private func itemLabel(for item: DessertItem) -> some View {
        Label {
            Text(item.name)
        } icon: {
            NetworkImage(url: item.thumbnail) { image in
                image
                    .resizable()
                    .scaledToFill()
            } placeholder: {
                Rectangle()
                    .foregroundStyle(.thickMaterial)
            }
            .frame(width: 30, height: 30)
            .clipShape(.circle)
        }
    }
    
    private func contentUnavailable(reason: LocalizedStringKey) -> some View {
        ContentUnavailableView {
            VStack {
                Image("DessertsUnavailable")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 100, height: 100)
                
                Text("Unavailable at the moment")
                    .font(.title)
                
                (Text(reason) + Text("**Tap to retry!**"))
                    .font(.callout)
            }
        }
        .onTapGesture {
            Task {
                await getDesserts()
            }
        }
    }
    
    private func getDesserts() async {
        withAnimation {
            self.viewState = .loading
        }
        
        let viewState = await viewModel.getDesserts()
        withAnimation(.easeOut(duration: 0.5)) {
            self.viewState = viewState
            switch viewState {
            case .success(let desserts):
                self.desserts = desserts
                self.filtered = desserts
            default:
                break
            }
        }
    }
    
    private func filterDesserts() {
        withAnimation(.bouncy(duration: 0.5)) {
            filtered = searchText.isEmpty ? desserts : desserts.filter {
                $0.name.localizedCaseInsensitiveContains(searchText)
            }
        }
    }
}

#Preview {
    DessertsView()
}
