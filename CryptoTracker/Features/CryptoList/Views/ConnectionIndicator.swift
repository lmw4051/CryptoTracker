//
//  CryptoListView.swift
//  CryptoTracker
//
//  Created by David Lee on 11/25/25.
//

import SwiftUI
import NetworkingKit
import Models
import LocalizationKit

struct ConnectionIndicator: View {
  let state: WebSocketConnectionState
  
  var body: some View {
    HStack(spacing: 4) {
      Circle()
        .fill(statusColor)
        .frame(width: 8, height: 8)
      
      if case .error = state {
        Image(systemName: "exclamationmark.triangle.fill")
          .font(.caption)
          .foregroundColor(.orange)
      }
    }
    .accessibilityLabel(accessibilityText)
  }
  
  private var statusColor: Color {
    switch state {
    case .connected:
      return .green
    case .connecting:
      return .yellow
    case .disconnected:
      return .gray
    case .error:
      return .red
    }
  }
  
  private var accessibilityText: String {
    switch state {
    case .connected:
      return "WebSocket connected"
    case .connecting:
      return "WebSocket connecting"
    case .disconnected:
      return "WebSocket disconnected"
    case .error:
      return "WebSocket connection error"
    }
  }
}
