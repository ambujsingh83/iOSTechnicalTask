//
//  APIClientUtilityTestsCases.swift
//  iOSTechnicalTaskTests
//
//  Created by Ambuj Singh on 04/04/25.
//

import XCTest

import XCTest
import Combine
@testable import iOSTechnicalTask

final class APIClientUtilityTestsCases: XCTestCase {
    private var apiClient: APIClientUtility!
    private var cancellables: Set<AnyCancellable>!

    override func setUp() {
        super.setUp()
        apiClient = APIClientUtility()
        cancellables = []
    }

    override func tearDown() {
        apiClient = nil
        cancellables = nil
        super.tearDown()
    }

    func testGet_Success() {
        // Arrange
        let url = "https://rickandmortyapi.com/api/character/?page=19"
        let expectation = XCTestExpectation(description: "Fetch data successfully")

        // Act
        apiClient.get(url: url)
            .sink(receiveCompletion: { completion in
                if case .failure = completion {
                    XCTFail("Expected success but got failure")
                }
            }, receiveValue: { data in
                // Assert
                XCTAssertNotNil(data)
                expectation.fulfill()
            })
            .store(in: &cancellables)

        // Wait for expectations
        wait(for: [expectation], timeout: 5.0)
    }
    
    func testGet_Failure() {
        // Arrange
        let invalidURL = "https://rickandmortyapi.com/api/invalid-endpoint" // Invalid endpoint
        let expectation = XCTestExpectation(description: "Handle failure when fetching data")

        // Act
        apiClient.get(url: invalidURL)
            .sink(receiveCompletion: { completion in
                // Assert
                if case .failure(let error) = completion {
                    XCTAssertNotNil(error, "Expected an error but got nil")
                    expectation.fulfill()
                }
            }, receiveValue: { _ in
                XCTFail("Expected failure but got success")
            })
            .store(in: &cancellables)

        // Wait for expectations
        wait(for: [expectation], timeout: 5.0)
    }
}
