//
//  DessertItemTests.swift
//  DessertsTests
//
//  Created by Sameer Mungole on 3/18/24.
//

import Desserts
import XCTest

final class DessertItemTests: XCTestCase {

    // Test verifies that the dessert item json get parsed successfully.
    func testDessertItemParsingSuccess() throws {
        let expected = DessertItem(
            id: "53049",
            name: "Apam balik",
            thumbnail: URL(string: "https://www.themealdb.com/images/media/meals/adxcbq1619787919.jpg")
        )
        let got = try JSONDecoder().decode(DessertItem.self, from: Self.dessertItemJSON)
        
        XCTAssertEqual(expected, got, "Parsed object does not match expected object.")
    }
    
    // Test verifies that if the json has empty/whitespaces/newlines for thumbnail, the attribute is set to nil
    func testDessertItemParsingEmptyURL() throws {
        let expected = DessertItem(
            id: "53049",
            name: "Apam balik",
            thumbnail: nil
        )
        let got = try JSONDecoder().decode(DessertItem.self, from: Self.dessertItemJSONEmptyURL)
        
        XCTAssertEqual(expected, got, "Parsed object does not match expected object.")
    }
    
    // Test verifies that if the json has null for thumbnail, the attribute is set to nil
    func testDessertItemParsingNullURL() throws {
        let expected = DessertItem(
            id: "53049",
            name: "Apam balik",
            thumbnail: nil
        )
        let got = try JSONDecoder().decode(DessertItem.self, from: Self.dessertItemJSONNullURL)
        
        XCTAssertEqual(expected, got, "Parsed object does not match expected object.")
    }
    
    // Test verifies that if the json has empty/whitespaces/newlines for name, the attribute is set to empty string
    func testDessertItemParsingEmptyName() throws {
        let expected = DessertItem(
            id: "53049",
            name: "",
            thumbnail: URL(string: "https://www.themealdb.com/images/media/meals/adxcbq1619787919.jpg")
        )
        let got = try JSONDecoder().decode(DessertItem.self, from: Self.dessertItemJSONEmptyName)
        
        XCTAssertEqual(expected, got, "Parsed object does not match expected object.")
    }
    
    // Test verifies that if the json has empty/whitespaces/newlines for name, the attribute is set to empty string
    func testDessertItemParsingNullName() throws {
        let expected = DessertItem(
            id: "53049",
            name: "",
            thumbnail: URL(string: "https://www.themealdb.com/images/media/meals/adxcbq1619787919.jpg")
        )
        let got = try JSONDecoder().decode(DessertItem.self, from: Self.dessertItemJSONNullName)
        
        XCTAssertEqual(expected, got, "Parsed object does not match expected object.")
    }
    
    // Test verifies that if the json has empty/whitespaces/newlines for id, the attribute is set to empty string
    func testDessertItemParsingEmptyID() throws {
        let expected = DessertItem(
            id: "",
            name: "Apam balik",
            thumbnail: URL(string: "https://www.themealdb.com/images/media/meals/adxcbq1619787919.jpg")
        )
        let got = try JSONDecoder().decode(DessertItem.self, from: Self.dessertItemJSONEmptyID)
        
        XCTAssertEqual(expected, got, "Parsed object does not match expected object.")
    }
    
    // Test verifies that if the json has null for id, the attribute is set to empty string
    func testDessertItemParsingNullID() throws {
        let expected = DessertItem(
            id: "",
            name: "Apam balik",
            thumbnail: URL(string: "https://www.themealdb.com/images/media/meals/adxcbq1619787919.jpg")
        )
        let got = try JSONDecoder().decode(DessertItem.self, from: Self.dessertItemJSONNullID)
        
        XCTAssertEqual(expected, got, "Parsed object does not match expected object.")
    }
    
    // Test verifies that if the json returns a different type than String for id, an error is thrown
    func testDessertItemParsingNonStringID() throws {
        do {
            let _ = try JSONDecoder().decode(DessertItem.self, from: Self.dessertItemJSONNonStringID)
            XCTFail("Expected to throw a type mismatch error.")
        } catch {
            // passing condition
            return
        }
    }
    
