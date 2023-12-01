//
//  MockData.swift
//  InkCompanion
//
//  Created by 姜锋 on 11/12/23.
//

import Foundation

struct MockData {
//  static func getBattleRotation(
//    preferredMode: ScheduleMode? = nil,
//    preferredRule: BattleRule? = nil,
//    rawStartTime: Date = Date())
//    -> BattleRotation
//  {
//    let startTime = rawStartTime.removeMinutes()!
//    let endTime =
//      Calendar.current.date(
//        byAdding: .hour,
//        value: 2,
//        to: startTime)!
//
//    func getRandomBattleStage() -> VsStage {
//      let fileURL = Bundle.main.url(forResource: "StageScheduleQuery", withExtension: "json")
//
//      let data = try? Data(contentsOf: fileURL!)
//
//      let stageSchedulesData = try? JSONDecoder().decode(StageSchedules.self, from: data!)
//      let allSchedules = stageSchedulesData?.data
//      let emptyStage = VsStage(__typename: nil, id: "", vsStageId: nil, originalImage: nil, stats: nil)
//      switch preferredMode{
//      case .anarchy:
//        let schedules = allSchedules?.bankaraSchedules?.nodes
//        return schedules?.randomElement()?.bankaraMatchSettings?.randomElement()?.vsStages?.randomElement() ?? emptyStage
//      case .event:
//        let schedules = allSchedules?.eventSchedules?.nodes
//        return schedules?.randomElement()?.leagueMatchSetting?.vsStages?.randomElement() ?? emptyStage
//      case .regular:
//        let schedules = allSchedules?.regularSchedules?.nodes
//        return schedules?.randomElement()?.regularMatchSetting?.vsStages?.randomElement() ?? emptyStage
//      case .x:
//        let schedules = allSchedules?.xSchedules?.nodes
//        return schedules?.randomElement()?.xMatchSetting?.vsStages?.randomElement() ?? emptyStage
//      default:
//        let schedules = allSchedules?.xSchedules?.nodes
//        return schedules?.randomElement()?.xMatchSetting?.vsStages?.randomElement() ?? emptyStage
//      }
//
//
//    }
//
//    let randomStageA = getRandomBattleStage()
//    var randomStageB = getRandomBattleStage()
//    while randomStageB.name == randomStageA.name {
//      // avoid duplicate
//      randomStageB = getRandomBattleStage()
//    }
//
//    var mode = ScheduleMode.allCases.randomElement()!
//    var rule = BattleRule.allCases.randomElement()!
//
//    if let preferredMode { mode = preferredMode }
//
//    if mode == .regular { rule = .turfWar }
//    else if let preferredRule { rule = preferredRule }
//    else {
//      while rule == .turfWar {
//        rule = BattleRule.allCases.randomElement()!
//      }
//    }
//
//    return BattleRotation(
//      startTime: startTime,
//      endTime: endTime,
//      mode: mode,
//      rule: rule,
//      stageA: randomStageA,
//      stageB: randomStageB)
//  }

  static func getCoopHistoryDetail()->CoopHistoryDetail{
    let fileURL = Bundle.main.url(forResource: "CoopDetailHolder", withExtension: "json")

    let data = try? Data(contentsOf: fileURL!)

    return try! JSONDecoder().decode(CoopHistoryDetailQuery.self, from: data!).data.coopHistoryDetail
  }

  static func getStageQuery()->StageSchedules{
    let fileURL = Bundle.main.url(forResource: "StageScheduleQuery", withExtension: "json")

    let data = try? Data(contentsOf: fileURL!)

    return try! JSONDecoder().decode(StageSchedules.self, from: data!)
  }

  static func getCoopHistoryGroup()->CoopHistoryGroup{
    let fileURL = Bundle.main.url(forResource: "CoopResult", withExtension: "json")

    let data = try? Data(contentsOf: fileURL!)

    return try! JSONDecoder().decode(CoopResult.self, from: data!).historyGroups!.nodes!.randomElement()!
  }
}
