//
//  BattleRule.swift
//  Ikalendar2
//
//  Copyright (c) 2023 TIANWEI ZHANG. All rights reserved.
//

// MARK: - BattleRule

/// Data model for the battle rules.
import SwiftUI
enum BattleRule: String, Identifiable, CaseIterable, Equatable,Codable {
  case turfWar = "TURF_WAR"
  case splatZones = "AREA"
  case towerControl = "LOFT"
  case rainmaker = "GOAL"
  case clamBlitz = "CLAM"

  var id: String { rawValue }
}

extension BattleRule {
  var key: String {
    switch self {
    case .turfWar: "turf_war"
    case .splatZones: "splat_zones"
    case .towerControl: "tower_control"
    case .rainmaker: "rainmaker"
    case .clamBlitz: "clam_blitz"
    }
  }
}

extension BattleRule {
  var image: Image {
    switch self {
    case .clamBlitz: Image(.clamBlitz)
    case .rainmaker: Image(.rainmaker)
    case .splatZones: Image(.splatZones)
    case .towerControl: Image(.towerControl)
    case .turfWar: Image(.turfWar2)
    }
  }
}

extension BattleRule {
  var name: String {
    switch self {
    case .turfWar: "Turf War"
    case .splatZones: "Splat Zones"
    case .towerControl: "Tower Control"
    case .rainmaker: "Rainmaker"
    case .clamBlitz: "Clam Blitz"
    }
  }

  var abbreviation: String {
    switch self {
    case .turfWar: "TW"
    case .splatZones: "SZ"
    case .towerControl: "TC"
    case .rainmaker: "RM"
    case .clamBlitz: "CB"
    }
  }
}

extension BattleRule {
  var description: String {
    switch self {
    case .turfWar: "In a Turf War, teams have three minutes to cover the ground with ink. " +
      "The team that claims the most turf with their ink wins the battle."
    case .splatZones: "Plays similarly to the King of the Hill mode from other video " +
      "games. It revolves around a central \"zone\" or \"zones\", which players must attempt " +
      "to cover in ink. Whoever retains the zone for a certain amount of time wins."
    case .towerControl: "A player must take control of a tower located in the center of " +
      "a map and ride it towards the enemy base. " +
      "The first team to get the tower to their enemy's base wins."
    case .rainmaker: "A player must grab and take the Rainmaker weapon to a pedestal near " +
      "the enemy team's spawn point. The team who carries the Rainmaker furthest " +
      "towards their respective pedestal wins."
    case .clamBlitz: "Players pick up clams scattered around the stage and try to score " +
      "as many points as they can by throwing the clams in their respective goal."
    }
  }
}

extension BattleRule {
  var releaseDate: String {
    switch self {
    case .turfWar: "06/02/2015"
    case .splatZones: "06/02/2015"
    case .towerControl: "07/02/2015"
    case .rainmaker: "08/15/2015"
    case .clamBlitz: "12/13/2017"
    }
  }
}


