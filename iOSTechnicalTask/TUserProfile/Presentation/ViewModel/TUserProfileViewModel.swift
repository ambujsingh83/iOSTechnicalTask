//
//  TUserProfileViewModel.swift
//  iOSTechnicalTask
//
//  Created by Ambuj Singh on 31/03/25.
//

import Foundation
import Combine

class TUserProfileViewModel: ObservableObject {
    private var cancellables = Set<AnyCancellable>()
    private let userUseCase: TUserUseCaseProtocol

    @Published var userProfileData: TUserModel?

    init(userUseCase: TUserUseCaseProtocol = TUserUseCase()) {
        self.userUseCase = userUseCase
    }

    func getUserProfileDetails() {
        userUseCase.getUserProfileData()
            .receive(on: DispatchQueue.main)
            .sink { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    debugPrint(error.localizedDescription)
                }
            } receiveValue: { userData in
                self.userProfileData = userData
            }
            .store(in: &cancellables)
    }
}
