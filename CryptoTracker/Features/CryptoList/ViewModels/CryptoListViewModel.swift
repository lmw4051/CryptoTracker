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
  private let webSocketService: WebSocketServiceProtocol
  private var cancellables = Set<AnyCancellable>()
  
  init(
    networkService: NetworkServiceProtocol = NetworkService(),
    webSockegtService: WebSocketServiceProtocol? = nil
  ) {
    self.networkService = networkService
    
    if let wsService = webSockegtService {
      self.webSocketService = wsService
    } else {
      let wsURL = URL(string: "wss://ws.coincap.io/prices?assets=bitcoin,ethereum,dogecoin")!
      self.webSocketService = WebSocketService(url: wsURL)
    }
    
    setupWebSocketObserver()
  }
  
  private func setupWebSocketObserver() {
    webSocketService.connectionStatePublisher
      .sink { [weak self] state in
        self?.connectionState = state
      }
      .store(in: &cancellables)
    
    webSocketService.messagePublisher
      .decode(type: WebSocketMessage.self, decoder: JSONDecoder())
      .catch { _ -> Just<WebSocketMessage> in
        // Return empty message on decode error
        Just(WebSocketMessage(
          type: "error",
          data: Crypto(id: "", symbol: "", name: "", currentPrice: 0, priceChangePercentage24h: 0)
        ))
      }
      .sink { [weak self] message in
        self?.updateCrypto(message.data)
      }
      .store(in: &cancellables)
  }
  
  private func updateCrypto(_ crypto: Crypto) {
    if let index = cryptos.firstIndex(where: { $0.id == crypto.id }) {
      cryptos[index] = crypto
    }
  }
  
  func fetchCryptos() {
    isLoading = true
    errorMessage = nil
    
    let endpoint = Endpoint(path: "/coins/markets?vs_currency=usd&order=market_cap_desc&per_page=20")
    
    networkService.fetch(endpoint)
      .sink(receiveCompletion: { [weak self] completion in
        self?.isLoading = false
        
        if case .failure(let error) = completion {
          self?.errorMessage = error.localizedDescription
        }
      }, receiveValue: { [weak self] (cryptos: [Crypto]) in
        self?.cryptos = cryptos
      })
      .store(in: &cancellables)
  }
}
