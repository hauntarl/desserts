//
//  DessertDetailTests.swift
//  DessertsTests
//
//  Created by Sameer Mungole on 3/18/24.
//

import Desserts
import XCTest

final class DessertDetailTests: XCTestCase {
    
    func testDessertDetailParsingDuplicateIngredients() throws {
        let expected = DessertDetail(
            name: "Battenberg Cake",
            thumbnail: URL(string: "https://www.themealdb.com/images/media/meals/ywwrsp1511720277.jpg"),
            area: "British",
            tags: ["Cake", "Sweet"],
            instructions: "Heat oven to 180C/160C fan/gas 4",
            ingredients: [
                Ingredient(name: "Butter", quantity: "175g"),
                Ingredient(name: "Caster Sugar", quantity: "175g"),
                Ingredient(name: "Self-raising Flour", quantity: "140g"),
                Ingredient(name: "Almonds", quantity: "50g"),
                Ingredient(name: "Baking Powder", quantity: "½ tsp"),
                Ingredient(name: "Eggs", quantity: "3 Medium"),
                Ingredient(name: "Vanilla Extract", quantity: "½ tsp"),
                Ingredient(name: "Almond Extract", quantity: "¼ teaspoon"),
                Ingredient(name: "Pink Food Colouring", quantity: "½ tsp"),
                Ingredient(name: "Apricot", quantity: "200g"),
                Ingredient(name: "Marzipan", quantity: "1kg"),
                Ingredient(name: "Icing Sugar", quantity: "Dusting")
            ],
            youtubeLink: URL(string: "https://www.youtube.com/watch?v=aB41Q7kDZQ0"),
            sourceLink: URL(string: "https://www.bbcgoodfood.com/recipes/1120657/battenberg-cake")
        )
        let got = try JSONDecoder().decode(DessertDetailResult.self, from: Self.dessertDetailDuplicateIngredientsJSON)
        
        XCTAssertNotNil(got.meals.first)
        XCTAssertEqual(expected, got.meals.first!, "Parsed object does not match expected object.")
    }
    
    func testDessertDetailParsingNullOrEmptyIngredients() throws {
        let expected = DessertDetail(
            name: "Chocolate Gateau",
            thumbnail: URL(string: "https://www.themealdb.com/images/media/meals/tqtywx1468317395.jpg"),
            area: "French",
            tags: ["Cake", "Chocolate", "Desert", "Pudding"],
            instructions: "Preheat the oven to 180°C/350°F/Gas Mark 4.",
            ingredients: [
                Ingredient(name: "Plain chocolate", quantity: "250g"),
                Ingredient(name: "Butter", quantity: "175g"),
                Ingredient(name: "Milk", quantity: "2 tablespoons"),
                Ingredient(name: "Eggs", quantity: "5"),
                Ingredient(name: "Granulated Sugar", quantity: "175g"),
                Ingredient(name: "Flour", quantity: "125g"),
            ],
            youtubeLink: URL(string: "https://www.youtube.com/watch?v=dsJtgmAhFF4"),
            sourceLink: URL(string: "http://www.goodtoknow.co.uk/recipes/536028/chocolate-gateau")
        )
        let got = try JSONDecoder().decode(DessertDetailResult.self, from: Self.dessertDetailNullOrEmptyIngredientsJSON)
        
        XCTAssertNotNil(got.meals.first)
        XCTAssertEqual(expected, got.meals.first!, "Parsed object does not match expected object.")
    }
    
