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

class MockWebSocketService: WebSocketServiceProtocol {
  private let messageSubject = PassthroughSubject<Data, Never>()
  private let connectionStateSubject = CurrentValueSubject<WebSocketConnectionState, Never>(.disconnected)
  
  var messagePublisher: AnyPublisher<Data, Never> {
    messageSubject.eraseToAnyPublisher()
  }
  
  var connectionStatePublisher: AnyPublisher<WebSocketConnectionState, Never> {
    connectionStateSubject.eraseToAnyPublisher()
  }
  
  func connect() {
    connectionStateSubject.send(.connected)
  }
  
  func disconnect() {
    connectionStateSubject.send(.disconnected)
  }
  
  func send(_ message: String) {
    
  }
  
  func simulateConnection() {
    connectionStateSubject.send(.connected)
  }
  
  func simulateMessage(_ data: Data) {
    messageSubject.send(data)
  }
  
  func simulateError(_ error: Error) {
    connectionStateSubject.send(.error(error))
  }
}
