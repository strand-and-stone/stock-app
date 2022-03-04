//
//  StockFetcher.swift
//  
//
//  Created by John Meeker on 3/2/22.
//

import Foundation

protocol StockFetcherProtocol {
  static var baseUrl: String { get }
}

public typealias NetworkCompletionHandler = (Result<Any, Error>?) -> Void

public class StockFetcher: StockFetcherProtocol {

  static var baseUrl: String {
    return "https://storage.googleapis.com"
  }

  public class func getPortfolio(completion: @escaping NetworkCompletionHandler) {

    let session = URLSession.shared

    let request: URLRequest!

    do {
      request = try StockRouter.getPortfolio.asURLRequest()
    } catch (let error) {
      print(error)
      return
    }

    let completionHandler: (Data?, URLResponse?, Error?) -> Void = { (data, response, error) in

      if let error = error {
        completion(.failure(error))
        return
      }

      if let data = data {
        completion(.success(data))
      }

    }

    let task = session.dataTask(with: request, completionHandler: completionHandler)
    task.resume()
  }

}
