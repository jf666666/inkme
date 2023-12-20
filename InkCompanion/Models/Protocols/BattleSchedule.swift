//
//  BattleSchedule.swift
//  InkCompanion
//
//  Created by 姜锋 on 12/1/23.
//

import Foundation

struct BattleRegularSchedule:Schedule{
  var mode: ScheduleMode

  var rule: BattleRule
  
  var startTime: Date
  
  var endTime: Date
  
  var stages: [Stage]
}

struct Battle2CasesSchedule:Schedule{
  var mode: ScheduleMode

  var rule: BattleRule

  var subRule: BattleRule

  var startTime: Date
  
  var endTime: Date
  
  var stages: [Stage]

  var subStages:[Stage]
  
  func toRegularSchedule(isChallenge:Bool = true)->BattleRegularSchedule{
    if isChallenge{
      return BattleRegularSchedule(mode: mode, rule: rule, startTime: startTime, endTime: endTime, stages: stages)
    }
    return BattleRegularSchedule(mode: mode, rule: subRule, startTime: startTime, endTime: endTime, stages: subStages)
  }

}


extension RegularSchedule{
  func toSchedule() -> BattleRegularSchedule?{
    guard let stages = regularMatchSetting?.vsStages else { return nil}
    return BattleRegularSchedule(mode: .regular, rule: .turfWar, startTime: startTime.asDate, endTime: endTime.asDate, stages: stages)
  }
}

extension XSchedule{
  func toSchedule() -> BattleRegularSchedule?{
      guard let stages = xMatchSetting?.vsStages else { return nil}
      let mode = ScheduleMode.x
      let rule = xMatchSetting?.vsRule?.rule ?? .clamBlitz
      let start = startTime.asDate
      let end = endTime.asDate
    return BattleRegularSchedule(mode: mode, rule: rule, startTime: start, endTime: end, stages: stages)
    }
}


extension AnarchySchedules{
  func toSchedule() -> Battle2CasesSchedule?{
    guard let challengeSetting = bankaraMatchSettings?.first(where: {$0.mode == .CHALLENGE}) else {return nil}
    guard let stages = challengeSetting.vsStages else { return nil}
    guard let openSetting = bankaraMatchSettings?.first(where: {$0.mode == .OPEN}) else {return nil}
    guard let subStages = openSetting.vsStages else { return nil}
    let start = startTime.asDate
    let end = endTime.asDate
    let rule = challengeSetting.vsRule?.rule ?? .clamBlitz
    let subRule = openSetting.vsRule?.rule ?? .clamBlitz
    return Battle2CasesSchedule(mode: .anarchy, rule: rule, subRule: subRule, startTime: start, endTime: end, stages: stages, subStages: subStages)
  }
}

extension FestSchedule{
  func toSchedule() -> Battle2CasesSchedule?{
    guard let challengeSetting = festMatchSettings?.first(where: {$0.festMode == .challenge}) else {return nil}
    guard let stages = challengeSetting.vsStages else { return nil}
    guard let openSetting = festMatchSettings?.first(where: {$0.festMode == .regular}) else {return nil}
    guard let subStages = openSetting.vsStages else { return nil}
    let start = startTime.asDate
    let end = endTime.asDate
    let rule = challengeSetting.vsRule?.rule ?? .clamBlitz
    let subRule = openSetting.vsRule?.rule ?? .clamBlitz
    return Battle2CasesSchedule(mode: .fest, rule: rule, subRule: subRule, startTime: start, endTime: end, stages: stages, subStages: subStages)
  }
}

