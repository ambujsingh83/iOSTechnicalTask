//
//  APIClientUtility.swift
//  iOSTechnicalTask
//
//  Created by Ambuj Singh on 31/03/25.
//

import Foundation
import Combine

protocol APIClientUtilityProtocol {
    
    func get(url: String) -> AnyPublisher<Data, Error>
    
}

class APIClientUtility: APIClientUtilityProtocol {
    
    func get(url: String) -> AnyPublisher<Data, Error> {
        // Validate the provided URL
        guard let fullUrl = URL(string: url) else {
            return Fail(error: URLError(.badURL))
                .eraseToAnyPublisher()
        }
        
        // Perform the network request
        return URLSession.shared.dataTaskPublisher(for: fullUrl)
            .tryMap { output in
                // Validate HTTP response status code
                guard let httpResponse = output.response as? HTTPURLResponse,
                      (200...299).contains(httpResponse.statusCode) else {
                    throw URLError(.badServerResponse)
                }
                return output.data
            }
            .receive(on: DispatchQueue.main) // Ensure results are delivered on the main thread
            .eraseToAnyPublisher()
    }
}
