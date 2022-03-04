//
//  ViewController.swift
//  stocks-app
//
//  Created by John Meeker on 3/2/22.
//

import UIKit

import cash_data_package

class ViewController: UIViewController {

  @IBOutlet weak var tableView: UITableView!

  private var stocks: [Stock] = []
  private var oldestStockPrice: Int?

  private lazy var refreshControl: UIRefreshControl = {
    let refreshControl = UIRefreshControl()
    refreshControl.addTarget(self, action: #selector(refreshPortfolioData(_:)), for: .valueChanged)
    return refreshControl
  }()

  private lazy var loadingIndicator: UIActivityIndicatorView = {
    let indicator = UIActivityIndicatorView(style: .large)
    indicator.frame = CGRect(origin: .zero, size: CGSize(width: 40, height: 40))
    indicator.translatesAutoresizingMaskIntoConstraints = false
    return indicator
  }()

  private lazy var errorView: ErrorView = {
    let view = ErrorView(frame: view.bounds)
    view.delegate = self
    view.configureDefaultMessage()
    return view
  }()

  override func viewDidLoad() {
    super.viewDidLoad()

    tableView.backgroundView = loadingIndicator
    tableView.refreshControl = refreshControl
    fetchPortfolio()
  }

}

// MARK: - TableView Delegate and DataSource

extension ViewController: UITableViewDelegate, UITableViewDataSource {
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return self.stocks.count
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: "stockCell") as? StockCell else {
      return UITableViewCell()
    }

    cell.setup(with: stocks[indexPath.row])

    return cell
  }

  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    let view = StockHeader(frame: CGRect(origin: .zero, size: CGSize(width: UIScreen.main.bounds.size.width, height: StockHeader.height)))
    return view
  }

  func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
    let view = StockFooter(frame: CGRect(origin: .zero, size: CGSize(width: UIScreen.main.bounds.size.width, height: StockFooter.height)))

    view.setTimeStamp(with: oldestStockPrice)

    return view
  }

  func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    return StockHeader.height
  }

  func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
    return StockFooter.height
  }

}

// MARK: - Private Functions

extension ViewController {

  // Fetches Portfolio data. Shows loading indicator and handles empty and error responses.
  private func fetchPortfolio() {
    beginLoading()
    StockManager.getPortfolio(completion: { [weak self] (stocks, error) in
      self?.endLoading()
      self?.endRefreshing()

      // Handle error state
      guard let stocks = stocks, error == nil else {
        self?.showErrorView(with: .badResponse)
        self?.reloadTable(with: [])
        return
      }

      // Handle empty response state
      if stocks.isEmpty {
        self?.showErrorView(with: .emptyContent)
        self?.reloadTable(with: [])
        return
      }

      self?.oldestStockPrice = StockManager.getOldestPricedStock(stocks)?.current_price_timestamp
      self?.reloadTable(with: stocks)
    })
  }

  @objc private func refreshPortfolioData(_ sender: Any) {
    beginRefreshing()
    fetchPortfolio()
  }

  private func beginLoading() {
    self.view.addSubview(loadingIndicator)
    NSLayoutConstraint.activate([
      loadingIndicator.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
      loadingIndicator.centerYAnchor.constraint(equalTo: self.view.centerYAnchor)
    ])
    loadingIndicator.startAnimating()
  }

  private func endLoading() {
    DispatchQueue.main.async {
      self.loadingIndicator.stopAnimating()
      self.loadingIndicator.removeFromSuperview()
    }
  }

  private func beginRefreshing() {
    DispatchQueue.main.async {
      self.refreshControl.beginRefreshing()
    }
  }

  private func endRefreshing() {
    DispatchQueue.main.async {
      self.refreshControl.endRefreshing()
    }
  }

  // Handles both error states; empty bad and malformed response.
  private func showErrorView(with errorType: ErrorType) {

    DispatchQueue.main.async {
      self.tableView.isHidden = true
      self.view.addSubview(self.errorView)

      switch errorType {
      case .emptyContent:
        self.errorView.configureEmptyResponseState()
      case .badResponse:
        self.errorView.configureDefaultMessage()
      }

      NSLayoutConstraint.activate([
        self.errorView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
        self.errorView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
        self.errorView.topAnchor.constraint(equalTo: self.view.topAnchor),
        self.errorView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
      ])
    }

  }

  private func hideErrorView() {
    errorView.removeFromSuperview()
    tableView.isHidden = false
  }

  private func reloadTable(with stocks: [Stock]) {
    self.stocks = stocks

    DispatchQueue.main.async {
      self.tableView.reloadData()
    }
  }

}

// MARK: - ErrorViewDelegate

extension ViewController: ErrorViewDelegate {

  func attemptRetry() {
    hideErrorView()
    fetchPortfolio()
  }

}
