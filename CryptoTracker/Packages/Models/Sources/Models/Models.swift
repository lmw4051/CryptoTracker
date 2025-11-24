import Foundation

public struct Crypto: Identifiable, Codable, Equatable {
  public let id: String
  public let symbol: String
  public let name: String
  public let currentPrice: Double
  public let priceChangePercentage24h: Double
  public let marketCap: Double?
  public let image: String?
  
  enum CodingKeys: String, CodingKey {
    case id, symbol, name, image
    case currentPrice = "current_price"
    case priceChangePercentage24h = "price_change_percentage_24h"
    case marketCap = "market_cap"
  }
  
  public init(
    id: String,
    symbol: String,
    name: String,
    currentPrice: Double,
    priceChangePercentage24h: Double,
    marketCap: Double? = nil,
    image: String? = nil
  ) {
    self.id = id
    self.symbol = symbol
    self.name = name
    self.currentPrice = currentPrice
    self.priceChangePercentage24h = priceChangePercentage24h
    self.marketCap = marketCap
    self.image = image
  }
}
