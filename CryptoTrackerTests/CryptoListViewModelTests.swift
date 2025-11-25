//
//  CryptoListViewModelTests.swift
//  CryptoTrackerTests
//
//  Created by David Lee on 11/25/25.
//

import XCTest
import Combine
@testable import CryptoTracker
@testable import NetworkingKit
@testable import Models

final class CryptoListViewModelTests: XCTestCase {
  var viewModel: CryptoListViewModel!
  var mockNetworkService: MockNetworkService!
  var mockWebSocketService: MockWebSocketService!
  var cancellables: Set<AnyCancellable>!
  
  @MainActor
  override func setUp() {
    super.setUp()
    mockNetworkService = MockNetworkService()
    mockWebSocketService = MockWebSocketService()
    viewModel = CryptoListViewModel(
      networkService: mockNetworkService,
      webSockegtService: mockWebSocketService
    )
    
    cancellables = []
  }
  
  override func tearDown() {
    viewModel = nil
    mockNetworkService = nil
    mockWebSocketService = nil
    cancellables = nil
    super.tearDown()
  }
  
  @MainActor
  func testFetchCryptosSuccess() async {
    // Given
    let expectedCryptos = [
      Crypto(id: "bitcoin", symbol: "btc", name: "Bitcoin",
             currentPrice: 50000, priceChangePercentage24h: 5.0),
      Crypto(id: "ethereum", symbol: "eth", name: "Ethereum",
             currentPrice: 3000, priceChangePercentage24h: -2.5)
    ]
    
    mockNetworkService.mockResult = .success(expectedCryptos)
    
    // When
    viewModel.fetchCryptos()
    
    // Wait for async operation
    try? await Task.sleep(nanoseconds: 200_000_000)
    
    // Then
    XCTAssertEqual(viewModel.cryptos.count, 2)
    XCTAssertEqual(viewModel.cryptos.first?.name, "Bitcoin")
    XCTAssertFalse(viewModel.isLoading)
    XCTAssertNil(viewModel.errorMessage)
  }
  
  @MainActor
  func testFetchCryptosFailure() async {
    // Given
    mockNetworkService.mockResult = .failure(.invalidURL)
    
    // When
    viewModel.fetchCryptos()
    
    // Wait for async operation
    try? await Task.sleep(nanoseconds: 200_000_000)
    
    // Then
    XCTAssertTrue(viewModel.cryptos.isEmpty)
    XCTAssertNotNil(viewModel.errorMessage)
    XCTAssertFalse(viewModel.isLoading)
  }
}
