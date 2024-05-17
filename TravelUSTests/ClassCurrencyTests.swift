//
//  ClassCurrencyTests.swift
//  TravelUSTests
//
//  Created by Hugues Fils on 27/02/2024.
//

import XCTest

@testable import TravelUS

class FakeCurrencyResponseData {
  //    // MARK: - Data
  static var currencyCorrectData: Data? {
    let bundle = Bundle(for: FakeCurrencyResponseData.self)
    let url = bundle.url(forResource: "Currency", withExtension: "json")!
    return try! Data(contentsOf: url)
  }

  static let currencyIncorrectData = "wrong".data(using: .utf8)!

  // MARK: - Response
  static let responseOK = HTTPURLResponse(
    url: URL(string: "https://random.com")!,
    statusCode: 200, httpVersion: nil, headerFields: [:])!

  static let responseKO = HTTPURLResponse(
    url: URL(string: "https://random.com")!,
    statusCode: 500, httpVersion: nil, headerFields: [:])!

  // MARK: - Error
  class CurrencyError: Error {}
  static let error = CurrencyError()
}

// MARK: - Tests
class ClassCurrencyTests: XCTestCase {
  func testGetCurrencyShouldPostFailedCallback() {
    // Given
    let currencyService = CurrencyService(
      currencySession: URLSessionFake(
        data: nil, response: nil, error: FakeCurrencyResponseData.error))

    // When
    let expectation = XCTestExpectation(description: "Wait for queue change.")
    currencyService.getCurrency { (currency, error) in
      // Then
      XCTAssertNotNil(error)
      XCTAssertNil(currency)
      XCTAssert(error is FakeCurrencyResponseData.CurrencyError)
      expectation.fulfill()
    }
    wait(for: [expectation], timeout: 1)
  }

  func testGetCurrencyShouldPostFailedCallbackIfNoResponse() {
    // Given
    let currencyService = CurrencyService(
      currencySession: URLSessionFake(
        data: FakeCurrencyResponseData.currencyCorrectData, response: nil, error: nil))

    // When
    let expectation = XCTestExpectation(description: "Wait for queue change.")
    currencyService.getCurrency { (currency, error) in
      // Then
      XCTAssertFalse(error is FakeCurrencyResponseData)
      XCTAssertNil(currency)
      expectation.fulfill()
    }

    wait(for: [expectation], timeout: 1)
  }

  func testGetCurrencyShouldPostFailedCallbackIfNoData() {
    // Given
    let currencyService = CurrencyService(
      currencySession: URLSessionFake(
        data: nil, response: FakeCurrencyResponseData.responseOK, error: nil))

    // When
    let expectation = XCTestExpectation(description: "Wait for queue change.")
    currencyService.getCurrency { (currency, error) in
      // Then
      XCTAssertNil(currency)
      expectation.fulfill()
    }

    wait(for: [expectation], timeout: 1)
  }

  func testGetCurrencyShouldPostFailedCallbackIfIncorrectResponse() {
    // Given
    let currencyService = CurrencyService(
      currencySession: URLSessionFake(
        data: FakeCurrencyResponseData.currencyCorrectData,
        response: FakeCurrencyResponseData.responseKO,
        error: nil))

    // When
    let expectation = XCTestExpectation(description: "Wait for queue change.")
    currencyService.getCurrency { (currency, error) in
      // Then
      XCTAssertFalse((currency != nil))
      XCTAssertFalse(error is FakeCurrencyResponseData.CurrencyError)
      expectation.fulfill()
    }

    wait(for: [expectation], timeout: 1)
  }

  func testGetCurrencyShouldPostFailedCallbackIfIncorrectData() {
    // Given
    let currencyService = CurrencyService(
      currencySession: URLSessionFake(
        data: FakeCurrencyResponseData.currencyIncorrectData,
        response: FakeCurrencyResponseData.responseOK,
        error: nil))

    // When
    let expectation = XCTestExpectation(description: "Wait for queue change.")
    currencyService.getCurrency { (currency, error) in
      // Then
      XCTAssertFalse(currency != nil)
      XCTAssertNotNil(error)
      expectation.fulfill()
    }

    wait(for: [expectation], timeout: 1)
  }

  func testGetCurrencyShouldPostSuccessCallbackIfNoErrorAndCorrectData() {
    // Given
    let currencyService = CurrencyService(
      currencySession: URLSessionFake(
        data: FakeCurrencyResponseData.currencyCorrectData,
        response: FakeCurrencyResponseData.responseOK,
        error: nil))

    // When
    let expectation = XCTestExpectation(description: "Wait for queue change.")
    currencyService.getCurrency { (currency, error) in
      // Then
      let usdRate = currency?.rates["USD"]
      XCTAssertFalse((error != nil))
      XCTAssertNotNil(currency)
      XCTAssertNotNil(usdRate)
      XCTAssertEqual(usdRate, 1.081625)
      expectation.fulfill()
    }
    wait(for: [expectation], timeout: 1)
  }
}
