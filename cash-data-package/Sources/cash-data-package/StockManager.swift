//
//  StockManager.swift
//  
//
//  Created by John Meeker on 3/2/22.
//

import Foundation

import cash_network_package

public typealias StockCompletion = ([Stock]?, Error?) -> Void

protocol StockManagerProtocol {
  static func getPortfolio(completion: @escaping StockCompletion)
}

public class StockManager: StockManagerProtocol {

  public init() { }

  public static func getPortfolio(completion: @escaping StockCompletion) {

    StockFetcher.getPortfolio(completion: { (result) in
      switch result {
      case .success(let data):
        guard let data = data as? Data else { return }

        do {
          guard let stocks = try self.decode(with: data) else { return }
          completion(stocks, nil)
        } catch {
          completion(nil, error)
        }

      case .failure(let error):
        completion(nil, error)
      default:
        print("What happened?")
      }
    })
  }

  // Finds and returns stock with "oldest" timestamp
  public static func getOldestPricedStock(_ stocks: [Stock]) -> Stock? {
    return stocks.min(by: { a, b in
      a.current_price_timestamp < b.current_price_timestamp
    })
  }

}

// MARK: - Private Functions

extension StockManager {

  // Handle Network Response
  private static func decode(with data: Data) throws -> [Stock]? {
    do {
      let decodedResponse = try JSONDecoder().decode(Response.self, from: data)
      return decodedResponse.stocks
    } catch {
      print("Error during JSON serialization: \(error.localizedDescription)")
      throw error
    }
  }

}
