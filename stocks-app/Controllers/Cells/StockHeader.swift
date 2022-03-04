//
//  StockHeader.swift
//  stocks-app
//
//  Created by John Meeker on 3/3/22.
//

import UIKit

class StockHeader: UIView {

  static var height: CGFloat = 44

  private lazy var stockLabel: UILabel = {
    let label = UILabel()
    label.adjustsFontForContentSizeCategory = true
    label.font = UIFont.systemFont(ofSize: 14)
    label.textColor = .darkGray
    label.text = "Stock"
    return label
  }()

  private lazy var quantityLabel: UILabel = {
    let label = UILabel()
    label.adjustsFontForContentSizeCategory = true
    label.font = UIFont.systemFont(ofSize: 14)
    label.textColor = .lightGray
    label.text = "Qty"
    return label
  }()

  private lazy var priceLabel: UILabel = {
    let label = UILabel()
    label.adjustsFontForContentSizeCategory = true
    label.font = UIFont.systemFont(ofSize: 14)
    label.textColor = .lightGray
    label.text = "Last Price"
    return label
  }()

  private lazy var horizontalStackView: UIStackView = {
    let stackView = UIStackView(arrangedSubviews: [stockLabel, quantityLabel, priceLabel])
    stackView.setCustomSpacing(24, after: quantityLabel)
    stackView.axis = .horizontal
    stackView.spacing = 4
    return stackView
  }()

  private lazy var verticalStackView: UIStackView = {
    let stackView = UIStackView(arrangedSubviews: [horizontalStackView])
    stackView.axis = .vertical
    stackView.translatesAutoresizingMaskIntoConstraints = false
    return stackView
  }()

  override init(frame: CGRect) {
    super.init(frame: frame)
    backgroundColor = .white
    self.addSubview(verticalStackView)

    NSLayoutConstraint.activate([
      verticalStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24),
      verticalStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -24),
      verticalStackView.topAnchor.constraint(equalTo: topAnchor),
      verticalStackView.bottomAnchor.constraint(equalTo: bottomAnchor),
    ])
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

}
