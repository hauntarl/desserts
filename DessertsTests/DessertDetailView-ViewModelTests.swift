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

    // Test verifies whether the getDessertDetails() method successfully fetches, parses the dessert details.
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
        
        networkingMock.result = .success(DessertDetailTests.dessertDetailJSON)
        let got = await dessertDetailViewModel.getDessertDetails(for: "52776")
        
        XCTAssertNotNil(got)
        XCTAssertEqual(expected, got!, "Parsed object does not match expected object.")
    }
    
    // Test verifies whether the getDessertDetails() marks object that don't have either id, name, or thumbnail as
    // invalid.
    func testGetDessertDetailsEmptyOrNullFields() async throws {
        networkingMock.result = .success(DessertDetailTests.dessertDetailNullFieldsJSON)
        let got = await dessertDetailViewModel.getDessertDetails(for: "52776")
        
        XCTAssertNil(got)
    }

    // Test verifies that the view model throws response error if the server responds with error.
    func testGetDessertDetailsResponseError() async throws {
        networkingMock.result = .failure(NetworkError.responseError)
        let got = await dessertDetailViewModel.getDessertDetails(for: "52776")
        
        XCTAssertNil(got)
    }
    
    // Test verifies that the view model throws parsing error if the json parser responds with error.
    func testGetDessertDetailsParsingError() async throws {
        networkingMock.result = .success(Data())
        let got = await dessertDetailViewModel.getDessertDetails(for: "52776")
        
        XCTAssertNil(got)
    }
    
    // Test verifies that the updateSections() method successfully calculates available sections from dessert details.
    func testUpdateSectionsSuccess() async throws {
        let expected: [DessertDetailView.SectionId] = [.info, .items, .recipe, .links]
        
        networkingMock.result = .success(DessertDetailTests.dessertDetailJSON)
        guard let dessertDetails = await dessertDetailViewModel.getDessertDetails(for: "52776") else {
            XCTFail("Details should be parsed correctly.")
            return
        }
        let got = dessertDetailViewModel.updateSections(for: dessertDetails)
        
        XCTAssert(!got.isEmpty)
        XCTAssertEqual(expected, got, "Parsed object does not match expected object.")
    }
    
    // Test verifies that the updateSections() method successfully filters unavailable sections from dessert details.
    func testUpdateSectionsFieldsNotPresent() async throws {
        let expected: [DessertDetailView.SectionId] = [.info]
        
        networkingMock.result = .success(DessertItemTests.dessertItemResultJSON)
        guard let dessertDetails = await dessertDetailViewModel.getDessertDetails(for: "52776") else {
            XCTFail("Details should be parsed correctly.")
            return
        }
        let got = dessertDetailViewModel.updateSections(for: dessertDetails)
        
        XCTAssert(!got.isEmpty)
        XCTAssertEqual(expected, got, "Parsed object does not match expected object.")
    }
    
}
