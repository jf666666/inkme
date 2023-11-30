//
//  FestSchedules.swift
//  InkCompanion
//
//  Created by 姜锋 on 11/9/23.
//

import Foundation

typealias FestSchedulesConnection = Connection<FestSchedule>

struct FestSchedule:Codable{
    let startTime:String
    let endTime:String
    let festMatchSettings:[FestMatchSetting]?
}


