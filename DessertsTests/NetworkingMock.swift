//
//  NetworkingMock.swift
//  DessertsTests
//
//  Created by Sameer Mungole on 3/18/24.
//
//  Protocol based mocking: https://www.swiftbysundell.com/articles/dependency-injection-and-unit-testing-using-async-await/#:~:text=Protocol%2Dbased%20mocking

import Desserts
import Foundation

class NetworkingMock: Networking {
    var result = Result<Data, Error>.success(Data())
    
    func data(from url: URL, delegate: (any URLSessionTaskDelegate)?) async throws -> (Data, URLResponse) {
        try (result.get(), URLResponse())
    }
}
