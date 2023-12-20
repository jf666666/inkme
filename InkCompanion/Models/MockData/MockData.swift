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

  static func getCoopRecord()->CoopRecord{
    let fileURL = Bundle.main.url(forResource: "CoopRecordQuery_EN", withExtension: "json")

    let data = try? Data(contentsOf: fileURL!)

    return try! JSONDecoder().decode(CoopRecordQuery.self, from: data!).data.coopRecord
  }

  static func getBattleSchedules(preferredMode: ScheduleMode = .regular,
                                 preferredRule: BattleRule = .turfWar,
                           rawStartTime: Date = Date())->[BattleRegularSchedule]{
    var startTime = rawStartTime/*.removeMinutes()!*/
    var endTime =
      Calendar.current.date(
        byAdding: .minute,
        value: 1,
        to: startTime)!
    var schedules:[BattleRegularSchedule] = []
    for _ in Array(0..<13){
      let stageA = VsStage(id: StageSelection.allCases.randomElement()!.rawValue, name: "", stats: nil)
      let stageB = VsStage(id: StageSelection.allCases.randomElement()!.rawValue, name: "", stats: nil)
      let schedule = BattleRegularSchedule(mode: preferredMode, rule: BattleRule.allCases.randomElement()!, startTime: startTime, endTime: endTime, stages: [stageA,stageB])
      startTime = endTime
      endTime = endTime.addingTimeInterval(7200)
      schedules.append(schedule)
    }
    return schedules
  }



  static func getVsHistoryDetail()->VsHistoryDetail?{
    struct DetailQuery:Codable{
      struct Data:Codable{
        let vsHistoryDetail:VsHistoryDetail
      }
      let data:Data
    }
    let fileURL = Bundle.main.url(forResource: "VsHistoryDetailQuery", withExtension: "json")

    let data = try? Data(contentsOf: fileURL!)
    do {
      let q =  try JSONDecoder().decode(DetailQuery.self, from: data!)
      return q.data.vsHistoryDetail
    }catch let error as NSError{
      print(error)
      return nil
    }

  }

  static func getCoopHistoryGroup()->CoopHistoryGroup{
    let fileURL = Bundle.main.url(forResource: "CoopResult", withExtension: "json")

    let data = try? Data(contentsOf: fileURL!)

    return try! JSONDecoder().decode(CoopResult.self, from: data!).historyGroups!.nodes!.randomElement()!
  }
}
