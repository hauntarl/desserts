//
//  DessertsView-ViewModel.swift
//  Desserts
//
//  Created by Sameer Mungole on 3/18/24.
//

import Foundation

extension DessertsView {
    /**
     ViewModel for the DessertsView
     
     Responsible for:
     - Loading desserts from the [themealdb.com](https://themealdb.com/api/json/v1/1/filter.php?c=Dessert) api.
     - Providing a way for user to search through the list of desserts.
     */
    @Observable
    public class ViewModel {
        private let networkManager: NetworkManager
        private var items = [DessertItem]()  // Stores api results
        
        /**
         A custom initializer required for unit testing while mocking the `URLSession` object.
         
         By using a default argument (in this case `.shared`) we can add dependency injection without
         making our app code more complicated.
         */
        public init(networkManager: NetworkManager = .shared) {
            self.networkManager = networkManager
        }
        
        public var searchText = ""
        public var desserts: [DessertItem] {
            searchText.isEmpty ? items : items.filter {
                $0.name.localizedCaseInsensitiveContains(searchText)
            }
        }  // Provides a filtered view of API results based on current value of searchText
        
        /**
         Loads the list of desserts from [themealdb.com](https://themealdb.com/api/json/v1/1/filter.php?c=Dessert) api.
         Sorts them in ascending order based on the `name` key.
         */
        public func getDesserts() async {
            let urlString = NetworkManager.dessertItemsURL
            do {
                let result: DessertItemResult = try await networkManager.loadData(from: urlString)
                // Remove desserts that have missing id, name, or thumbnail.
                items = result.meals
                    .filter { !$0.id.isEmpty && !$0.name.isEmpty && $0.thumbnail != .none}
                    .sorted { $0.name < $1.name }
            } catch {
                // Purposefully left error handling, to keep the views and view models as simple as possible.
                print(error.localizedDescription)
            }
        }
    }
}
