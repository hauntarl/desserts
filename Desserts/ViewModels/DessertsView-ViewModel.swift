//
//  DessertsView-ViewModel.swift
//  Desserts
//
//  Created by Sameer Mungole on 3/18/24.
//

import Foundation
import SwiftUI

extension DessertsView {
    /**
     ViewModel for the DessertsView
     
     Responsible for:
     - Loading desserts from the [themealdb.com](https://themealdb.com/api/json/v1/1/filter.php?c=Dessert) api.
     */
    @Observable
    public class ViewModel {
        private let networkManager: NetworkManager
        
        /**
         A custom initializer required for unit testing while mocking the `URLSession` object.
         
         By using a default argument (in this case `.shared`) we can add dependency injection without
         making our app code more complicated.
         */
        public init(networkManager: NetworkManager = .shared) {
            self.networkManager = networkManager
        }
        
        var retryCount = 0
        
        /**
         Loads the list of desserts from [themealdb.com](https://themealdb.com/api/json/v1/1/filter.php?c=Dessert) api.
         Sorts them in ascending order based on the `name` key.
         */
        public func getDesserts() async -> ViewState<[DessertItem]> {
            let urlString = NetworkManager.dessertItemsURL
            do {
                let result: DessertItemResult = try await networkManager.loadData(from: urlString)
                // Remove desserts that have missing id, name, or thumbnail.
                let desserts = result.meals
                    .filter { !$0.id.isEmpty && !$0.name.isEmpty && $0.thumbnail != .none}
                    .sorted { $0.name < $1.name }
                
                guard !desserts.isEmpty else {
                    return .failure(message: "**[themealdb](\(urlString))** returned either empty or invalid data.")
                }
                if retryCount < 3 {
                    retryCount += 1
                    return .failure(message: "**[themealdb](\(urlString))** returned either empty or invalid data.")
                }
                retryCount = 0
                return .success(data: desserts)
            } catch {
                return .failure(message: "\(error.localizedDescription)")
            }
        }
    }
}
