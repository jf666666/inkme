//
//  SceneDelegate+Indicators.swift
//  Harbour
//
//  Created by royal on 29/01/2023.
//  Copyright © 2023 shameful. All rights reserved.
//

import Foundation
import IndicatorsKit
import SwiftUI


// MARK: - SceneDelegate+Indicators

extension SceneDelegate {
	typealias ShowIndicatorAction = (PresentedIndicator) -> Void

	@MainActor
	func showIndicator(_ presentedIndicator: PresentedIndicator) {
		let indicator: Indicator

		switch presentedIndicator {
		case .error(let error):
			indicator = Indicator(error: error)
		case .copied:
			let style: Indicator.Style = .default
			indicator = Indicator(id: presentedIndicator.id,
								  icon: SFSymbol.copy,
								  headline: String(localized: "Indicators.Copied"),
								  style: style)
    case .loading(let (id,headline)):
      let style: Indicator.Style = .default
      indicator = Indicator(id: id,  headline: headline,dismissType:.triggered,style: style)
    case .information(let i):
      indicator = i
		}

		Task { @MainActor in
      SceneDelegate.indicators.display(indicator)
		}
	}

  @MainActor
  func endLoading(id:String) {
    if let loadingIndicator = SceneDelegate.indicators.indicators.first(where: { $0.id == id}) {
      // 更新 Indicator 状态或者移除 Indicator
      // 可以通过改变 isLoading 属性或者直接调用 dismiss
      SceneDelegate.indicators.dismiss(matching: loadingIndicator.id)
    }
  }
}

// MARK: - SceneDelegate+PresentedIndicator

extension SceneDelegate {
	enum PresentedIndicator: Identifiable {
		case copied
		case error(Error)
    case loading((String,String))
    case information(Indicator)

		var id: String {
			switch self {
			case .copied:
				"CopiedIndicator.\(UUID().uuidString)"
			case .error(let error):
				"ErrorIndicator.\(String(describing: error).hashValue)"
      case .loading:
        "LoadingIndicator.\(UUID().uuidString)"
      case .information:
        "InformationIndicator.\(UUID().uuidString)"
			}
		}
	}
}

extension Indicator.DismissType{
}
