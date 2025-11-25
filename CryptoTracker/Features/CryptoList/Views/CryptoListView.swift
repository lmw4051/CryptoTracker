//
//  CryptoListView.swift
//  CryptoTracker
//
//  Created by David Lee on 11/25/25.
//

import SwiftUI
import Models
import LocalizationKit

struct CryptoListView: View {
  @StateObject private var viewModel = CryptoListViewModel()
  
  var body: some View {
    NavigationStack {
      Group {
        if viewModel.isLoading {
          ProgressView(L10n.CryptoList.loading)
            .accessibilityIdentifier(AccessibilityID.CryptoList.loadingIndicator)
            .accessibilityLabel(L10n.Accessibility.loadingIndicator)
        } else if let error = viewModel.errorMessage {
          VStack(spacing: 16) {
            Image(systemName: "exclamationmark.triangle")
              .font(.largeTitle)
              .foregroundColor(.red)
            Text(L10n.CryptoList.error)
              .font(.headline)
            Text(error)
              .font(.caption)
              .foregroundColor(.secondary)
          }
          .padding()
          .accessibilityIdentifier(AccessibilityID.CryptoList.errorMessage)
          .accessibilityElement(children: .combine)
        } else {
          List(viewModel.cryptos) { crypto in
            NavigationLink(destination: EmptyView()) {
              CryptoRowView(crypto: crypto)
            }
            .accessibilityIdentifier(AccessibilityID.CryptoList.row(crypto.id))
            .accessibilityLabel(L10n.Accessibility.cryptoRow(crypto.name))
          }
          .accessibilityIdentifier(AccessibilityID.CryptoList.table)
        }
      }
      .navigationTitle(L10n.CryptoList.title)
      .toolbar {
        ToolbarItem(placement: .navigationBarTrailing) {
          Button(action: {
            viewModel.fetchCryptos()
          }) {
            Image(systemName: "arrow.clockwise")
          }
          .accessibilityIdentifier(AccessibilityID.CryptoList.refreshButton)
          .accessibilityLabel(L10n.Accessibility.refreshButton)
          .accessibilityHint("Double tap to refresh the list")
        }
        
        ToolbarItem(placement: .navigationBarLeading) {
          ConnectionIndicator(state: viewModel.connectionState)
        }
      }
      .onAppear {
        viewModel.fetchCryptos()
        viewModel.startRealtimeUpdates()
      }
      .onDisappear {
        viewModel.stopRealtimeUpdates()
      }
    }
    .accessibilityIdentifier(AccessibilityID.CryptoList.view)
  }
}
