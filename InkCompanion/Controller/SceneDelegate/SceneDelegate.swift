//
//  SceneDelegate.swift
//  Harbour
//
//  Created by royal on 19/12/2022.
//  Copyright © 2023 shameful. All rights reserved.
//

import IndicatorsKit
import OSLog
import SwiftUI

final class SceneDelegate: NSObject, ObservableObject {
	let logger = Logger(.custom(SceneDelegate.self))
	static let indicators = Indicators()
}

extension SceneDelegate {
  @MainActor
  func handleError(_ error: Error, _debugInfo: String = ._debugInfo()) {

    logger.error("Error: \(error, privacy: .public) [\(_debugInfo, privacy: .public)]")

    Haptics.generateIfEnabled(.error)
    showIndicator(.error(error))

  }
}

extension SceneDelegate {
  @MainActor
  func handleLoading(headline:String, _debugInfo:String = ._debugInfo(), isLoading:(String)->Void){
    logger.debug("\(_debugInfo)")

    Haptics.generateIfEnabled(.light)
    let id = "LoadingIndicator.\(UUID().uuidString)"
    showIndicator(.loading((id,headline)))
    isLoading(id)
  }
}


extension SceneDelegate {
  @MainActor
  func handleInformation(indicator:Indicator, _debugInfo:String = ._debugInfo()){
    logger.debug("\(_debugInfo)")

    Haptics.generateIfEnabled(.success)
    showIndicator(.information(indicator))
  }
}