    static let dessertDetailDuplicateIngredientsJSON = """
    {
        "meals": [
            {
              "idMeal": "52894",
              "strMeal": "Battenberg Cake",
              "strDrinkAlternate": null,
              "strCategory": "Dessert",
              "strArea": "British",
              "strInstructions": "Heat oven to 180C/160C fan/gas 4",
              "strMealThumb": "https://www.themealdb.com/images/media/meals/ywwrsp1511720277.jpg",
              "strTags": "Cake,Sweet",
              "strYoutube": "https://www.youtube.com/watch?v=aB41Q7kDZQ0",
              "strIngredient1": "Butter",
              "strIngredient2": "Caster Sugar",
              "strIngredient3": "Self-raising Flour",
              "strIngredient4": "Almonds",
              "strIngredient5": "Baking Powder",
              "strIngredient6": "Eggs",
              "strIngredient7": "Vanilla Extract",
              "strIngredient8": "Almond Extract",
              "strIngredient9": "Butter",
              "strIngredient10": "Caster Sugar",
              "strIngredient11": "Self-raising Flour",
              "strIngredient12": "Almonds",
              "strIngredient13": "Baking Powder",
              "strIngredient14": "Eggs",
              "strIngredient15": "Vanilla Extract",
              "strIngredient16": "Almond Extract",
              "strIngredient17": "Pink Food Colouring",
              "strIngredient18": "Apricot",
              "strIngredient19": "Marzipan",
              "strIngredient20": "Icing Sugar",
              "strMeasure1": "175g",
              "strMeasure2": "175g",
              "strMeasure3": "140g",
              "strMeasure4": "50g",
              "strMeasure5": "½ tsp",
              "strMeasure6": "3 Medium",
              "strMeasure7": "½ tsp",
              "strMeasure8": "¼ teaspoon",
              "strMeasure9": "175g",
              "strMeasure10": "175g",
              "strMeasure11": "140g",
              "strMeasure12": "50g",
              "strMeasure13": "½ tsp",
              "strMeasure14": "3 Medium",
              "strMeasure15": "½ tsp",
              "strMeasure16": "¼ teaspoon",
              "strMeasure17": "½ tsp",
              "strMeasure18": "200g",
              "strMeasure19": "1kg",
              "strMeasure20": "Dusting",
              "strSource": "https://www.bbcgoodfood.com/recipes/1120657/battenberg-cake",
              "strImageSource": null,
              "strCreativeCommonsConfirmed": null,
              "dateModified": null
            }
        ]
    }
    """.data(using: .utf8)!
    
    static let dessertDetailNullOrEmptyIngredientsJSON = """
    {
        "meals": [
            {
              "idMeal": "52776",
              "strMeal": "Chocolate Gateau",
              "strDrinkAlternate": null,
              "strCategory": "Dessert",
              "strArea": "French",
              "strInstructions": "Preheat the oven to 180°C/350°F/Gas Mark 4.",
              "strMealThumb": "https://www.themealdb.com/images/media/meals/tqtywx1468317395.jpg",
              "strTags": "Cake,Chocolate,Desert,Pudding",
              "strYoutube": "https://www.youtube.com/watch?v=dsJtgmAhFF4",
              "strIngredient1": "Plain chocolate",
              "strIngredient2": "Butter",
              "strIngredient3": "Milk",
              "strIngredient4": "Eggs",
              "strIngredient5": "Granulated Sugar",
              "strIngredient6": "Flour",
              "strIngredient7": "",
              "strIngredient8": "",
              "strIngredient9": "",
              "strIngredient10": "",
              "strIngredient11": "",
              "strIngredient12": "",
              "strIngredient13": "",
              "strIngredient14": "",
              "strIngredient15": "",
              "strIngredient16": null,
              "strIngredient17": null,
              "strIngredient18": null,
              "strIngredient19": null,
              "strIngredient20": null,
              "strMeasure1": "250g",
              "strMeasure2": "175g",
              "strMeasure3": "2 tablespoons",
              "strMeasure4": "5",
              "strMeasure5": "175g",
              "strMeasure6": "125g",
              "strMeasure7": "",
              "strMeasure8": "",
              "strMeasure9": "",
              "strMeasure10": "",
              "strMeasure11": "",
              "strMeasure12": " ",
              "strMeasure13": " ",
              "strMeasure14": " ",
              "strMeasure15": " ",
              "strMeasure16": null,
              "strMeasure17": null,
              "strMeasure18": null,
              "strMeasure19": null,
              "strMeasure20": null,
              "strSource": "http://www.goodtoknow.co.uk/recipes/536028/chocolate-gateau",
              "strImageSource": null,
              "strCreativeCommonsConfirmed": null,
              "dateModified": null
            }
        ]
    }
    """.data(using: .utf8)!
}
