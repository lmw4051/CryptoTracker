//
//  CryptoDetailRow.swift
//  CryptoTracker
//
//  Created by David Lee on 11/25/25.
//

import SwiftUI

struct CryptoDetailRow: View {
  let title: String
  let value: String
  var valueColor: Color = .primary
  var accessibilityLabel: String
  
  var body: some View {
    HStack {
      Text(title)
        .font(.headline)
        .foregroundColor(.secondary)
      
      Spacer()
      
      Text(value)
        .font(.title3)
        .bold()
        .foregroundColor(valueColor)
    }
    .accessibilityElement(children: .combine)
    .accessibilityLabel(accessibilityLabel)
  }
}
