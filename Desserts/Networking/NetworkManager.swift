//
//  NetworkManager.swift
//  Desserts
//
//  Created by Sameer Mungole on 3/18/24.
//

import Foundation

/**A generic network manager that loads data from a given api endpoint.*/
public struct NetworkManager {
    public static let shared = Self()
    public static let baseURL = "https://themealdb.com/api/json/v1/1/filter.php"

    private let networking: Networking
    
    /**
     A custom initializer required for unit testing while mocking the `URLSession` object.
     
     By using a default argument (in this case `.shared`) we can add dependency injection without
     making our app code more complicated.
     */
    public init(using networking: Networking = URLSession.shared) {
        self.networking = networking
    }
    
    /**A generic function that fetches data from the given endpoint and decodes it into the provided type.*/
    public func loadData<T: Decodable>(from urlString: String) async throws -> T {
        guard let url = URL(string: urlString) else {
            throw NetworkError.invalidURL
        }
        
        let (data, _) = try await networking.data(from: url)
        let decoded = try JSONDecoder().decode(T.self, from: data)
        return decoded
    }
}
