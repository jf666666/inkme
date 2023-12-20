//
//  EnvironmentValues+ShowIndicator.swift
//  InkCompanion
//
//  Created by 姜锋 on 12/13/23.
//

import Foundation
import SwiftUI


extension EnvironmentValues {
  private struct ShowIndicatorEnvironmentKey: EnvironmentKey {
    static let defaultValue: SceneDelegate.ShowIndicatorAction = { indicator in
      assertionFailure("`showIndicator` has been called, but none is attached! Indicator: \(indicator)")
    }
  }

  /// An action that shows provided indicator.
  var showIndicator: SceneDelegate.ShowIndicatorAction {
    get { self[ShowIndicatorEnvironmentKey.self] }
    set { self[ShowIndicatorEnvironmentKey.self] = newValue }
  }
}
