//
//  BattleModel.swift
//  InkCompanion
//
//  Created by 姜锋 on 12/4/23.
//

import Foundation
import SwiftUI
import IndicatorsKit

class BattleModel:ObservableObject{
  @Published var rows:[[VsHistoryDetail]] = []
  @Published var fetching:Bool = false
  private let inkNet = InkNet.shared
  private let inkData = InkData.shared
  let indicator = SceneDelegate.indicators

  enum Stats {
    case refreshing
    case none
  }

  var ruleFilter:FilterProps = FilterProps(modes: ["REGULAR","BANKARA","XMATCH","LEAGUE","PRIVATE"])

  var stats:Stats = .none

  func loadFromNet() async {
    if self.stats == .refreshing{
      return
    }
    self.stats = .refreshing
//    guard let histories = await inkNet.fetchBattleHistory(for: .Latest)?.historyGroups.nodes?[0].historyDetails.nodes else {return}
    guard let historiesGroups = await inkNet.fetchBattleHistory(for: .Latest)?.historyGroups.nodes else {return}
    let histories = historiesGroups.compactMap { $0.historyDetails.nodes }.flatMap { $0 }
    var modeShouldSkip:[BattleMode:Bool] = [:]
    for mode in BattleMode.allCases{
      modeShouldSkip[mode] = true
    }
    for history in histories {
      let id = history.id.base64Decoded().replacingOccurrences(of: "RECENT", with: BattleMode(rawValue: history.vsMode.id).replacement).base64Encoded()
      if await !inkData.isExist(id: id){
        modeShouldSkip[BattleMode(rawValue: history.vsMode.id)] = false
      }
    }

    await self.loadFromNet(modeShouldSkip: modeShouldSkip)
//    await MainActor.run {
//      withAnimation {
//        self.fetching = false
//      }
//    }
    self.stats = .none
  }

  private func loadFromNet(modeShouldSkip:[BattleMode:Bool]) async {
    var allNodes:[GeneralBattleHistories.BriefDetail] = []
    for skip in modeShouldSkip {
      if skip.value {
        continue
      }

      guard let tempNodes = await inkNet.fetchBattleHistory(for: skip.key.fetchEnum)?.historyGroups.nodes, !tempNodes.isEmpty else { continue }
      for tempNode in tempNodes {
        if let his = tempNode.historyDetails.nodes {
          allNodes.append(contentsOf: his)
        }
      }
    }
    var needFetchNodes:[GeneralBattleHistories.BriefDetail] = []
    for node in allNodes {
      if await !self.inkData.isExist(id: node.id){
        needFetchNodes.append(node)
      }
    }
    let indicatorID = UUID().uuidString
    if needFetchNodes.count > 0{
        let style: Indicator.Style = .default
        let idtor:Indicator = Indicator(id: "\(indicatorID)",  headline: "获取\(needFetchNodes.count)个记录",dismissType:.triggered,style: style)
        DispatchQueue.main.async {
          self.indicator.display(idtor)
        }
    }
    await withTaskGroup(of: VsHistoryDetail?.self) { group in
      // 第二步：为每个node添加一个任务
      for node in needFetchNodes {
        group.addTask {
          return await self.inkNet.fetchVsHistoryDetail(id: node.id, udemae: node.udemae, paintPoint: node.myTeam.result?.paintPoint)
        }
      }

      // 第三步：处理结果
      for await result in group {
        if let completeDetail = result {
          await inkData.addBattle(detail: completeDetail)
          DispatchQueue.main.async {
            if self.rows.isEmpty || !self.battleCanGroup(current: self.rows[0][0], new: completeDetail) {
              withAnimation {
                self.rows.insert([completeDetail], at: 0)
              }
            } else {
              withAnimation {
                self.rows[0].insert(contentsOf: [completeDetail], at: 0)
              }
            }
          }
        }
      }
    }
    await indicator.dismiss(matching: indicatorID)
  }

  func loadFromData(length:Int, filter: FilterProps? = nil) async {
    let count = self.rows.flatMap { $0 }.count
    let offset = count
    let limit = length - count
    var read = 0
    var details:[VsHistoryDetail] = []
    while read < limit{
      details += await self.inkData.queryDetail(offset: offset+read,limit: min(limit-read,Int((Double(ProcessInfo.processInfo.physicalMemory) / 1024.0 / 1024.0 / 1024.0) * 150.0)), filter: filter)
      if self.rows.count < min(Int((Double(ProcessInfo.processInfo.physicalMemory) / 1024.0 / 1024.0 / 1024.0) * 150.0), limit-read){
        break
      }
      read += self.rows.count
    }

    let tempDetails = details
    DispatchQueue.main.async {
      withAnimation {
        for detail in tempDetails{
          if self.rows.isEmpty || !self.battleCanGroup(current: self.rows.last![0], new: detail){
            self.rows.append([detail])
          }else{
            self.rows[self.rows.count-1].append(detail)
          }
        }
      }
    }
  }




  private func battleCanGroup(current detail: VsHistoryDetail,new:VsHistoryDetail)->Bool{
    return detail.vsRule.rule == new.vsRule.rule && detail.vsMode == new.vsMode
  }
}

enum BattleMode:String,CaseIterable{
  case regular = "REGULAR"
  case anarchy = "BANKARA"
  case xMatch = "XMATCH"
  case league = "LEAGUE"
  case privateMatch =  "PRIVATE"

  init(rawValue: String) {
    switch rawValue {
    case "VnNNb2RlLTE=", "VnNNb2RlLTY=", "VnNNb2RlLTc=", "VnNNb2RlLTg=":
      self = .regular
    case "VnNNb2RlLTI=","VnNNb2RlLTUx":
      self = .anarchy
    case "VnNNb2RlLTM=":
      self = .xMatch
    case "VnNNb2RlLTQ=":
      self = .league
    case "VnNNb2RlLTU=":
      self = .privateMatch
    default:
      self = .regular
    }
  }
  var replacement:String{self.rawValue}

  var fetchEnum:InkNet.BattleHistoryFetchType{
    switch self {
    case .regular:
      return .Regular
    case .anarchy:
      return .Bankara
    case .xMatch:
      return .XMatch
    case .league:
      return .Event
    case .privateMatch:
      return .Private
    }
  }

  var icon:Image{
    switch self {
    case .regular:
      return Image(.turfWar)
    case .anarchy:
      return Image(.anarchy)
    case .xMatch:
      return  Image(.xBattle)
    case .league:
      return Image(.event)
    case .privateMatch:
      return Image(.private)
    }
  }

  var color:Color{
    switch self {
    case .regular:
      return Color.spLightGreen
    case .anarchy:
      return Color.spOrange
    case .xMatch:
      return Color.xBattleTheme
    case .league:
      return Color.spPink
    case .privateMatch:
      return Color.spPurple
    }
  }
}
