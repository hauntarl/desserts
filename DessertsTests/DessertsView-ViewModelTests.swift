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
    
    func testGetDessertsSuccess() async throws {
        let expected: [DessertItem] = [
            .init(
                id: "53049",
                name: "Apam balik",
                thumbnail: URL(string: "https://www.themealdb.com/images/media/meals/adxcbq1619787919.jpg")
            ),
            .init(
                id: "52893",
                name: "Apple & Blackberry Crumble",
                thumbnail: URL(string: "https://www.themealdb.com/images/media/meals/xvsurr1511719182.jpg")
            ),
            .init(
                id: "52768",
                name: "Apple Frangipan Tart",
                thumbnail: URL(string: "https://www.themealdb.com/images/media/meals/wxywrq1468235067.jpg")
            )
        ]
        
        networkingMock.result = .success(DessertItemTests.dessertItemResultJSON)
        let got = await dessertsViewModel.getDesserts()
        
        XCTAssertEqual(expected, got, "Parsed object does not match expected object.")
    }
    
    func testGetDessertsInvalidURL() async throws {
        networkingMock.result = .failure(NetworkError.invalidURL)
        let got = await dessertsViewModel.getDesserts()
        
        XCTAssert(got.isEmpty)
    }

    func testGetDessertsResponseError() async throws {
        networkingMock.result = .failure(NetworkError.responseError)
        let got = await dessertsViewModel.getDesserts()
        
        XCTAssert(got.isEmpty)
    }
    
    func testGetDessertsParsingError() async throws {
        networkingMock.result = .success(Data())
        let got = await dessertsViewModel.getDesserts()
        
        XCTAssert(got.isEmpty)
    }

}
