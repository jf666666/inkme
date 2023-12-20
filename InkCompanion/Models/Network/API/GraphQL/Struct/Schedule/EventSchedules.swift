//
//  EventSchedules.swift
//  InkCompanion
//
//  Created by 姜锋 on 11/9/23.
//

import Foundation

typealias EventSchedulesConnection = Connection<EventSchedules>

struct EventSchedules:Codable{
    struct TimePeriod:Codable{
        let startTime:String?
        let endTime:String?
    }
  let leagueMatchSetting:LeagueMatchSetting?
    let timePeriods:[TimePeriod]?
    
}

struct LeagueMatchSetting:Codable{
  let leagueMatchEvent:LeagueMatchEvent
  let vsStages:[VsStage]?
  let vsRule:VsRule?
}


