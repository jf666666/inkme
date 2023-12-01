//
//  BattleMode.swift
//  Ikalendar2
//
//  Copyright (c) 2023 TIANWEI ZHANG. All rights reserved.
//

import SwiftUI

// MARK: - BattleMode

/// Data model for the battle modes.
//enum BattleMode: String, Identifiable, CaseIterable, Equatable, Codable {
//  static let `default`: Self = .regular
//
//  case regular
//  case x
//  case event
//  case anarchy_challenge
//  case anarchy_open
//  case fest
//  var id: String { rawValue }
//}

enum ScheduleMode: Identifiable, Equatable, Codable,Hashable {

    static let `default`: Self = .regular

    case regular
    case x
    case event
    case anarchy(BankaraMatchMode)
    case fest(FestMatchMode)

    var id: String {
        switch self {
        case .regular: return "regular"
        case .x: return "x"
        case .event: return "event"
        case .anarchy(let mode): return "anarchy_\(mode.rawValue)"
        case .fest(let mode): return "fest_\(mode.rawValue)"
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
    }
  }
}

extension ScheduleMode {
  var name: String {
    switch self {
    case .regular: "Regular"
    case .anarchy(let mode): "Anarchy \(mode.rawValue.capitalized)"
    case .event: "Event"
    case .x : "X Battle"
    case .fest(let mode): "Fest \(mode.rawValue.capitalized)"
    }
  }

  var shortName: String {
    switch self {
    case .regular: "Regular"
    case .anarchy: "Anarchy"
    case .event: "Challenge"
    case .x: "X"
    case .fest: "Fest"
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
    }
  }
}


extension ScheduleMode: CaseIterable {
    static var allCases: [ScheduleMode] {
      var cases: [ScheduleMode] = [.regular,.x, .event,.anarchy(.CHALLENGE), .fest(.regular)]
//        cases.append(contentsOf: BankaraMatchMode.allCases.map { .anarchy($0) })
//        cases.append(contentsOf: FestMatchMode.allCases.map { .fest($0) })
        return cases
    }

  static var anarchyCases:[ScheduleMode]{
    BankaraMatchMode.allCases.map { .anarchy($0) }
  }

  static var festCases:[ScheduleMode]{
    FestMatchMode.allCases.map { .fest($0) }
  }
}
