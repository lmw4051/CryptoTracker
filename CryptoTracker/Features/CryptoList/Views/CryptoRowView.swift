//
//  CryptoRowView.swift
//  CryptoTracker
//
//  Created by David Lee on 11/25/25.
//

import SwiftUI
import Models

struct CryptoRowView: View {
  let crypto: Crypto
  
  var body: some View {
    HStack {
      VStack(alignment: .leading, spacing: 4) {
        Text(crypto.name)
          .font(.headline)
          .accessibilityLabel("Name: \(crypto.name)")
        
        Text(crypto.symbol.uppercased())
          .font(.caption)
          .foregroundColor(.secondary)
          .accessibilityLabel("Symbol: \(crypto.symbol)")
      }
      
      Spacer()
      
      VStack(alignment: .trailing, spacing: 4) {
        Text("$\(crypto.currentPrice, specifier: "%.2f")")
          .font(.headline)
          .accessibilityLabel("Price: $\(crypto.currentPrice, specifier: "%.2f")")
        
        HStack(spacing: 4) {
          Image(systemName: crypto.priceChangePercentage24h >= 0 ? "arrow.up" : "arrow.down")
            .font(.caption)
          Text("\(abs(crypto.priceChangePercentage24h), specifier: "%.2f")%")
            .font(.caption)
        }
        .foregroundColor(crypto.priceChangePercentage24h >= 0 ? .green : .red)
        .accessibilityElement(children: .combine)
        .accessibilityLabel("24 hour change: \(crypto.priceChangePercentage24h >= 0 ? "up" : "down") \(abs(crypto.priceChangePercentage24h), specifier: "%.2f") percent")
      }
    }
    .padding(.vertical, 8)
    .accessibilityElement(children: .combine)
  }
}
