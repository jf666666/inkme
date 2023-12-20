//
//  Indicators.swift
//  InkCompanion
//
//  Created by 姜锋 on 12/13/23.
//

import Foundation
import IndicatorsKit
import SwiftUI


extension Indicator{
  
}

struct IndicatorsOverlay_Previews: PreviewProvider {
  static var previews: some View {
    var model: Indicators {
      let model = Indicators()

      for i in 0..<1 {
        DispatchQueue.global().asyncAfter(deadline: .now() + (Double(i * 2))) {
          let indicator = Indicator(id: UUID().uuidString,
                        icon: "xmark",
                        headline: "Headline \(i)",
                        subheadline: "Subheadline",
                        expandedText: "Expanded Text",
                        dismissType: .manual)
          model.display(indicator)
        }
      }

      return model
    }

    return Text("")
      .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
      .indicatorOverlay(model: model)
  }
}
