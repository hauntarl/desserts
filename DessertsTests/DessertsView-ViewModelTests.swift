//
//  DessertsView-ViewModelTests.swift
//  DessertsTests
//
//  Created by Sameer Mungole on 3/18/24.
//

import Desserts
import XCTest

final class DessertsView_ViewModelTests: XCTestCase {
    private var networkingMock: NetworkingMock!
    private var networkManager: NetworkManager!
    private var dessertsViewModel: DessertsView.ViewModel!

    override func setUp() {
        super.setUp()
        
        networkingMock = .init()
        networkManager = .init(using: networkingMock)
        dessertsViewModel = .init(networkManager: networkManager)
    }
    
    // Test verifies whether the getDesserts() method successfully fetches, parses, and filters the dessert items.
    // Dessert items that don't have either id, name, or thumbnail are removed from the final list of desserts.
    func testGetDessertsSuccess() async throws {
        let expected: [DessertItem] = [
            .init(
                id: "53049",
                name: "Apam balik",
                thumbnail: URL(string: "https://www.themealdb.com/images/media/meals/adxcbq1619787919.jpg")
            )
        ]
        
        networkingMock.result = .success(DessertItemTests.dessertItemResultJSON)
        let viewState = await dessertsViewModel.getDesserts()
        
        switch viewState {
        case .success:
            let got = dessertsViewModel.desserts
            XCTAssertEqual(expected, got, "Parsed object does not match expected object.")
        default:
            XCTFail("Expected success view state")
        }
    }
    
    // Test verifies that the view model returns empty response error if there the desserts list is empty.
    func testGetDessertsEmptyResponse() async throws {
        networkingMock.result = .success(DessertItemTests.dessertItemResultEmptyJSON)
        let viewState = await dessertsViewModel.getDesserts()
        
        switch viewState {
        case .failure:
            // passing condition
            return
        default:
            XCTFail("Expected failure view state")
        }
    }
    
    // Test verifies that the view model returns response error if the server responds with error.
    func testGetDessertsResponseError() async throws {
        networkingMock.result = .failure(NetworkError.responseError)
        let viewState = await dessertsViewModel.getDesserts()
        
        switch viewState {
        case .failure:
            // passing condition
            return
        default:
            XCTFail("Expected failure view state")
        }
    }
    
    // Test verifies that the view model returns parsing error if the json parser responds with error.
    func testGetDessertsParsingError() async throws {
        networkingMock.result = .success(Data())
        let viewState = await dessertsViewModel.getDesserts()
        
        switch viewState {
        case .failure:
            // passing condition
            return
        default:
            XCTFail("Expected failure view state")
        }
    }
    
    func testFilterDessertsSuccess() async {
        let expected: [DessertItem] = [
            .init(
                id: "53049",
                name: "Apam balik",
                thumbnail: URL(string: "https://www.themealdb.com/images/media/meals/adxcbq1619787919.jpg")
            )
        ]
        
        networkingMock.result = .success(DessertItemTests.dessertItemResultJSON)
        let viewState = await dessertsViewModel.getDesserts()
        
        switch viewState {
        case .success:
            dessertsViewModel.searchText = "Apam"
            dessertsViewModel.filterDesserts()
            let got = dessertsViewModel.desserts
            XCTAssertEqual(expected, got, "Parsed object does not match expected object.")
        default:
            XCTFail("Expected success view state")
        }
    }
    
    func testFilterDessertsEmpty() async {
        networkingMock.result = .success(DessertItemTests.dessertItemResultJSON)
        let viewState = await dessertsViewModel.getDesserts()
        
        switch viewState {
        case .success:
            dessertsViewModel.searchText = "Not a dessert"
            dessertsViewModel.filterDesserts()
            let got = dessertsViewModel.desserts
            XCTAssert(got.isEmpty, "Expected filtered desserts list to be empty.")
        default:
            XCTFail("Expected success view state")
        }
    }

}
