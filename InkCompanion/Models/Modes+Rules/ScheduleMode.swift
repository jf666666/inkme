//
//  BattleMode.swift
//  Ikalendar2
//
//  Copyright (c) 2023 TIANWEI ZHANG. All rights reserved.
//

import SwiftUI

enum ScheduleMode: Identifiable, Equatable, Codable,Hashable, CaseIterable {

  static let `default`: Self = .regular

  case regular
  case x
  case event
  case anarchy
  case fest
  case salmonRun

  var id: String {
    switch self {
    case .regular: return "regular"
    case .x: return "x"
    case .event: return "event"
    case .anarchy: return "anarchy"
    case .fest: return "fest"
    case .salmonRun: return "salmon_run"
    }
  }
}


extension ScheduleMode {
  var themeColor: Color {
    switch self {
    case .regular: .regularBattleTheme
    case .anarchy: .anarchyBattleTheme
    case .event: .leagueBattleTheme
    case .x: .xBattleTheme
    case .fest:.leagueBattleTheme
    case .salmonRun: .salmonRunTheme

    }
  }
}

extension ScheduleMode {
  var name: String {
    switch self {
    case .regular: "Regular"
    case .anarchy: "Anarchy"
    case .event: "Event"
    case .x : "X Battle"
    case .fest: "Fest"
    case .salmonRun: "Salmon Run"
    }
  }

  var shortName: String {
    switch self {
    case .regular: "Regular"
    case .anarchy: "Anarchy"
    case .event: "Challenge"
    case .x: "X"
    case .fest: "Fest"
    case .salmonRun: "Salmon Run"
    }
  }
}

extension ScheduleMode{
  var icon:Image{
    switch self {
    case .regular:
      return Image(.regular)
    case .x:
      return Image(.xBattle)
    case .event:
      return Image(.event)
    case .anarchy:
      return Image(.anarchy)
    case .fest:
      return Image(.league)
    case .salmonRun:
      return Image(.salmonRun)
    }
  }
}



