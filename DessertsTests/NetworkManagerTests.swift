//
//  NetworkManagerTests.swift
//  DessertsTests
//
//  Created by Sameer Mungole on 3/18/24.
//

import Desserts
import XCTest

final class NetworkManagerTests: XCTestCase {
    private var networking: NetworkingMock!
    private var networkManager: NetworkManager!
    
    override func setUp() {
        super.setUp()
        
        networking = NetworkingMock()
        networkManager = NetworkManager(using: networking)
    }

    func testNetworkManagerDesertItemResultSuccess() async throws {
        networking.result = .success(DessertItemTests.dessertItemResultJSON)
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
        
        let urlString = "\(NetworkManager.baseURL)?c=Dessert"
        let got: DessertItemResult = try await networkManager.loadData(from: urlString)
        XCTAssertEqual(expected, got, "Parsed object does not match expected object.")
    }
    
    func testNetworkManagerDesertDetailResultSuccess() async throws {
        networking.result = .success(DessertDetailTests.dessertDetailNullOrEmptyIngredientsJSON)
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
        
        let urlString = "\(NetworkManager.baseURL)?i=52776"
        let got: DessertDetailResult = try await networkManager.loadData(from: urlString)
        
        XCTAssertNotNil(got.meals.first)
        XCTAssertEqual(expected, got.meals.first!, "Parsed object does not match expected object.")
    }
    
    func testNetworkManagerInvalidURL() async throws {
        do {
            let _: DessertItemResult = try await networkManager.loadData(from: "")
            XCTFail("Should not succeed")
        } catch NetworkError.invalidURL {
            // passing condition
            return
        } catch {
            XCTFail("Unexpected error")
        }
    }
    
    func testNetworkManagerResponseError() async throws {
        networking.result = .failure(NetworkError.responseError)
        do {
            let urlString = "\(NetworkManager.baseURL)?c=Dessert"
            let _: DessertItemResult = try await networkManager.loadData(from: urlString)
            XCTFail("Should not succeed")
        } catch NetworkError.responseError {
            // passing condition
            return
        } catch {
            XCTFail("Unexpected error")
        }
    }
    
    func testNetworkManagerParsingError() async throws {
        networking.result = .success(Data())
        do {
            let urlString = "\(NetworkManager.baseURL)?c=Dessert"
            let _: DessertItemResult = try await networkManager.loadData(from: urlString)
            XCTFail("Should not succeed")
        } catch {
            // passing condition
            return
        }
    }
}
