//
//  DessertDetailView-ViewModelTests.swift
//  DessertsTests
//
//  Created by Sameer Mungole on 3/18/24.
//

import Desserts
import XCTest

final class DessertDetailView_ViewModelTests: XCTestCase {
    private var networkingMock: NetworkingMock!
    private var networkManager: NetworkManager!
    private var dessertDetailViewModel: DessertDetailView.ViewModel!

    override func setUp() {
        super.setUp()
        
        networkingMock = .init()
        networkManager = .init(using: networkingMock)
        dessertDetailViewModel = .init(networkManager: networkManager)
    }

    func testGetDessertDetailsSuccess() async throws {
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
        
        networkingMock.result = .success(DessertDetailTests.dessertDetailNullOrEmptyIngredientsJSON)
        let got = await dessertDetailViewModel.getDessertDetails(for: "52776")
        
        XCTAssertNotNil(got)
        XCTAssertEqual(expected, got!, "Parsed object does not match expected object.")
    }
    
    func testGetDessertDetailsInvalidURL() async throws {
        networkingMock.result = .failure(NetworkError.invalidURL)
        let got = await dessertDetailViewModel.getDessertDetails(for: "52776")
        
        XCTAssertNil(got)
    }

    func testGetDessertDetailsResponseError() async throws {
        networkingMock.result = .failure(NetworkError.responseError)
        let got = await dessertDetailViewModel.getDessertDetails(for: "52776")
        
        XCTAssertNil(got)
    }
    
    func testGetDessertDetailsParsingError() async throws {
        networkingMock.result = .success(Data())
        let got = await dessertDetailViewModel.getDessertDetails(for: "52776")
        
        XCTAssertNil(got)
    }
    
    func testUpdateSectionsSuccess() async throws {
        let expected: [DessertDetailView.SectionId] = [.info, .items, .recipe, .links]
        
        networkingMock.result = .success(DessertDetailTests.dessertDetailNullOrEmptyIngredientsJSON)
        guard let dessertDetails = await dessertDetailViewModel.getDessertDetails(for: "52776") else {
            XCTFail("Details should be parsed correctly.")
            return
        }
        let got = dessertDetailViewModel.updateSections(for: dessertDetails)
        
        XCTAssertFalse(got.isEmpty)
        XCTAssertEqual(expected, got, "Parsed object does not match expected object.")
    }
    
}
