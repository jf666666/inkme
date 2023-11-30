//
//  BattleRotationDict.swift
//  Ikalendar2
//
//  Copyright (c) 2023 TIANWEI ZHANG. All rights reserved.
//

import Foundation

typealias BattleRotationDict = [BattleMode: [BattleRotation]]

extension BattleRotationDict {
  /// Returns true if any `BattleMode`s contain empty rotations.
  var isEmpty: Bool {
    values.contains { $0.isEmpty }
  }

  /// Returns true if the dict is outdated.
  var isOutdated: Bool {
    !isEmpty && self[.regular]!.first!.endTime < TimePublisher.shared.currentTime
  }

  // MARK: Lifecycle

  init() {
    self = [:]
    for mode in BattleMode.allCases {
      self[mode] = []
    }
  }
}
