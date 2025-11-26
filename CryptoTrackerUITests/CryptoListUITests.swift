//
//  CryptoListUITests.swift
//  CryptoTrackerUITests
//
//  Created by David Lee on 11/26/25.
//

import XCTest

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
}
