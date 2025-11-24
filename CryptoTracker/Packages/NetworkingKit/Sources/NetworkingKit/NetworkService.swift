import Foundation
import Combine

public enum NetworkError: Error, LocalizedError {
  case invalidURL
  case requestFailed(Error)
  case invalidResponse
  case decodingFailed(Error)
  
  public var errorDescription: String? {
    switch self {
    case .invalidURL:
      return "Invalid URL"
    case .requestFailed(let error):
      return "Request failed: \(error.localizedDescription)"
    case .invalidResponse:
      return "Invalid response"
    case .decodingFailed(let error):
      return "Decoding failed: \(error.localizedDescription)"
    }
  }
}

public struct Endpoint {
  public let path: String
  public let method: String
  public let headers: [String: String]?
  public let baseURL: String
  
  public init(path: String,
              method: String = "GET",
              headers: [String: String]? = nil,
              baseURL: String = "https://api.coingecko.com/api/v3") {
    self.path = path
    self.method = method
    self.headers = headers
    self.baseURL = baseURL
  }
  
  public var url: URL? {
    URL(string: "\(baseURL)\(path)")
  }
}
