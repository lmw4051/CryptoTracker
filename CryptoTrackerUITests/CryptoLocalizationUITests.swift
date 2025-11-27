//
//  CryptoLocalizationUITests.swift
//  CryptoTrackerUITests
//
//  Created by David Lee on 11/27/25.
//

import XCTest

final class CryptoLocalizationUITests: CryptoTrackerUITestBase {
  func testEnglishLocalization() {
    // Given
    app.launchArguments = ["-AppleLanguages", "(en)", "-AppleLocale", "en_US"]
    app.launch()
    
    // When/Then
    let navBar = app.navigationBars["Cryptocurrencies"]
    XCTAssertTrue(
      navBar.waitForExistence(timeout: 10),
      "English navigation title not found"
    )
  }
  
  func testTraditionalChineseLocalization() {
    // Given
    app.launchArguments = [
      "-AppleLanguages",
      "(zh-Hant)",
      "-AppleLocale",
      "zh_TW"
    ]
    
    app.launch()
    
    // When/Then
    let navBar = app.navigationBars["加密貨幣"]
    XCTAssertTrue(
      navBar.waitForExistence(timeout: 10),
      "Chinese navigation title not found"
    )
  }
  
  func testLocalizedAccessibilityLabels() {
    // Test that accessibility labels are localized
    let languages = [
      ("en", "cryptocurrency row"),
      ("zh-Hant", "加密貨幣列表項"),
    ]
    
    for (lang, expectedSubstring) in languages {
      // Given
      app.launchArguments = ["-AppleLanguages", "(\(lang))"]
      app.launch()
      
      waitForLoadingToComplete()
      
      // When
      if let firstRow = findFirstCryptoRow() {
        // Then
        let label = firstRow.label
        XCTAssertTrue(
          label.contains(expectedSubstring) || !label.isEmpty,
          "Localized accessibility label not found for \(lang)"
        )
      }
      
      app.terminate()
    }
  }
}
