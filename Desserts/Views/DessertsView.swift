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
    private let animationCurve: Animation = .easeOut(duration: 0.5)
    
    @State private var viewModel = ViewModel()
    @State private var viewState: ViewState<Void> = .loading
    
    public var body: some View {
        NavigationStack {
            BackgroundView(image: "DessertsBackground") {
                switch viewState {
                case .loading:
                    ProgressView()
                        .transition(.blurReplace)
                case .success:
                    dessertItems
                        .transition(.asymmetric(
                            insertion: .move(edge: .trailing),
                            removal: .move(edge: .leading)
                        ))
                case .failure(let message):
                    // Try reloading desserts when user clicks Tap to retry
                    ErrorView(
                        image: "DessertsUnavailable",
                        title: "No Doughnuts :(",
                        message: message
                    ) {
                        withAnimation(animationCurve) {
                            viewState = .loading
                        }
                        await getDesserts()
                    }
                    .transition(.blurReplace)
                }
            }
            .navigationTitle("Desserts")
        }
        .task {
            withAnimation(animationCurve) {
                viewState = .loading
            }
            await getDesserts()
        }  // Load desserts when the view appears
    }
    
    private var dessertItems: some View {
        List(viewModel.desserts) { item in
            NavigationLink(value: item.id) {
                itemLabel(for: item)
            }
        }
        .searchable(
            text: $viewModel.searchText,
            prompt: "What are you craving for?"
        )  // Filter results based on user's search query
        .refreshable {
            await getDesserts()
        }  // Pull to refresh
        .scrollContentBackground(.hidden)
        .onChange(of: viewModel.searchText) {
            withAnimation(animationCurve) {
                viewModel.filterDesserts()
            }
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
    
    private func getDesserts() async {
        let newState = await viewModel.getDesserts()
        withAnimation(animationCurve) {
            viewState = newState
        }
    }
}

#Preview {
    DessertsView()
        .preferredColorScheme(.dark)
}
