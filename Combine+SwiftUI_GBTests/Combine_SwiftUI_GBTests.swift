//
//  Combine_SwiftUI_GBTests.swift
//  Combine+SwiftUI_GBTests
//
//  Created by Алексей on 04.06.2023.
//

import XCTest
import Combine
@testable import Combine_SwiftUI_GB


class GameSlotsTests: XCTestCase {
    var cancellables = Set<AnyCancellable>()
    var viewModel: GameSlotsVM!
    
    override func setUp() {
        super.setUp()
        
        viewModel = GameSlotsVM()
    }

    override func tearDown() {
        cancellables.removeAll()
        viewModel = nil
        
        super.tearDown()
    }

    func testButtonAndTitleTextsOnStart() {
        
        let expected = "Start"
        let expected2 = "Let's play!"
        let expectation = XCTestExpectation()
        var result = ""
        var result2 = ""
        
        viewModel
            .$buttonText
            .dropFirst()
            .sink { value in
                result = value
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        viewModel
            .$textTitle
            .dropFirst()
            .sink { value in
                result2 = value
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        // When
        viewModel.isGameStarted = false
        
        // Then
        wait(for: [expectation], timeout: 1)
        XCTAssertEqual(result, expected)
        XCTAssertEqual(result2, expected2)
    }
    
    func testButtonTextChanged() {
        // Given
        let expected = "Catch it!"
        let expectation = XCTestExpectation()
        var result = ""
        
        viewModel
            .$buttonText
            .dropFirst(2)
            .sink { value in
                result = value
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        // When
        viewModel.isGameStarted = true
        
        // Then
        wait(for: [expectation], timeout: 1)
        XCTAssertEqual(result, expected)
    }
    
    func testWin() {
        // Given
        let expected = "You won!"
        let expectation = XCTestExpectation()
        var result = ""
        
        viewModel
            .$textTitle
            .dropFirst()
            .sink { value in
                result = value
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        // When
        viewModel.firstSlot = "🦠"
        viewModel.secondSlot = "🦠"
        viewModel.thirdSlot = "🦠"
        
        viewModel.isGameStarted = false
        viewModel.justForRemember = true
        
        // Then
        wait(for: [expectation], timeout: 1)
        XCTAssertEqual(result, expected)
    }

    func testLoss() {
        // Given
        let expected = "You lose!"
        let expectation = XCTestExpectation()
        var result = ""
        
        viewModel
            .$textTitle
            .dropFirst()
            .sink { value in
                result = value
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        // When
        viewModel.firstSlot = "🥶"
        viewModel.secondSlot = "🤔"
        viewModel.thirdSlot = "😑"

        viewModel.isGameStarted = false
        viewModel.justForRemember = true
        
        // Then
        wait(for: [expectation], timeout: 1)
        XCTAssertEqual(result, expected)
    }
}