    // Test verifies that a json with the list of dessert items (including empty/null) get parsed successfully
    func testDessertItemResultParsingSuccess() throws {
        let expected = DessertItemResult(meals: [
            .init(
                id: "53049",
                name: "Apam balik",
                thumbnail: URL(string: "https://www.themealdb.com/images/media/meals/adxcbq1619787919.jpg")
            ),
            // Empty URL
            .init(
                id: "53049",
                name: "Apam balik",
                thumbnail: nil
            ),
            // Null URL
            .init(
                id: "53049",
                name: "Apam balik",
                thumbnail: nil
            ),
            // Empty Name
            .init(
                id: "53049",
                name: "",
                thumbnail: URL(string: "https://www.themealdb.com/images/media/meals/adxcbq1619787919.jpg")
            ),
            // Null Name
            .init(
                id: "53049",
                name: "",
                thumbnail: URL(string: "https://www.themealdb.com/images/media/meals/adxcbq1619787919.jpg")
            ),
            // Empty ID
            .init(
                id: "",
                name: "Apam balik",
                thumbnail: URL(string: "https://www.themealdb.com/images/media/meals/adxcbq1619787919.jpg")
            ),
            // Null ID
            .init(
                id: "",
                name: "Apam balik",
                thumbnail: URL(string: "https://www.themealdb.com/images/media/meals/adxcbq1619787919.jpg")
            )
        ])
        let got = try JSONDecoder().decode(DessertItemResult.self, from: Self.dessertItemResultJSON)
        
        XCTAssertEqual(expected.meals.count, got.meals.count)
        XCTAssertEqual(expected, got, "Parsed object does not match expected object.")
    }
    
    // Test verifies that a json with empty list of dessert items gets parsed successfully
    func testDessertItemResultParsingEmpty() throws {
        let got = try JSONDecoder().decode(DessertItemResult.self, from: Self.dessertItemResultEmptyJSON)
        XCTAssertEqual(got.meals.count, 0, "Parsed object count does not match expected object count.")
    }
    
    // Test verifies that a json where null value is received for list of dessert items gets parsed successfully
    func testDessertItemResultParsingNull() throws {
        let got = try JSONDecoder().decode(DessertItemResult.self, from: Self.dessertItemResultNullJSON)
        XCTAssertEqual(got.meals.count, 0, "Parsed object count does not match expected object count.")
    }
    
    static let dessertItemJSON = """
    {
      "strMeal": "Apam balik",
      "strMealThumb": "https://www.themealdb.com/images/media/meals/adxcbq1619787919.jpg",
      "idMeal": "53049"
    }
    """.data(using: .utf8)!
    
    static let dessertItemJSONEmptyURL = """
    {
      "strMeal": "Apam balik",
      "strMealThumb": " ",
      "idMeal": "53049"
    }
    """.data(using: .utf8)!
    
    static let dessertItemJSONNullURL = """
    {
      "strMeal": "Apam balik",
      "strMealThumb": null,
      "idMeal": "53049"
    }
    """.data(using: .utf8)!
    
    static let dessertItemJSONEmptyName = """
    {
      "strMeal": " ",
      "strMealThumb": "https://www.themealdb.com/images/media/meals/adxcbq1619787919.jpg",
      "idMeal": "53049"
    }
    """.data(using: .utf8)!
    
    static let dessertItemJSONNullName = """
    {
      "strMeal": null,
      "strMealThumb": "https://www.themealdb.com/images/media/meals/adxcbq1619787919.jpg",
      "idMeal": "53049"
    }
    """.data(using: .utf8)!
    
    static let dessertItemJSONEmptyID = """
    {
      "strMeal": "Apam balik",
      "strMealThumb": "https://www.themealdb.com/images/media/meals/adxcbq1619787919.jpg",
      "idMeal": " "
    }
    """.data(using: .utf8)!
    
    static let dessertItemJSONNullID = """
    {
      "strMeal": "Apam balik",
      "strMealThumb": "https://www.themealdb.com/images/media/meals/adxcbq1619787919.jpg",
      "idMeal": null
    }
    """.data(using: .utf8)!
    
    static let dessertItemJSONNonStringID = """
    {
      "strMeal": "Apam balik",
      "strMealThumb": "https://www.themealdb.com/images/media/meals/adxcbq1619787919.jpg",
      "idMeal": 53049
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
          "strMeal": "Apam balik",
          "strMealThumb": " ",
          "idMeal": "53049"
        },
        {
          "strMeal": "Apam balik",
          "strMealThumb": null,
          "idMeal": "53049"
        },
        {
          "strMeal": " ",
          "strMealThumb": "https://www.themealdb.com/images/media/meals/adxcbq1619787919.jpg",
          "idMeal": "53049"
        },
        {
          "strMeal": null,
          "strMealThumb": "https://www.themealdb.com/images/media/meals/adxcbq1619787919.jpg",
          "idMeal": "53049"
        },
        {
          "strMeal": "Apam balik",
          "strMealThumb": "https://www.themealdb.com/images/media/meals/adxcbq1619787919.jpg",
          "idMeal": " "
        },
        {
          "strMeal": "Apam balik",
          "strMealThumb": "https://www.themealdb.com/images/media/meals/adxcbq1619787919.jpg",
          "idMeal": null
        },
      ]
    }
    """.data(using: .utf8)!
    
    static let dessertItemResultEmptyJSON = """
    {
      "meals": []
    }
    """.data(using: .utf8)!
    
    static let dessertItemResultNullJSON = """
    {
      "meals": null
    }
    """.data(using: .utf8)!

}
