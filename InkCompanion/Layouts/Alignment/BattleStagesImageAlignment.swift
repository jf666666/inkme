//
//  BattleStagesImageAlignment.swift
//  Ikalendar2
//
//  Copyright (c) 2023 TIANWEI ZHANG. All rights reserved.
//

import SwiftUI

extension VerticalAlignment {
  private enum BattleStagesImageAlignment: AlignmentID {
    static func defaultValue(in context: ViewDimensions) -> CGFloat {
      context[.top]
    }
  }

  static let battleStagesImageAlignment = VerticalAlignment(BattleStagesImageAlignment.self)
}
