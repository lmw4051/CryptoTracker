//
//  File.swift
//  NetworkingKit
//
//  Created by David Lee on 11/24/25.
//

import Foundation
import Combine

public enum WebSocketConnectionState: Equatable {
  case disconnected
  case connecting
  case connected
  case error(Error)
}

extension WebSocketConnectionState {
  public static func == (lhs: WebSocketConnectionState, rhs: WebSocketConnectionState) -> Bool {
    switch (lhs, rhs) {
    case (.disconnected, .disconnected),
         (.connecting, .connecting),
         (.connected, .connected):
      return true
    case (.error, .error):
      // Treat any error as equal for comparison in UI/tests
      return true
    default:
      return false
    }
  }
}

public protocol WebSocketServiceProtocol {
  var messagePublisher: AnyPublisher<Data, Never> { get }
  var connectionStatePublisher: AnyPublisher<WebSocketConnectionState, Never> { get }
  func connect()
  func disconnect()
  func send(_ message: String)
}

public class WebSocketService: NSObject, WebSocketServiceProtocol {
  private var webSocketTask: URLSessionWebSocketTask?
  private let messageSubject = PassthroughSubject<Data, Never>()
  private let connectionStateSubject = CurrentValueSubject<WebSocketConnectionState, Never>(.disconnected)
  
  public var messagePublisher: AnyPublisher<Data, Never> {
    messageSubject.eraseToAnyPublisher()
  }
  
  public var connectionStatePublisher: AnyPublisher<WebSocketConnectionState, Never> {
    connectionStateSubject.eraseToAnyPublisher()
  }
  
  private let url: URL
  
  public init(url: URL) {
    self.url = url
    super.init()
  }
  
  public func connect() {
    connectionStateSubject.send(.connecting)
    
    let session = URLSession(configuration: .default, delegate: self, delegateQueue: nil)
    webSocketTask = session.webSocketTask(with: url)
    webSocketTask?.resume()
    receiveMessage()
  }
  
  public func disconnect() {
    webSocketTask?.cancel(with: .goingAway, reason: nil)
    connectionStateSubject.send(.disconnected)
  }
  
  public func send(_ message: String) {
    let message = URLSessionWebSocketTask.Message.string(message)
    webSocketTask?.send(message) { error in
      if let error = error {
        print("WebSocket send error: \(error)")
      }
    }
  }
  
  private func receiveMessage() {
    webSocketTask?.receive { [weak self] result in
      switch result {
      case .success(let message):
        switch message {
        case .string(let text):
          if let data = text.data(using: .utf8) {
            self?.messageSubject.send(data)
          }
        case .data(let data):
          self?.messageSubject.send(data)
        @unknown default:
          break
        }
        self?.receiveMessage()
      case .failure(let error):
        self?.connectionStateSubject.send(.error(error))
      }
    }
  }
}

extension WebSocketService: URLSessionWebSocketDelegate {
  public func urlSession(
    _ session: URLSession,
    webSocketTask: URLSessionWebSocketTask,
    didOpenWithProtocol protocol: String?
  ) {
    connectionStateSubject.send(.connected)
  }
  
  public func urlSession(
    _ session: URLSession,
    webSocketTask: URLSessionWebSocketTask,
    didCloseWith closeCode: URLSessionWebSocketTask.CloseCode,
    reason: Data?
  ) {
    connectionStateSubject.send(.disconnected)
  }
}
