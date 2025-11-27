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
  
  private func findFirstCryptoRow() -> XCUIElement? {
    // Search using identifier prefix
    let rowsWithPrefix = app.buttons.matching(NSPredicate(format: "identifier BEGINSWITH 'cryptoRow_'"))
    
    if rowsWithPrefix.firstMatch.waitForExistence(timeout: 5) {
      return rowsWithPrefix.firstMatch
    }
    
    // Fetch all buttons and filter for a crypto row
    let allButtons = app.buttons.allElementsBoundByIndex
    
    for button in allButtons {
      if button.identifier.starts(with: "cryptoRow_") {
        return button
      }
    }
    
    // Return nil if still not found
    return nil
  }
  
  // MARK: - Tests
  func testCryptoListDisplayed() {
    // Given - App is launched
    
    // When
    let navBar = app.navigationBars.firstMatch
    XCTAssertTrue(navBar.waitForExistence(timeout: 10),
                  "❌ Navigation bar did not appear")
    
    waitForLoadingToComplete()
    
    // Then
    let firstRow = findFirstCryptoRow()
    XCTAssertNotNil(
      firstRow,
      "❌ No crypto rows found. Check if API is working and data is loaded."
    )
    
    XCTAssertTrue(
      firstRow?.exists ?? false,
      "❌ First crypto row does not exist"
    )
    
    XCTAssertTrue(
      firstRow?.isHittable ?? false,
      "❌ First crypto row is not hittable"
    )
  }
}
