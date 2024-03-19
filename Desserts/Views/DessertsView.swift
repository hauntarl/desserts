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
    @State private var desserts = [DessertItem]()  // Stores api results
    @State private var filtered = [DessertItem]()  // Provides filtered view
    @State private var searchText = ""
    
    public var body: some View {
        NavigationStack {
            List(filtered) { item in
                NavigationLink(value: item.id) {
                    itemLabel(for: item)
                }
            }
            .task {
                // Load desserts when the view appears
                await getDesserts()
            }
            .refreshable {
                // Pull to refresh
                await getDesserts()
            }
            .navigationTitle("Desserts")
            .navigationDestination(for: String.self) { id in
                // Push DessertsDetail view
                DessertDetailView(id: id)
            }
        }
        .searchable(
            text: $searchText,
            prompt: "What are you craving for?"
        )  // Filter results based on user's search query
        .onChange(of: searchText) {
            withAnimation {
                filterDesserts()
            }
        }
    }
    
    private func getDesserts() async {
        let items = await viewModel.getDesserts()
        withAnimation {
            self.desserts = items
            filterDesserts()
        }
    }
    
    private func filterDesserts() {
        filtered = searchText.isEmpty ? desserts : desserts.filter {
            $0.name.localizedCaseInsensitiveContains(searchText)
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
}

#Preview {
    DessertsView()
}
