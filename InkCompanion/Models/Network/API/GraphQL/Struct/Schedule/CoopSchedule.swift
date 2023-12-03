//
//  CoopSchedules.swift
//  InkCompanion
//
//  Created by 姜锋 on 11/9/23.
//

import Foundation

typealias CoopRegularSchedulesConnection = Connection<CoopSchedule>
typealias BigRunSchedulesConnection = Connection<CoopSchedule>
typealias TeamContestSchedulesConnection = Connection<CoopSchedule>

struct CoopSchedule:Codable{
    let startTime:String
    let endTime:String
    let setting:CoopScheduleSetting
}

struct CoopScheduleSetting:Codable{
    let weapons:[Weapon]
    let coopStage:CoopStage
    let rule:CoopRule
    let boss:CoopEnemy
  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    self.weapons = try container.decode([Weapon].self, forKey: .weapons)
    self.coopStage = try container.decode(CoopStage.self, forKey: .coopStage)
    do{
      self.rule = try container.decode(CoopRule.self, forKey: .rule)
    }catch{
      self.rule = .REGULAR
    }
    do {
      self.boss = try container.decode(CoopEnemy.self, forKey: .boss)
    }catch{
      self.boss = CoopEnemy(id: "", name: "", image: nil)
    }
  }
}

struct CoopGroupingSchedule:Codable{
    let bannerImage:Icon
    let regularSchedules:CoopRegularSchedulesConnection
    let bigRunSchedules:BigRunSchedulesConnection
    let teamContestSchedules:TeamContestSchedulesConnection
}
