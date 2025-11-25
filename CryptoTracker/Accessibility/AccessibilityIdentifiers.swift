//
//  AccessibilityIdentifiers.swift
//  CryptoTracker
//
//  Created by David Lee on 11/25/25.
//

import Foundation

public enum AccessibilityID {
  // MARK: - Crypto List
  public enum CryptoList {
    public static let view = "cryptoListView"
    public static let table = "cryptoListTable"
    public static let refreshButton = "refreshButton"
    public static let loadingIndicator = "loadingIndicator"
    public static let errorMessage = "errorMessage"
    
    public static func row(_ id: String) -> String {
      "cryptoRow_\(id)"
    }
  }
  
  // MARK: - Crypto Detail
  public enum CryptoDetail {
    public static let view = "cryptoDetailView"
    public static let priceLabel = "priceLabel"
    public static let changeLabel = "changeLabel"
    public static let marketCapLabel = "marketCapLabel"
  }
}
