//
//  StageSchedules.swift
//  InkCompanion
//
//  Created by 姜锋 on 11/9/23.
//

import Foundation

typealias VsStageConnection = Connection<VsStage>

struct StageSchedules:Codable{
    struct Data:Codable{
        let bankaraSchedules:BankaraSchedulesConnection?
        let coopGroupingSchedule:CoopGroupingSchedule?
        let currentFest:Fest?
        let eventSchedules:EventSchedulesConnection?
        let festSchedules:FestSchedulesConnection?
        let regularSchedules:RegularSchedulesConnection?
        let vsStages:VsStageConnection?
        let xSchedules:XSchedulesConnection?
    }
    let data:Data
}
