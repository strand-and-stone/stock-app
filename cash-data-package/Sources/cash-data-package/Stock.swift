//
//  Stock.swift
//
//
//  Created by John Meeker on 3/2/22.
//

import Foundation

public class Stock: Codable {

  public let ticker: String
  public let name: String
  public let currency: String
  public let current_price_cents: Int
  public let quantity: Int?
  public let current_price_timestamp: Int

  private static var currencyFormatter: NumberFormatter {
    let formatter = NumberFormatter()
    formatter.numberStyle = .decimal
    formatter.minimumFractionDigits = 2
    formatter.maximumFractionDigits = 2
    return formatter
  }

}

class Response: Codable {

  var stocks: [Stock]?

}

extension Stock {

  // Formats stock current price into dollars and cents
  public func formattedPrice() -> String {
    let formatter = Stock.currencyFormatter
    let priceString = formatter.string(from: NSNumber(value: Double(current_price_cents) / 100))!
    guard let currencySymbol = getSymbolForCurrencyCode() else { return priceString }
    return "\(currencySymbol)\(priceString)"
  }

  // Returns proper symbol based on stock currency
  private func getSymbolForCurrencyCode() -> String? {
    let locale = NSLocale(localeIdentifier: currency)
    guard let currencySymbol = locale.displayName(forKey: NSLocale.Key.currencySymbol, value: currency) else {
      return Locale.current.currencySymbol
    }
    return currencySymbol
  }

}



