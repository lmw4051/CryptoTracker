//
//  File.swift
//  NetworkingKit
//
//  Created by David Lee on 11/24/25.
//

import Foundation
import Combine

public enum WebSocketConnectionState {
  case disconnected
  case connecting
  case connected
  case error(Error)
}
