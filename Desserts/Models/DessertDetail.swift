//
//  DessertDetail.swift
//  Desserts
//
//  Created by Sameer Mungole on 3/18/24.
//

import Foundation

/**
 `DessertDetail` model is used to display result of querying Dessert Details from [themealdb.com](https://themealdb.com/api/json/v1/1/lookup.php?i=52894)
 */
public struct DessertDetail: Decodable, Equatable {
    public let name: String
    public let thumbnail: URL?
    public let area: String
    public let tags: [String]
    public let instructions: [String]
    public let ingredients: [Ingredient]
    public let youtubeLink: URL?
    public let sourceLink: URL?
    
    private enum CodingKeys: CodingKey {
        case strMeal
        case strMealThumb
        case strArea
        case strTags
        case strInstructions
        case strYoutube
        case strSource
        
        case strIngredient1, strIngredient2, strIngredient3, strIngredient4, strIngredient5, strIngredient6
        case strIngredient7, strIngredient8, strIngredient9, strIngredient10, strIngredient11, strIngredient12
        case strIngredient13, strIngredient14, strIngredient15, strIngredient16, strIngredient17, strIngredient18
        case strIngredient19, strIngredient20
        
        case strMeasure1, strMeasure2, strMeasure3, strMeasure4, strMeasure5, strMeasure6, strMeasure7, strMeasure8
        case strMeasure9, strMeasure10, strMeasure11, strMeasure12, strMeasure13, strMeasure14, strMeasure15
        case strMeasure16, strMeasure17, strMeasure18, strMeasure19, strMeasure20
    }
    
    private static let ingredientKeys: [CodingKeys] = [
        .strIngredient1, .strIngredient2, .strIngredient3, .strIngredient4, .strIngredient5, .strIngredient6,
        .strIngredient7, .strIngredient8, .strIngredient9, .strIngredient10, .strIngredient11, .strIngredient12,
        .strIngredient13, .strIngredient14, .strIngredient15, .strIngredient16, .strIngredient17, .strIngredient18,
        .strIngredient19, .strIngredient20
    ]
    private static let measureKeys: [CodingKeys] = [
        .strMeasure1, .strMeasure2, .strMeasure3, .strMeasure4, .strMeasure5, .strMeasure6, .strMeasure7, .strMeasure8,
        .strMeasure9, .strMeasure10, .strMeasure11, .strMeasure12, .strMeasure13, .strMeasure14, .strMeasure15,
        .strMeasure16, .strMeasure17, .strMeasure18, .strMeasure19, .strMeasure20
    ]
    
    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        // Getting rid of null values, and whitespaces.
        self.name = (try container.decodeIfPresent(String.self, forKey: .strMeal) ?? "")
            .trimmingCharacters(in: .whitespacesAndNewlines)
        
        self.instructions = (try container.decodeIfPresent(String.self, forKey: .strInstructions) ?? "")
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .split(separator: "\r\n")
            .map { String($0) }
        
        self.area = (try container.decodeIfPresent(String.self, forKey: .strArea) ?? "")
            .trimmingCharacters(in: .whitespacesAndNewlines)

        // Parse the thumbnail string into Swift's URL object
        let thumbnailURL = (try container.decodeIfPresent(String.self, forKey: .strMealThumb) ?? "")
            .trimmingCharacters(in: .whitespacesAndNewlines)
        self.thumbnail = URL(string: thumbnailURL)
        
        // Parse the youtube string into Swift's URL object
        let youtubeURL = (try container.decodeIfPresent(String.self, forKey: .strYoutube) ?? "")
            .trimmingCharacters(in: .whitespacesAndNewlines)
        self.youtubeLink = URL(string: youtubeURL)
        
        // Parse the source string into Swift's URL object
        let sourceURL = (try container.decodeIfPresent(String.self, forKey: .strSource) ?? "")
            .trimmingCharacters(in: .whitespacesAndNewlines)
        self.sourceLink = URL(string: sourceURL)
        
        // Parse tags into a list of string
        let tags = (try container.decodeIfPresent(String.self, forKey: .strTags) ?? "")
            .trimmingCharacters(in: .whitespacesAndNewlines)
        self.tags = !tags.isEmpty ? tags.split(separator: ",").map { String($0) } : []
        
        // Parse ingredients, maps each ingredient number to the corresponding measure number
        // Gets rid of nil value, and whitespaces.
        // Skips empty values, and duplicate ingredients
        var ingredients: Set<Ingredient> = []
        for i in 0..<Self.ingredientKeys.count {
            let name = (try container.decodeIfPresent(String.self, forKey: Self.ingredientKeys[i]) ?? "")
                .trimmingCharacters(in: .whitespacesAndNewlines)
            
            if !name.isEmpty {
                let quantity = (try container.decodeIfPresent(String.self, forKey: Self.measureKeys[i]) ?? "")
                    .trimmingCharacters(in: .whitespacesAndNewlines)
                
                ingredients.insert(Ingredient(name: name, quantity: quantity))
            }
        }
        // Sort ingredients alphabetically
        self.ingredients = ingredients.map { $0 }.sorted { $0.name < $1.name }
    }
    
    /**A custom initializer required for unit testing and mocking data for previews.*/
    public init(
        name: String,
        thumbnail: URL?,
        area: String,
        tags: [String],
        instructions: String,
        ingredients: [Ingredient],
        youtubeLink: URL?,
        sourceLink: URL?
    ) {
        self.name = name
        self.thumbnail = thumbnail
        self.area = area
        self.tags = tags
        // Split instructions into steps
        self.instructions = instructions.split(separator: "\r\n").map { String($0) }
        // Remove duplicate ingredients, and sort them alphabetically
        self.ingredients = Set(ingredients).map { $0 }.sorted { $0.name < $1.name }
        self.youtubeLink = youtubeLink
        self.sourceLink = sourceLink
    }
    
    public var formattedTags: String {
        var tags = [String]()
        if !area.isEmpty {
            tags.append(area)
        }
        tags.append(contentsOf: self.tags)
        return tags.joined(separator: " • ")
    }
}

/**
 Ingredient model is used to combine each ingredient with its corresponding measurement from
 the [themealdb.com](https://themealdb.com/api/json/v1/1/lookup.php?i=52894) api call.
 */
public struct Ingredient: Decodable, Equatable, Hashable {
    public let name: String
    public let quantity: String
    
    /**A custom initializer required for unit testing and mocking data for previews.*/
    public init(name: String, quantity: String) {
        self.name = name
        self.quantity = quantity
    }
    
    /**
     Creates a uniform description of the ingredient, taking into account the possibility
     that quantity could be empty.
     */
    public var description: String {
        var desc = name
        if !quantity.isEmpty {
            desc.append(" \(quantity)")
        }
        return desc
    }
}

/**
 `DessertDetailResult` is a wrapper model required to correctly represent the structure of json
 response from the [themealdb.com](https://themealdb.com/api/json/v1/1/lookup.php?i=52894)
 api to fetch the list of all the desserts.
 */
public struct DessertDetailResult: Decodable, Equatable {
    public let meals: [DessertDetail]
    
    /**A custom initializer required for unit testing and mocking data for previews.*/
    public init(meals: [DessertDetail]) {
        self.meals = meals
    }
    
    enum CodingKeys: CodingKey {
        case meals
    }
    
    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        // Handle null as a possible value of meals attribute
        self.meals = try container.decodeIfPresent([DessertDetail].self, forKey: .meals) ?? []
    }
}
