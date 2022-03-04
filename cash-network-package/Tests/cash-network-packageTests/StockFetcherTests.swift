//
//  StockFetcherTests.swift
//  
//
//  Created by John Meeker on 3/3/22.
//

import XCTest
@testable import cash_network_package

final class StockFetcherTests: XCTestCase {

  private let defaultExpectationHandler: XCWaitCompletionHandler = { (error) in
    if error != nil {
      XCTFail("Expectation Timeout")
    }
  }

  func testGetPortfolio() {

    let expectation = expectation(description: "Waiting for getPortfolio response")

    StockFetcher.getPortfolio { (result) in
      switch result {
      case .success(_):
        expectation.fulfill()
      case .failure(let error):
        XCTFail(error.localizedDescription)
      case .none:
        XCTFail("What happened?")
      }
    }

    waitForExpectations(timeout: 5, handler: defaultExpectationHandler)

  }

  static var allTests = [
    ("testGetPortfolio", testGetPortfolio),
  ]

}

