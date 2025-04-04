//
//  TUserUseCase.swift
//  iOSTechnicalTask
//
//  Created by Ambuj Singh on 31/03/25.
//

import Combine
import Foundation

protocol TUserUseCaseProtocol {
    /// Fetches user profile data
    func getUserProfileData() -> AnyPublisher<TUserModel?, Error>
}

final class TUserUseCase: TUserUseCaseProtocol {
    private var cancellable = Set<AnyCancellable>()
    private let userRepository: TUserRepositoryProtocol

    /// Initializes the use case with a user repository
    /// - Parameter userRepository: The repository responsible for fetching user data
    init(userRepository: TUserRepositoryProtocol = TUserRepository()) {
        self.userRepository = userRepository
    }
}

extension TUserUseCase {
    func getUserProfileData() -> AnyPublisher<TUserModel?, Error> {
        let publisher = PassthroughSubject<TUserModel?, Error>()
        // Fetch user data from the repository
        userRepository.fetchUserData()
            .receive(on: DispatchQueue.main)
            .sink { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    publisher.send(completion: .failure(error))
                }
            } receiveValue: { userData in
                publisher.send(userData)
            }.store(in: &cancellable)
        return publisher.eraseToAnyPublisher()
    }
}

