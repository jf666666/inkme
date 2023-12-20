//
//  BankaraSchedules.swift
//  InkCompanion
//
//  Created by 姜锋 on 11/9/23.
//

import Foundation

typealias BankaraSchedulesConnection = Connection<AnarchySchedules>

struct AnarchySchedules:Codable{
    let startTime:String
    let endTime:String
    let bankaraMatchSettings:[BankaraMatchSetting]?
    let festMatchSettings:[FestMatchSetting]?
}


struct BankaraMatchSetting:Codable{
    let vsStages:[VsStage]?
    let vsRule:VsRule?
    let mode:BankaraMatchMode?
  enum CodingKeys: String, CodingKey {
    case vsStages
    case vsRule
    case mode = "bankaraMode"
  }
}

struct FestMatchSetting:Codable{
    let vsStages:[VsStage]?
    let vsRule:VsRule?
    let festMode:FestMatchMode?
}
