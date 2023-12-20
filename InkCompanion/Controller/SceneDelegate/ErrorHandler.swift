//
//  ErrorHandler.swift
//  Harbour
//
//  Created by royal on 07/06/2023.
//  Copyright © 2023 shameful. All rights reserved.
//

import Foundation
import IndicatorsKit

struct ErrorHandler: @unchecked Sendable {
	let wrappedValue: (Error, String) -> Void

	init(_ wrappedValue: @escaping (Error, String) -> Void) {
		self.wrappedValue = wrappedValue
	}

	func callAsFunction(_ error: Error, _ debugInfo: String = ._debugInfo()) {
		wrappedValue(error, debugInfo)
	}
}

struct LoadingHandler: @unchecked Sendable {
  let wrappedValue: (String, String, (String)->Void) -> Void

  init(_ wrappedValue: @escaping (String, String,(String)->Void) -> Void) {
    self.wrappedValue = wrappedValue
  }

  func callAsFunction(_ headline: String, _ debugInfo: String = ._debugInfo(),id:(String)->Void) {
    wrappedValue(headline, debugInfo,id)
  }
}

struct InformationHandler: @unchecked Sendable {
  let wrappedValue: (Indicator,String) -> Void

  init(_ wrappedValue: @escaping (Indicator,String) -> Void) {
    self.wrappedValue = wrappedValue
  }

  func callAsFunction(_ indicator: Indicator, _ debugInfo: String = ._debugInfo()) {
    wrappedValue(indicator, debugInfo)
  }
}
