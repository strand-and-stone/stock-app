//
//  StockRouter.swift
//  
//
//  Created by John Meeker on 3/2/22.
//

import Foundation

enum StockRouter {

  case getPortfolio

  func asURLRequest() throws -> URLRequest {

    var baseURL = try StockFetcher.baseUrl.asURL()

    switch self {
    case .getPortfolio:
      baseURL.path = "/cash-homework/cash-stocks-api/portfolio.json"
    }

    guard let url = baseURL.url else { fatalError("The url has been incorrectly constructed.") }

    var urlRequest = URLRequest(url: url)
    urlRequest.httpMethod = "GET"
    urlRequest.setValue("application/json", forHTTPHeaderField: "Accept")
    urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
    urlRequest.timeoutInterval = 30

    return urlRequest
 
  }

}

extension String {

  func asURL() throws -> URLComponents {

    guard let url = URLComponents(string: self) else {
      fatalError("The URL could not be used.")
    }
    return url

  }

}
