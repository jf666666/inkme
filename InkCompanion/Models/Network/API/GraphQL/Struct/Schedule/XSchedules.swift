//
//  XSchedules.swift
//  InkCompanion
//
//  Created by 姜锋 on 11/9/23.
//

import Foundation

typealias XSchedulesConnection = Connection<XSchedule>

struct XSchedule:Codable{
    let startTime:String
    let endTime:String
    let xMatchSetting:XMatchSetting?
  let festMatchSettings:[FestMatchSetting]?
}

struct XMatchSetting:Codable{
  let vsStages:[VsStage]?
  let vsRule:VsRule?
}
