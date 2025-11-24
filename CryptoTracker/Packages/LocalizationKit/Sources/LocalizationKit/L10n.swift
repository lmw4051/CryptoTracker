import Foundation

public enum L10n {
  public static func tr(
    _ key: String,
    _ args: CVarArg...
  ) -> String {
    let format = NSLocalizedString(key, comment: "")
    return String(format: format, arguments: args)
  }
}

// MARK: - Keys
public extension L10n {
  enum App {
    public static let title = tr("app.title")
  }
  
  enum CryptoList {
    public static let title = tr("crypto_list.title")
    public static let refresh = tr("crypto_list.refresh")
    public static let loading = tr("crypto_list.loading")
    public static let error = tr("crypto_list.error")
  }
  
  enum CryptoDetail {
    public static let price = tr("crypto_detail.price")
    public static let change24h = tr("crypto_detail.change_24h")
    public static let marketCap = tr("crypto_detail.market_cap")
  }
  
  enum Accessibility {
    public static func cryptoRow(_ name: String) -> String {
      tr("accessibility.crypto_row", name)
    }
    public static let refreshButton = tr("accessibility.refresh_button")
    public static let loadingIndicator = tr("accessibility.loading_indicator")
  }
}
