//
//  CoopSchedule.swift
//  InkCompanion
//
//  Created by 姜锋 on 12/3/23.
//

import Foundation

struct ShiftSchedule:Schedule{
  var rule: CoopRule

  var mode: CoopMode

  var startTime: Date

  var endTime: Date

  var stages: [Stage]
  
  var weapons:[Weapon]
}

extension CoopSchedule{
  func toShift()->ShiftSchedule{
    return ShiftSchedule(rule: setting.rule, mode: .REGULAR, startTime: startTime.asDate, endTime: endTime.asDate, stages: [setting.coopStage], weapons: setting.weapons)
  }
}
