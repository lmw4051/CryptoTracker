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

public protocol NetworkServiceProtocol {
  func fetch<T: Decodable>(_ endpoint: Endpoint) -> AnyPublisher<T, NetworkError>
}

public class NetworkService: NetworkServiceProtocol {
  private let session: URLSession
  
  public init(session: URLSession = .shared) {
    self.session = session
  }
  
  public func fetch<T: Decodable>(_ endpoint: Endpoint) -> AnyPublisher<T, NetworkError> {
    guard let url = endpoint.url else {
      return Fail(error: NetworkError.invalidURL).eraseToAnyPublisher()
    }
    
    var request = URLRequest(url: url)
    request.httpMethod = endpoint.method
    request.timeoutInterval = 30
    endpoint.headers?.forEach { request.setValue($0.value, forHTTPHeaderField: $0.key) }
    
    return session.dataTaskPublisher(for: request)
      .tryMap { output in
        guard let httpResponse = output.response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode) else {
          throw NetworkError.invalidResponse
        }
        return output.data
      }
      .decode(type: T.self, decoder: JSONDecoder())
      .mapError { error in
        if let networkError = error as? NetworkError {
          return networkError
        } else if error is DecodingError {
          return NetworkError.decodingFailed(error)
        } else {
          return NetworkError.requestFailed(error)
        }
      }
      .receive(on: DispatchQueue.main)
      .eraseToAnyPublisher()
  }
}
