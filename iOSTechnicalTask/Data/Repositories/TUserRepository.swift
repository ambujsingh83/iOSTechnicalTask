//
//  TUserRepository.swift
//  iOSTechnicalTask
//
//  Created by Ambuj Singh on 31/03/25.
//

import Combine
import Foundation

protocol TUserRepositoryProtocol {
    
    func fetchUserData() -> AnyPublisher<TUserModel, Error>
}

final class TUserRepository: TUserRepositoryProtocol {
    
    private let apiClient: APIClientUtilityProtocol
    // for now only i've hardcoded this URL later will use Network Request Builder 
    private let userEndpoint = "https://rickandmortyapi.com/api/character/?page=19"

    init(apiClient: APIClientUtilityProtocol = APIClientUtility()) {
        self.apiClient = apiClient
    }
    
}

extension TUserRepository {
    
    func fetchUserData() -> AnyPublisher<TUserModel, Error> {
        return apiClient.get(url: userEndpoint)
            .decode(type: TUserModel.self, decoder: JSONDecoder())
            .mapError { error -> Error in
                if let urlError = error as? URLError {
                    return URLError(urlError.code) // We can customize this further
                } else if let decodingError = error as? DecodingError {
                    return decodingError // Handle decoding errors if needed
                }
                return error // Return the original error if not handled
            }
            .eraseToAnyPublisher()
    }
    
}
