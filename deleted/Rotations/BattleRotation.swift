//
//  BattleRotation.swift
//  Ikalendar2
//
//  Copyright (c) 2023 TIANWEI ZHANG. All rights reserved.
//

import Foundation

// MARK: - BattleRotation

/// Data model for the battle rotation.
struct BattleRotation: Rotation, Hashable {
  let startTime: Date
  let endTime: Date

  let mode: ScheduleMode
  let rule: BattleRule
  let stageA: any Stage
  let stageB: any Stage
}

extension BattleRotation {
  var id: String { "\(mode)-\(startTime)-\(endTime)" }

  var description: String {
    id +
      "-" +
      "\(rule)-\(stageA)-\(stageB)"
  }
}


extension BattleRotation {
  /// Determines whether the rotation is coming up next.
  func isNext(_ currentTime: Date) -> Bool {
    let twoHoursLater =
      Calendar.current.date(
        byAdding: .hour,
        value: 2,
        to: currentTime)!
    return startTime < twoHoursLater && twoHoursLater < endTime
  }
}

//extension BankaraSchedules {
//  func toBattleRotation() -> BattleRotation{
//
//  }
//}

extension RegularSchedule {
  func toRotation() -> BattleRotation?{
    guard let stages = regularMatchSetting?.vsStages else { return nil}
    let stageA = stages[0]
    let stageB = stages[1]
    let mode = ScheduleMode.regular
    let rule = BattleRule.turfWar
    let start = startTime.asDate
    let end = endTime.asDate
    return BattleRotation(startTime: start, endTime: end, mode: mode, rule: rule, stageA: stageA, stageB: stageB)
  }
}

extension XSchedule{
  func toRotation() -> BattleRotation?{
    guard let stages = xMatchSetting?.vsStages else { return nil}
    let stageA = stages[0]
    let stageB = stages[1]
    let mode = ScheduleMode.x
    let rule = xMatchSetting?.vsRule?.rule ?? .clamBlitz
    let start = startTime.asDate
    let end = endTime.asDate
    return BattleRotation(startTime: start, endTime: end, mode: mode, rule: rule, stageA: stageA, stageB: stageB)
  }
}

extension BankaraSchedules{
  func toRotation(for mode:BankaraMatchMode) -> BattleRotation?{
    guard let setting = bankaraMatchSettings?.first(where: {$0.mode == mode}) else {return nil}
    guard let stages = setting.vsStages else { return nil}
    let start = startTime.asDate
    let end = endTime.asDate
    let stageA = stages[0]
    let stageB = stages[1]
    let mode = ScheduleMode.anarchy(mode)
    let rule = setting.vsRule?.rule ?? .clamBlitz
    return BattleRotation(startTime: start, endTime: end, mode: mode, rule: rule, stageA: stageA, stageB: stageB)
  }
}

extension FestSchedule {
  func toRotation(for mode:FestMatchMode) -> BattleRotation?{
    guard let setting = festMatchSettings?.first(where: {$0.festMode == mode}) else {return nil}
    guard let stages = setting.vsStages else { return nil}
    let stageA = stages[0]
    let stageB = stages[1]
    let mode = ScheduleMode.fest(mode)
    let rule = BattleRule.turfWar
    let start = startTime.asDate
    let end = endTime.asDate
    return BattleRotation(startTime: start, endTime: end, mode: mode, rule: rule, stageA: stageA, stageB: stageB)
  }
}
