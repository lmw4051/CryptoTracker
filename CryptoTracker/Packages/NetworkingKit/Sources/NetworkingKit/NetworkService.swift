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
