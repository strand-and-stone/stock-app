//
//  StockManagerTests.swift
//  
//
//  Created by John Meeker on 3/3/22.
//

import XCTest

@testable import cash_data_package

class MockedManager: StockManagerProtocol {

  var mockedStocks: [Stock] = []

  static func getPortfolio(completion: @escaping StockCompletion) {

  }

}

final class StockManagerTests: XCTestCase {

  private let defaultExpectationHandler: XCWaitCompletionHandler = { (error) in
    if error != nil {
      XCTFail("Expectations Timeout")
    }
  }

  func testMockedGetPortfolio() {

    MockedManager.getPortfolio { stocks, error in
      if let stocks = stocks {
        print(stocks)
      }
    }

  }

  func testGetPortfolio() {

    let getPortfolioExpectation = expectation(description: "Waiting for getPortfolio response")

    StockManager.getPortfolio { stocks, error in
      guard stocks != nil, error == nil else {
        XCTFail(error?.localizedDescription ?? "Error fetching portfolio")
        return
      }

      getPortfolioExpectation.fulfill()
    }

    waitForExpectations(timeout: 5, handler: defaultExpectationHandler)

  }

  static var allTests = [
    ("testMockedGetPortfolio", testMockedGetPortfolio),
  ]

}
