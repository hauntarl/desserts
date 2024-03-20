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
        let got = await dessertsViewModel.getDesserts()
        
        XCTAssertEqual(expected, got, "Parsed object does not match expected object.")
    }
    
    // Test verifies that the view model throws response error if the server responds with error.
    func testGetDessertsResponseError() async throws {
        networkingMock.result = .failure(NetworkError.responseError)
        let got = await dessertsViewModel.getDesserts()
        
        XCTAssert(got.isEmpty)
    }
    
    // Test verifies that the view model throws parsing error if the json parser responds with error.
    func testGetDessertsParsingError() async throws {
        networkingMock.result = .success(Data())
        let got = await dessertsViewModel.getDesserts()
        
        XCTAssert(got.isEmpty)
    }

}
