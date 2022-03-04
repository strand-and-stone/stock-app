//
//  StockFooter.swift
//  stocks-app
//
//  Created by John Meeker on 3/2/22.
//

import UIKit

class StockFooter: UIView {

  static var height: CGFloat = 30

  private lazy var explainerLabel: UILabel = {
    let label = UILabel()
    label.font = UIFont.systemFont(ofSize: 10)
    label.textColor = .darkText
    label.text = "Stock prices current as of:"
    return label
  }()

  private lazy var timeStampLabel: UILabel = {
    let label = UILabel()
    label.font = UIFont.systemFont(ofSize: 10)
    label.textColor = .lightGray
    return label
  }()

  private lazy var horizontalStackView: UIStackView = {
    let stackView = UIStackView(arrangedSubviews: [explainerLabel, timeStampLabel])
    stackView.axis = .horizontal
    stackView.spacing = 4
    return stackView
  }()

  private lazy var verticalStackView: UIStackView = {
    let stackView = UIStackView(arrangedSubviews: [horizontalStackView])
    stackView.axis = .vertical
    stackView.alignment = .leading
    stackView.translatesAutoresizingMaskIntoConstraints = false
    return stackView
  }()

  override init(frame: CGRect) {
    super.init(frame: frame)
    backgroundColor = .white
    self.addSubview(verticalStackView)

    NSLayoutConstraint.activate([
      verticalStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
      verticalStackView.trailingAnchor.constraint(equalTo: trailingAnchor),
      verticalStackView.topAnchor.constraint(equalTo: topAnchor),
      verticalStackView.bottomAnchor.constraint(equalTo: bottomAnchor),
    ])
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  func setTimeStamp(with timeStamp: Int?) {
    guard let timeStamp = timeStamp else {
      timeStampLabel.text = "N/A"
      return
    }

    let date = Date(timeIntervalSince1970: Double(timeStamp))
    let dateFormatter = DateFormatter()
    dateFormatter.timeStyle = DateFormatter.Style.medium
    dateFormatter.dateStyle = DateFormatter.Style.medium
    dateFormatter.timeZone = .current
    let localDate = dateFormatter.string(from: date)
    timeStampLabel.text = localDate
  }

}
