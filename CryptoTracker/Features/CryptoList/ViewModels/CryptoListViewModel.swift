//
//  CryptoListViewModel.swift
//  CryptoTracker
//
//  Created by David Lee on 11/25/25.
//

import Foundation
import Combine
import NetworkingKit
import Models
import LocalizationKit

@MainActor
class CryptoListViewModel: ObservableObject {
  @Published var cryptos: [Crypto] = []
  @Published var isLoading = false
  @Published var errorMessage: String?
  @Published var connectionState: WebSocketConnectionState = .disconnected
  
  private let networkService: NetworkServiceProtocol
  private let webSockegtService: WebSocketServiceProtocol
  private var cancellables = Set<AnyCancellable>()
  
  init(
    networkService: NetworkServiceProtocol = NetworkService(),
    webSockegtService: WebSocketServiceProtocol? = nil
  ) {
    self.networkService = networkService
    
    if let wsService = webSockegtService {
      self.webSockegtService = wsService
    } else {
      let wsURL = URL(string: "wss://ws.coincap.io/prices?assets=bitcoin,ethereum,dogecoin")!
      self.webSockegtService = WebSocketService(url: wsURL)
    }
  }
}
