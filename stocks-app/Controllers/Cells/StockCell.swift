//
//  StockCell.swift
//  stocks-app
//
//  Created by John Meeker on 3/2/22.
//

import UIKit

import cash_data_package

class StockCell: UITableViewCell {

  @IBOutlet weak var tickerLabel: UILabel!
  @IBOutlet weak var nameLabel: UILabel!
  @IBOutlet weak var currentPriceLabel: UILabel!
  @IBOutlet weak var quantityLabel: UILabel!
  @IBOutlet weak var stackViewWidthLayoutConstraint: NSLayoutConstraint!

  func setup(with stock: Stock) {
    
    self.tickerLabel.text = stock.ticker
    self.nameLabel.text = stock.name
    self.currentPriceLabel.text = stock.formattedPrice()

    let isStockOwned = stock.quantity != nil
    self.quantityLabel.text = isStockOwned ? "\(stock.quantity!)" : ""
    stackViewWidthLayoutConstraint.constant = isStockOwned ? 110 : 30

  }

}
