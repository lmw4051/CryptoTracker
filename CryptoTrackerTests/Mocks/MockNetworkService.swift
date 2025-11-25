//
//  MockNetworkService.swift
//  CryptoTrackerTests
//
//  Created by David Lee on 11/25/25.
//

import Foundation
import Combine
import NetworkingKit

class MockNetworkService: NetworkServiceProtocol {
  var mockResult: Result<Any, NetworkError> = .failure(.invalidURL)
  
  func fetch<T: Decodable>(_ endpoint: Endpoint) -> AnyPublisher<T, NetworkError> {
    switch mockResult {
      case .success(let data):
        if let typedData = data as? T {
          return Just(typedData)
            .setFailureType(to: NetworkError.self)
            .delay(for: 0.1, scheduler: DispatchQueue.main)
            .eraseToAnyPublisher()
        }
        return Fail(error: .invalidResponse)
          .eraseToAnyPublisher()
      case .failure(let error):
          return Fail(error: error)
            .delay(for: 0.1, scheduler: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
  }
}
