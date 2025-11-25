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
}
