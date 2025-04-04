//
//  TUserViewModelTestCases.swift
//  iOSTechnicalTaskTests
//
//  Created by Ambuj Singh on 04/04/25.
//

import XCTest
import Combine
@testable import iOSTechnicalTask

final class TUserViewModelTestCases: XCTestCase {
    private var viewModel: TUserProfileViewModel!
    private var mockUseCase: MockTUserUseCase!
    private var cancellables: Set<AnyCancellable>!

    override func setUp() {
        super.setUp()
        mockUseCase = MockTUserUseCase()
        viewModel = TUserProfileViewModel(userUseCase: mockUseCase)
        cancellables = []
    }

    override func tearDown() {
        viewModel = nil
        mockUseCase = nil
        cancellables = nil
        super.tearDown()
    }
    
    func testGetUserProfileDetails_Success() {
        // Arrange
        let expectedUserData = TUserModel(results: [
            TUserItem(
                id: 1,
                name: "Rick Sanchez",
                status: "Alive",
                species: "Human",
                type: "",
                gender: "Male",
                origin: TOrigin(name: "Earth", url: "https://rickandmortyapi.com/api/location/1"),
                location: TLocation(name: "Earth", url: "https://rickandmortyapi.com/api/location/20"),
                image: "https://rickandmortyapi.com/api/character/avatar/1.jpeg",
                episode: ["https://rickandmortyapi.com/api/episode/1", "https://rickandmortyapi.com/api/episode/2"],
                url: "https://rickandmortyapi.com/api/character/1",
                created: "2017-11-04T18:48:46.250Z"
            ),
            TUserItem(
                id: 2,
                name: "Morty Smith",
                status: "Alive",
                species: "Human",
                type: "",
                gender: "Male",
                origin: TOrigin(name: "Earth", url: "https://rickandmortyapi.com/api/location/1"),
                location: TLocation(name: "Earth", url: "https://rickandmortyapi.com/api/location/20"),
                image: "https://rickandmortyapi.com/api/character/avatar/2.jpeg",
                episode: ["https://rickandmortyapi.com/api/episode/1", "https://rickandmortyapi.com/api/episode/2"],
                url: "https://rickandmortyapi.com/api/character/2",
                created: "2017-11-04T18:50:21.651Z"
            )
        ])

        // Act
        mockUseCase.userProfileData = Just(expectedUserData)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()

        let expectation = XCTestExpectation(description: "Fetch user profile data successfully")

        viewModel.$userProfileData
            .dropFirst() // Ignore the initial value
            .sink { userProfileData in
                // Assert
                XCTAssertEqual(userProfileData?.results?.count, 2)
                XCTAssertEqual(userProfileData?.results?.first?.name, "Rick Sanchez")
                XCTAssertEqual(userProfileData?.results?.first?.status, "Alive")
                expectation.fulfill()
            }
            .store(in: &cancellables)

        viewModel.getUserProfileDetails()

        // Wait for expectations
        wait(for: [expectation], timeout: 1.0)
    }

    func testGetUserProfileDetails_Failure() {
        // Arrange
        let expectedError = URLError(.badServerResponse)
        mockUseCase.userProfileData = Fail(error: expectedError)
            .eraseToAnyPublisher()

        let expectation = XCTestExpectation(description: "Handle error when fetching user profile data")

        // Act
        viewModel.getUserProfileDetails()

        mockUseCase.userProfileData
            .sink(receiveCompletion: { completion in
                // Assert
                if case .failure(let error) = completion {
                    XCTAssertEqual((error as? URLError)?.code, .badServerResponse)
                    expectation.fulfill()
                }
            }, receiveValue: { _ in
                XCTFail("Expected failure, but got success")
            })
            .store(in: &cancellables)

        // Wait for expectations
        wait(for: [expectation], timeout: 1.0)
    }
}

// MARK: - Mock Use Case

final class MockTUserUseCase: TUserUseCaseProtocol {
    var userProfileData: AnyPublisher<TUserModel?, Error>!

    func getUserProfileData() -> AnyPublisher<TUserModel?, Error> {
        return userProfileData
    }
}
