//
//  CryptoDetailView.swift
//  CryptoTracker
//
//  Created by David Lee on 11/25/25.
//

import SwiftUI
import Models
import LocalizationKit

struct CryptoDetailView: View {
  let crypto: Crypto
  
  var body: some View {
    ScrollView {
      VStack(spacing: 24) {
        // Header
        VStack(spacing: 8) {
          Text(crypto.name)
            .font(.largeTitle)
            .bold()
          
          Text(crypto.symbol.uppercased())
            .font(.title2)
            .foregroundColor(.secondary)
        }
        .padding(.top)
        
        // Price Card
        VStack(spacing: 16) {
          CryptoDetailRow(
            title: L10n.CryptoDetail.price,
            value: String(format: "$%.2f", crypto.currentPrice),
            accessibilityLabel: String(format: "Current price: $%.2f", crypto.currentPrice)
          )
          .accessibilityIdentifier(AccessibilityID.CryptoDetail.priceLabel)
          
          CryptoDetailRow(
            title: L10n.CryptoDetail.change24h,
            value: String(format: "%.2f%%", crypto.priceChangePercentage24h),
            valueColor: crypto.priceChangePercentage24h >= 0 ? .green : .red,
            accessibilityLabel: String(format: "24 hour change: %@ %.2f percent", crypto.priceChangePercentage24h >= 0 ? "up" : "down", abs(crypto.priceChangePercentage24h))
          )
          .accessibilityIdentifier(AccessibilityID.CryptoDetail.changeLabel)
          
          if let marketCap = crypto.marketCap {
            CryptoDetailRow(
              title: L10n.CryptoDetail.marketCap,
              value: formatMarketCap(marketCap),
              accessibilityLabel: "Market cap: \(formatMarketCap(marketCap))"
            )
            .accessibilityIdentifier(AccessibilityID.CryptoDetail.marketCapLabel)
          }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
        .padding(.horizontal)
      }
    }
    .navigationBarTitleDisplayMode(.inline)
    .accessibilityIdentifier(AccessibilityID.CryptoDetail.view)
  }
  
  private func formatMarketCap(_ value: Double) -> String {
    if value >= 1_000_000_000_000 {
      // 修改點: 除以兆 (Trillion)
      return String(format: "$%.2fT", value / 1_000_000_000_000)
    } else if value >= 1_000_000_000 {
      // 修改點: 除以十億 (Billion)
      return String(format: "$%.2fB", value / 1_000_000_000)
    } else if value >= 1_000_000 {
      // 修改點: 除以百萬 (Million)
      return String(format: "$%.2fM", value / 1_000_000)
    }
    // 修改點: 原值
    return String(format: "$%.2f", value)
  }
}
