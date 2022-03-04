//
//  ErrorView.swift
//  stocks-app
//
//  Created by John Meeker on 3/3/22.
//

import UIKit

// MARK: - ErrorType

enum ErrorType: Error {
  case emptyContent
  case badResponse
}

// MARK: - ErrorViewDelegate

protocol ErrorViewDelegate: AnyObject {
  func attemptRetry()
}

// MARK: - ErrorView

class ErrorView: UIView {

  override init(frame: CGRect) {
    super.init(frame: frame)
    setupViews()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  weak var delegate: ErrorViewDelegate?

  func configureEmptyResponseState() {
    label.text = "Hmm. Empty Data Received."
  }

  func configureDefaultMessage() {
    label.text = "Hmm. Error Loading Portfolio."
  }

  private lazy var label: UILabel = {
    let label = UILabel()
    label.font = UIFont.systemFont(ofSize: 14)
    label.textColor = .gray
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()

  private lazy var retryButton: UIButton = {
    let button = UIButton()
    button.addTarget(self, action: #selector(retryButtonPressed), for: .touchUpInside)
    button.setTitle("Refresh", for: .normal)
    button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
    button.setTitleColor(.systemBlue, for: .normal)
    button.translatesAutoresizingMaskIntoConstraints = false
    return button
  }()

}

// MARK: - Private Functions

extension ErrorView {

  private func setupViews() {
    addSubview(retryButton)
    addSubview(label)

    NSLayoutConstraint.activate([
      NSLayoutConstraint(item: label, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0),
      label.centerXAnchor.constraint(equalTo: centerXAnchor),
      retryButton.centerXAnchor.constraint(equalTo: centerXAnchor),
      retryButton.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 24),
    ])
  }

  @objc private func retryButtonPressed(_: Any) {
    delegate?.attemptRetry()
  }

}
