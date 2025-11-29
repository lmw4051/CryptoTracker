//
//  CryptoTrackerSnapshotTests.swift
//  CryptoTrackerSnapshotTests
//
//  Created by David Lee on 11/29/25.
//

import XCTest
import SwiftUI
import SnapshotTesting
@testable import CryptoTracker
@testable import Models

final class CryptoTrackerSnapshotTests: XCTestCase {
  override func setUp() {
    super.setUp()
  }
  
  func testCryptoRowViewLight() {
    let crypto = Crypto(
      id: "bitcoin",
      symbol: "btc",
      name: "Bitcoin",
      currentPrice: 50000.00,
      priceChangePercentage24h: 5.25
    )
    
    let view = CryptoRowView(crypto: crypto)
      .frame(width: 375, height: 80)
      .background(Color.white)
    
    assertSnapshot(of: view, as: .image(precision: 0.99))
  }
}
