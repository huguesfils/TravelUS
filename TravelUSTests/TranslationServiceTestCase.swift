//
//  TranslationServiceTestCase.swift
//  TravelUSTests
//
//  Created by Hugues Fils on 27/02/2024.
//

import XCTest

@testable import TravelUS

class FakeTranslationResponseData {
    // MARK: - Data
    static var translationCorrectData: Data? {
        let bundle = Bundle(for: FakeTranslationResponseData.self)
        let url = bundle.url(forResource: "Translation", withExtension: "json")!
        return try! Data(contentsOf: url)
    }

    static let translationIncorrectData = "wrong".data(using: .utf8)!

    // MARK: - Response
    static let responseOK = HTTPURLResponse(url: URL(string: "https://random.com")!,
        statusCode: 200, httpVersion: nil, headerFields: [:])!

    static let responseKO = HTTPURLResponse(url: URL(string: "https://random.com")!,
        statusCode: 500, httpVersion: nil, headerFields: [:])!

    // MARK: - Error
    class TranslationError: Error {}
    static let error = TranslationError()
}

// MARK: - Tests
class ClassTranslationTests: XCTestCase {
    func testGetTranslationShouldPostFailedCallback() {
        // Given
        let translationService = TranslationService( translationSession: URLSessionFake(data: nil, response: nil,
        error: FakeTranslationResponseData.error))

        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        translationService.getTranslation(text: "", from: "", to: "") { (translation, error) in
            // Then
            XCTAssertNotNil(error)
            XCTAssertNil(translation)
            XCTAssert(error is FakeTranslationResponseData.TranslationError)
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 1)
    }

    func testGetTranslationShouldPostFailedCallbackIfNoResponse() {
        // Given
        let translationService = TranslationService(
            translationSession: URLSessionFake(data: FakeTranslationResponseData.translationCorrectData, response: nil, error: nil))

        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        translationService.getTranslation(text: "", from: "", to: "") { (translation, error) in
            // Then
            XCTAssertFalse(error is FakeTranslationResponseData)
            XCTAssertNil(translation)
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 1)
    }

    func testGetTranslationShouldPostFailedCallbackIfNoData() {
        // Given
        let translationService = TranslationService(
            translationSession: URLSessionFake(data: nil, response: FakeTranslationResponseData.responseOK, error: nil))

        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        translationService.getTranslation(text: "", from: "", to: "") { (translation, error) in
            // Then
            XCTAssertNotNil(error)
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 1)
    }
    
    func testGetTranslationShouldPostFailedCallbackIfIncorrectResponse() {
        // Given
        let translationService = TranslationService(
            translationSession: URLSessionFake(
                data: FakeTranslationResponseData.translationCorrectData,
                response: FakeTranslationResponseData.responseKO,
                error: nil))

        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        translationService.getTranslation(text: "", from: "", to: "") { (translation, error) in
            // Then
            XCTAssertFalse((translation != nil))
            XCTAssertFalse(error is FakeTranslationResponseData.TranslationError)
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 1)
    }

    func testGetTranslationShouldPostFailedCallbackIfIncorrectData() {
        // Given
        let translationService = TranslationService(
            translationSession: URLSessionFake(
                data: FakeTranslationResponseData.translationIncorrectData,
                response: FakeTranslationResponseData.responseOK,
                error: nil))

        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        translationService.getTranslation(text: "", from: "", to: "") { (translation, error) in
            // Then
            XCTAssertFalse(translation != nil)
            XCTAssertNotNil(error)
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 1)
    }

    func testGetTranslationShouldPostSuccessCallbackIfNoErrorAndCorrectData() {
        // Given
        let translationService = TranslationService(
            translationSession: URLSessionFake(
                data: FakeTranslationResponseData.translationCorrectData,
                response: FakeTranslationResponseData.responseOK,
                error: nil))

        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        translationService.getTranslation(text: "", from: "", to: "") { (translation, error) in
            // Then
            let translatedText = translation?.data?.translations.first?.translatedText
            XCTAssertFalse((error != nil))
            XCTAssertNotNil(translation)
            XCTAssertNotNil(translatedText)
            XCTAssertEqual(translatedText, "Hello")
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1)
    }
}
