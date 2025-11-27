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
}
