//
//  DessertItemTests.swift
//  DessertsTests
//
//  Created by Sameer Mungole on 3/18/24.
//

import Desserts
import XCTest

final class DessertItemTests: XCTestCase {

    func testDessertItemParsingSuccess() throws {
        let expected = DessertItem(
            id: "53049",
            name: "Apam balik",
            thumbnail: URL(string: "https://www.themealdb.com/images/media/meals/adxcbq1619787919.jpg")
        )
        let got = try JSONDecoder().decode(DessertItem.self, from: Self.dessertItemJSON)
        
        XCTAssertEqual(expected, got, "Expected: \(expected) != Got: \(got)")
    }
    
    func testDessertItemParsingInvalidURL() throws {
        let expected = DessertItem(
            id: "53049",
            name: "Apam balik",
            thumbnail: nil
        )
        let got = try JSONDecoder().decode(DessertItem.self, from: Self.dessertItemJSONInvalidURL)
        
        XCTAssertEqual(expected, got, "Expected: \(expected) != Got: \(got)")
    }
    
    func testDessertItemResultParsingSuccess() throws {
        let expected = DessertItemResult(meals: [
            DessertItem(
                id: "53049",
                name: "Apam balik",
                thumbnail: URL(string: "https://www.themealdb.com/images/media/meals/adxcbq1619787919.jpg")
            ),
            DessertItem(
                id: "52893",
                name: "Apple & Blackberry Crumble",
                thumbnail: URL(string: "https://www.themealdb.com/images/media/meals/xvsurr1511719182.jpg")
            ),
            DessertItem(
                id: "52768",
                name: "Apple Frangipan Tart",
                thumbnail: URL(string: "https://www.themealdb.com/images/media/meals/wxywrq1468235067.jpg")
            )
        ])
        let got = try JSONDecoder().decode(DessertItemResult.self, from: Self.dessertItemResultJSON)
        
        XCTAssertEqual(expected, got, "Expected: \(expected) != Got: \(got)")
    }
    
    func testDessertItemResultParsingEmpty() throws {
        let got = try JSONDecoder().decode(DessertItemResult.self, from: Self.dessertItemResultEmptyJSON)
        XCTAssertEqual(got.meals.count, 0, "Expected count: 0 != Got count: \(got.meals.count)")
    }
    
    static let dessertItemJSON = """
    {
      "strMeal": "Apam balik",
      "strMealThumb": "https://www.themealdb.com/images/media/meals/adxcbq1619787919.jpg",
      "idMeal": "53049"
    }
    """.data(using: .utf8)!
    
    static let dessertItemJSONInvalidURL = """
    {
      "strMeal": "Apam balik",
      "strMealThumb": "",
      "idMeal": "53049"
    }
    """.data(using: .utf8)!
    
    static let dessertItemResultJSON = """
    {
      "meals": [
        {
          "strMeal": "Apam balik",
          "strMealThumb": "https://www.themealdb.com/images/media/meals/adxcbq1619787919.jpg",
          "idMeal": "53049"
        },
        {
          "strMeal": "Apple & Blackberry Crumble",
          "strMealThumb": "https://www.themealdb.com/images/media/meals/xvsurr1511719182.jpg",
          "idMeal": "52893"
        },
        {
          "strMeal": "Apple Frangipan Tart",
          "strMealThumb": "https://www.themealdb.com/images/media/meals/wxywrq1468235067.jpg",
          "idMeal": "52768"
        }
      ]
    }
    """.data(using: .utf8)!
    
    static let dessertItemResultEmptyJSON = """
    {
      "meals": []
    }
    """.data(using: .utf8)!

}
