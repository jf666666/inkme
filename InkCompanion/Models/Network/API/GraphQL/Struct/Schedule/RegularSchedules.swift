//
//  RegularSchedules.swift
//  InkCompanion
//
//  Created by 姜锋 on 11/9/23.
//

import Foundation

typealias RegularSchedulesConnection = Connection<RegularSchedule>

struct RegularSchedule:Codable{
    let startTime:String
    let endTime:String
    let regularMatchSetting:RegularMatchSetting?
  let festMatchSettings:[FestMatchSetting]?
}

struct RegularMatchSetting:Codable{
  let vsStages:[VsStage]?
  let vsRule:VsRule?
}
//export interface FestMatchSetting extends VsSetting {
//    __typename: 'FestMatchSetting';
//    vsStages: VsStage[];
//    vsRule: VsRule;
//    mode: FestMatchMode;
//}
//
//export declare enum FestMatchMode {
//    CHALLENGE = "CHALLENGE",
//    REGULAR = "REGULAR",
//}

