//
//  DessertDetailView-ViewModel.swift
//  Desserts
//
//  Created by Sameer Mungole on 3/18/24.
//

import Foundation

extension DessertDetailView {
    public enum SectionId: String, Hashable, CaseIterable {
        case info
        case items
        case recipe
        case links
        case readMoreButton
    }
    
    /**
     ViewModel for the DessertDetailView
     
     Responsible for:
     - Loading dessert details from the [themealdb.com](https://themealdb.com/api/json/v1/1/lookup.php?i=52894) api.
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
        
        /**
         Loads the dessert details from [themealdb.com](https://themealdb.com/api/json/v1/1/lookup.php?i=52894) api.
         */
        public func getDessertDetails(for id: String) async -> DessertDetail? {
            let urlString = "\(NetworkManager.dessertDetailsURL)?i=\(id)"
            do {
                let result: DessertDetailResult = try await networkManager.loadData(from: urlString)
                // Verify if required fields are present in the result
                guard let dessert = result.meals.first, !dessert.name.isEmpty, dessert.thumbnail != .none else {
                    return nil
                }
                return dessert
            } catch {
                print(error.localizedDescription)
                return nil
            }
        }
        
        /**
         Based on the retrieved dessert details, `updateSections()` calculates total sections that will
         have non-nil data in the List view.
         */
        public func updateSections(for dessert: DessertDetail) -> [SectionId] {
            var sections: [SectionId] = [.info]
            if !dessert.ingredients.isEmpty {
                sections.append(.items)
            }
            if !dessert.instructions.isEmpty {
                sections.append(.recipe)
            }
            if dessert.youtubeLink != nil || dessert.sourceLink != nil {
                sections.append(.links)
            }
            return sections
        }
    }
}
