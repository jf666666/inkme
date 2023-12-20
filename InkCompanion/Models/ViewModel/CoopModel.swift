//
//  CoopModel.swift
//  InkCompanion
//
//  Created by 姜锋 on 11/23/23.
//

import Foundation
import Combine
import CoreData
import SwiftUI
import OSLog


class CoopModel:ObservableObject{
  
  @Published var selectedRule:CoopRule = .ALL
  @Published var navigationTitle:String = CoopRule.ALL.name
  @Published var selectedHistory:CoopHistoryDetail? = nil
  @Published var selectedId:String?
  @Published var progress:Double = 0
  @Published var rows:[[CoopHistoryDetail]] = []
  

  var ruleFilter:FilterProps = FilterProps(modes: ["salmon_run"])
  var startDate:Date? = nil
  var endDate:Date? = nil

  var stats:Stats = .none
  var currentDetail:CoopHistoryDetail = MockData.getCoopHistoryDetail()
  private let inkNet = InkNet.shared
  private let inkData = InkData.shared
  

  enum Stats {
    case refreshing
    case none
  }

  /// 并发获取打工记录
  func loadFromNet() async{
    if self.stats == .refreshing{
      return
    }
    self.stats = .refreshing
    let newCoopGroups = await inkNet.fetchCoopHistories()?.historyGroups?.nodes ?? []
    for group in newCoopGroups.reversed() {
      if let details = group.historyDetails?.nodes{
        await withTaskGroup(of: CoopHistoryDetail?.self) { group in
          for detail in details {
            group.addTask {
              if await self.inkData.isExist(id: detail.id){
                return nil
              }
              if let completeDetail = await self.inkNet.fetchCoopHistoryDetail(id: detail.id, diff: detail.gradePointDiff ?? .NONE){
                DispatchQueue.main.async {
                  withAnimation {
                    self.rows.insert(completeDetail, coopCanGroup: self.coopCanGroup)
                  }
                }
                return completeDetail
              }
              return nil
            }
          }
          for await result in group{
            if let completeDetail = result{
              await inkData.addCoop(detail: completeDetail)
//              DispatchQueue.main.async {
//                if self.rows.isEmpty || !self.coopCanGroup(current: self.rows[0][0], new: completeDetail){
//                  withAnimation {
//                    self.rows.insert([completeDetail], at: 0)
//                  }
//                }else{
//                  withAnimation {
//                    self.rows[0].insert(contentsOf: [completeDetail])
//                  }
//                }
//              }
            }
          }
        }
      }
    }
    self.stats = .none
  }

  @MainActor
  func loadFromData(length:Int) async {

    await self.rows = inkData.queryDetailGroup(totalGroup: 5,filter: self.ruleFilter, canGroup: coopCanGroup)


  }
  
  

  @MainActor
  func reloadFromData() async {
    if let date = self.rows.last?.last?.playedTime.asDate{
      var filter = self.ruleFilter
      filter.dateRange = [Date.distantPast, date]
      await self.rows += inkData.queryDetailGroup(totalGroup: 1, filter: filter, canGroup: coopCanGroup)
    }
  }

  private func coopCanGroup(current detail: CoopHistoryDetail,new:CoopHistoryDetail)->Bool{
    return detail.rule == new.rule && detail.coopStage.id == new.coopStage.id && detail.weapons.map{$0.image?.url ?? ""}.joined(separator: ",") == new.weapons.map{$0.image?.url ?? ""}.joined(separator: ",")
  }
}


extension CoopModel{
  private func setRuleFilter(rule:CoopRule){
    self.ruleFilter.dateRange = nil
    if rule == .ALL{
      self.ruleFilter.rules = nil
      return
    }
    self.ruleFilter.rules = [rule.rawValue]
  }

  @MainActor
  func selectRule(rule:CoopRule) async{
    self.rows = []
    setRuleFilter(rule: rule)
    await self.loadFromData(length: 300)
  }

  func selectTimeRange(start:Date?, end:Date?) async{
    self.rows = []
    if let start = start, let end = end{
      self.ruleFilter.dateRange = [start,end]
    }
    await self.loadFromData(length: 300)
  }
}
