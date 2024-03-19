//
//  DessertItem.swift
//  Desserts
//
//  Created by Sameer Mungole on 3/18/24.
//

import Foundation

/**
 `DessertItem` model is used to display result of querying Desserts from [themealdb.com](https://themealdb.com/api/json/v1/1/filter.php?c=Dessert)
 */
public struct DessertItem: Decodable, Identifiable, Equatable {
    public let id: String
    public let name: String
    public let thumbnail: URL?
    
    enum CodingKeys: CodingKey {
        case idMeal
        case strMeal
        case strMealThumb
    }
    
    /**
     A custom decoder that efficiently maps json response to respective Swift objects.
     This is done to avoid creation of intermediate data models.
     */
    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        // Getting rid of null values, and whitespaces.
        self.id = (try container.decodeIfPresent(String.self, forKey: .idMeal) ?? "")
            .trimmingCharacters(in: .whitespacesAndNewlines)
        
        self.name = (try container.decodeIfPresent(String.self, forKey: .strMeal) ?? "")
            .trimmingCharacters(in: .whitespacesAndNewlines)
        
        // Parse the url string into Swift's URL object
        let thumbnailURL = (try container.decodeIfPresent(String.self, forKey: .strMealThumb) ?? "")
            .trimmingCharacters(in: .whitespacesAndNewlines)
        self.thumbnail = URL(string: thumbnailURL)
    }
    
    /**A custom initializer required for unit testing and mocking data for previews.*/
    public init(id: String, name: String, thumbnail: URL?) {
        self.id = id
        self.name = name
        self.thumbnail = thumbnail
    }
}

/**
 `DessertItemResult` is a wrapper model required to correctly represent the structure of json
 response from the [themealdb.com](https://themealdb.com/api/json/v1/1/filter.php?c=Dessert)
 api to fetch the list of all the desserts.
 */
public struct DessertItemResult: Decodable, Equatable {
    public let meals: [DessertItem]
    
    /**A custom initializer required for unit testing and mocking data for previews.*/
    public init(meals: [DessertItem]) {
        self.meals = meals
    }
}
