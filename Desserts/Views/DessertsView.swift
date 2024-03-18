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
    
    public var body: some View {
        NavigationStack {
            List(viewModel.desserts) { item in
                NavigationLink(value: item.id) {
                    itemLabel(for: item)
                }
            }
            .task {
                // Load desserts when the view appears
                await viewModel.getDesserts()
            }
            .refreshable {
                // Pull to refresh
                await viewModel.getDesserts()
            }
            .navigationTitle("Desserts")
            .navigationDestination(for: String.self) { id in
                // TODO: Push DessertsDetail view
                Text(id)
            }
        }
        .searchable(
            text: $viewModel.searchText,
            prompt: "What are you craving for?"
        )  // Filter results based on user's search query
    }
    
    private func itemLabel(for item: DessertItem) -> some View {
        Label {
            Text(item.name)
        } icon: {
            AsyncImage(url: item.thumbnail) { image in
                image
                    .resizable()
                    .scaledToFill()
            } placeholder: {
                ProgressView()
            }
            .frame(width: 30, height: 30)
            .clipShape(.circle)
        }
    }
}

#Preview {
    DessertsView()
}
