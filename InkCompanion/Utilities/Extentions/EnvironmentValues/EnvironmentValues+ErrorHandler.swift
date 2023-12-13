//
//  EnvironmentValues+.swift
//  InkCompanion
//
//  Created by 姜锋 on 12/13/23.
//

import Foundation
import SwiftUI
import OSLog

extension EnvironmentValues {
  private struct ErrorHandlerEnvironmentKey: EnvironmentKey {
    static let defaultValue: ErrorHandler = .init { error, _debugInfo in
      assertionFailure("`errorHandler` has been called, but none is attached!")
      os_log(.error, log: .default, "Error: \(error, privacy: .public) [\(_debugInfo, privacy: .public)]")
    }
  }

  /// An action that can handle provided error.
  var errorHandler: ErrorHandler {
    get { self[ErrorHandlerEnvironmentKey.self] }
    set { self[ErrorHandlerEnvironmentKey.self] = newValue }
  }
}

extension EnvironmentValues {
  private struct LoadingHandlerEnvironmentKey: EnvironmentKey {
    static let defaultValue: LoadingHandler = .init { headline, _debugInfo, _ in
      assertionFailure("`LoadingHandler` has been called, but none is attached!")
      os_log(.error, log: .default, "Error: \(headline, privacy: .public) [\(_debugInfo, privacy: .public)]")
    }
  }
  
  var loadingHandler: LoadingHandler {
    get { self[LoadingHandlerEnvironmentKey.self] }
    set { self[LoadingHandlerEnvironmentKey.self] = newValue }
  }
}

extension EnvironmentValues {
  private struct InformationHandlerEnvironmentKey: EnvironmentKey {
    static let defaultValue: InformationHandler = .init { indicator, _debugInfo in
      assertionFailure("`LoadingHandler` has been called, but none is attached!")
      os_log(.error, log: .default, "[\(_debugInfo, privacy: .public)]")
    }
  }

  var informationHandler: InformationHandler {
    get { self[InformationHandlerEnvironmentKey.self] }
    set { self[InformationHandlerEnvironmentKey.self] = newValue }
  }
}
