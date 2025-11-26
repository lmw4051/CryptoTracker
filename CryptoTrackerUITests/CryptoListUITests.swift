//
//  CryptoListUITests.swift
//  CryptoTrackerUITests
//
//  Created by David Lee on 11/26/25.
//

import XCTest
@testable import CryptoTracker

final class CryptoListUITests: XCTestCase {
  var app: XCUIApplication!
  
  override func setUp() {
    super.setUp()
    continueAfterFailure = false
    app = XCUIApplication()
    app.launch()
  }
  
  override func tearDown() {
    app = nil
    super.tearDown()
  }
  
  // MARK: - Helper Methods
  private func waitForLoadingToComplete(timeout: TimeInterval = 10) {
    let loadingIndicator = app.activityIndicators[AccessibilityID.CryptoList.loadingIndicator]
    
    if loadingIndicator.exists {
      let disappeared = NSPredicate(format: "exists == false")
      let expectation = XCTNSPredicateExpectation(predicate: disappeared, object: loadingIndicator)
      let result = XCTWaiter.wait(for: [expectation], timeout: timeout)
      
      if result != .completed {
        print("⚠️ Loading did not complete within \(timeout) seconds")
      }
    }
  }
}
