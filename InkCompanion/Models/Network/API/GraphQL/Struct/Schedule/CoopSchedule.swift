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
    let startTime:String?
    let endTime:String?
    let setting:Setting?
}

struct Setting:Codable{
    let __isCoopSetting:String?
    let __typename:String?
    let weapons:[Weapon]?
    let coopStage:CoopStage?
    let rule:CoopRule?
}

struct CoopGroupingSchedule:Codable{
    let bannerImage:Icon?
    let regularSchedules:CoopRegularSchedulesConnection?
    let bigRunSchedules:BigRunSchedulesConnection?
    let teamContestSchedules:TeamContestSchedulesConnection?
}
