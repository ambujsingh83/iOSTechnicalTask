//
//  TUserRepositoryTestsCases.swift
//  iOSTechnicalTaskTests
//
//  Created by Ambuj Singh on 04/04/25.
//

import XCTest
import Combine
@testable import iOSTechnicalTask

final class TUserRepositoryTests: XCTestCase {
    private var repository: TUserRepository!
    private var mockAPIClient: MockAPIClientUtility!
    private var cancellables: Set<AnyCancellable>!

    override func setUp() {
        super.setUp()
        mockAPIClient = MockAPIClientUtility()
        repository = TUserRepository(apiClient: mockAPIClient)
        cancellables = []
    }

    override func tearDown() {
        repository = nil
        mockAPIClient = nil
        cancellables = nil
        super.tearDown()
    }

    func testFetchUserData_Success() {
        // Arrange
        let mockJSON = """
        {
            "results": [
                {
                    "id": 1,
                    "name": "Rick Sanchez",
                    "status": "Alive",
                    "image": "https://rickandmortyapi.com/api/character/avatar/1.jpeg",
                    "episode": []
                }
            ]
        }
        """.data(using: .utf8)!
        mockAPIClient.mockData = mockJSON

        let expectation = XCTestExpectation(description: "Fetch user data successfully")

        // Act
        repository.fetchUserData()
            .sink(receiveCompletion: { completion in
                if case .failure = completion {
                    XCTFail("Expected success but got failure")
                }
            }, receiveValue: { userModel in
                // Assert
                XCTAssertEqual(userModel.results?.count, 1)
                XCTAssertEqual(userModel.results?.first?.name, "Rick Sanchez")
                expectation.fulfill()
            })
            .store(in: &cancellables)

        // Wait for expectations
        wait(for: [expectation], timeout: 1.0)
    }

    func testFetchUserData_Failure() {
        // Arrange
        mockAPIClient.mockError = URLError(.badServerResponse)
        let expectation = XCTestExpectation(description: "Handle error when fetching user data")

        // Act
        repository.fetchUserData()
            .sink(receiveCompletion: { completion in
                // Assert
                if case .failure(let error) = completion {
                    XCTAssertEqual((error as? URLError)?.code, .badServerResponse)
                    expectation.fulfill()
                }
            }, receiveValue: { _ in
                XCTFail("Expected failure but got success")
            })
            .store(in: &cancellables)

        // Wait for expectations
        wait(for: [expectation], timeout: 1.0)
    }
}

// MARK: - Mock APIClientUtility

final class MockAPIClientUtility: APIClientUtilityProtocol {
    var mockData: Data?
    var mockError: Error?

    func get(url: String) -> AnyPublisher<Data, Error> {
        if let error = mockError {
            return Fail(error: error).eraseToAnyPublisher()
        }
        if let data = mockData {
            return Just(data)
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        }
        return Fail(error: URLError(.unknown)).eraseToAnyPublisher()
    }
}
