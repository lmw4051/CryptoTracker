//
//  CryptoListUITests.swift
//  CryptoTrackerUITests
//
//  Created by David Lee on 11/26/25.
//

import XCTest

final class CryptoListUITests: CryptoTrackerUITestBase {
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
  
  func testRefreshButton() {
    // Given
    waitForLoadingToComplete()
    
    // When
    let refreshButton = app.buttons[AccessibilityID.CryptoList.refreshButton]
    XCTAssertTrue(
      refreshButton.waitForExistence(timeout: 5),
      "❌ Refresh button not found"
    )
    
    // Record that we have rows before refresh
    let hadRowsBefore = findFirstCryptoRow() != nil
    refreshButton.tap()
    
    // Then
    let loadingIndicator = app.activityIndicators[AccessibilityID.CryptoList.loadingIndicator]
    _ = loadingIndicator.waitForExistence(timeout: 1)
    
    // Wait for refresh to complete
    waitForLoadingToComplete()
    
    // Verify rows still exist after refresh
    if hadRowsBefore {
      let firstRow = findFirstCryptoRow()
      XCTAssertNotNil(firstRow, "❌ Rows disappeared after refresh")
    }
  }
  
  func testNavigationTitle() {
    // Given
    waitForLoadingToComplete()
    
    // When/Then - Verify navigation title
    let navBar = app.navigationBars["Cryptocurrencies"]
    XCTAssertTrue(
      navBar.waitForExistence(timeout: 5),
      "❌ Navigation title 'Cryptocurrencies' not found"
    )
  }
  
  func testCryptoRowHasContent() {
    // Given
    waitForLoadingToComplete()
    
    // When
    guard let firstRow = findFirstCryptoRow() else {
      XCTFail("❌ No crypto row found")
      return
    }
    
    // Then - Verify row has accessibility label
    let label = firstRow.label
    XCTAssertFalse(
      label.isEmpty,
      "❌ Crypto row has no accessibility label"
    )
    
    // Verify label contains expected text
    XCTAssertTrue(
      label.contains("cryptocurrency row") ||
      label.contains("加密貨幣列表項")
    )
  }
  
  func testScrollingInList() {
    // Given
    waitForLoadingToComplete()
    
    guard let firstRow = findFirstCryptoRow() else {
      XCTFail("❌ No crypto row found")
      return
    }
    
    let firstRowIDBeforeScroll = firstRow.identifier
    
    // When
    app.swipeUp()
    
    // Then
    guard let firstRowAfterScroll = findFirstCryptoRow() else {
      XCTFail("❌ No rows found after scroll")
      return
    }
    
    XCTAssertNotEqual(
      firstRowAfterScroll.identifier,
      firstRowIDBeforeScroll,
      "❌ List did not scroll: Top row is still the same"
    )
  }
  
  func testDetailViewContent() {
    // Given
    waitForLoadingToComplete()
    
    guard let firstRow = findFirstCryptoRow() else {
      XCTFail("No crypto row found")
      return
    }
    
    firstRow.tap()
    sleep(1)
    
    // Then
    let priceLabel = app.staticTexts.matching(
      identifier: AccessibilityID.CryptoDetail.priceLabel
    ).firstMatch
    
    XCTAssertTrue(
      priceLabel.waitForExistence(timeout: 5),
      "Price label not found"
    )
    
    let changeLabel = app.staticTexts.matching(
      identifier: AccessibilityID.CryptoDetail.changeLabel
    ).firstMatch
    
    XCTAssertTrue(
      changeLabel.waitForExistence(timeout: 2),
      "Change label not found"
    )
    
    XCTAssertGreaterThan(
      app.scrollViews.count,
      0,
      "No scroll views found"
    )
    
    let backButton = app.navigationBars.buttons.element(boundBy: 0)
    XCTAssertTrue(backButton.exists, "Back button not found")
  }
}
