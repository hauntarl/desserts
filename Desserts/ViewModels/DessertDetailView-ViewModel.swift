//
//  DessertDetailView-ViewModel.swift
//  Desserts
//
//  Created by Sameer Mungole on 3/18/24.
//

import Foundation
import SwiftUI

extension DessertDetailView {
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
        
        public var dessert: DessertDetail?
        public var sections = [SectionId]()
        
        /**
         Loads the dessert details from [themealdb.com](https://themealdb.com/api/json/v1/1/lookup.php?i=52894) api.
         */
        public func getDessertDetails(for id: String) async -> ViewState {
            let urlString = "\(NetworkManager.dessertDetailsURL)?i=\(id)"
            do {
                let data: DessertDetailResult = try await networkManager.loadData(from: urlString)
                // Verify if required fields are present in the result
                guard let result = data.meals.first, !result.name.isEmpty, result.thumbnail != .none else {
                    return .failure(message: "**[themealdb](\(urlString))** returned either empty or invalid data.")
                }
                
                dessert = result
                return .success
            } catch {
                return .failure(message: "\(error.localizedDescription)")
            }
        }
        
        /**
         Based on the retrieved dessert details, `updateSections()` calculates total sections that will
         have non-nil data in the List view.
         */
        public func updateSections() {
            guard let dessert else {
                sections.removeAll()
                return
            }
            
            sections = [.info]
            if !dessert.ingredients.isEmpty {
                sections.append(.items)
            }
            if !dessert.instructions.isEmpty {
                sections.append(.recipe)
            }
            if dessert.youtubeLink != nil || dessert.sourceLink != nil {
                sections.append(.links)
            }
        }
    }
    
    /**
     SectionID is used as anchor points for ScrollViewProxy to jump between different sections of the
     DessertDetailView.
     */
    public enum SectionId: String, Hashable, CaseIterable {
        case info
        case items
        case recipe
        case links
    }
}
