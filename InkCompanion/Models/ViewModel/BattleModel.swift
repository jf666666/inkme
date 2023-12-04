//
//  BattleModel.swift
//  InkCompanion
//
//  Created by 姜锋 on 12/4/23.
//

import Foundation
import SwiftUI

class BattleModel:ObservableObject{
  @Published var rows:[[VsHistoryDetail]] = []
  @Published var fetching:Bool = false
  private let inkNet = InkNet.shared
  private let inkData = InkData.shared

  enum Stats {
    case refreshing
    case none
  }

  var ruleFilter:FilterProps = FilterProps(modes: ["salmon_run"], inverted: true)

  var stats:Stats = .none

  func loadFromNet() async {
    if self.stats == .refreshing{
      return
    }
    self.stats = .refreshing
    guard let histories = await inkNet.fetchBattleHistory(for: .Latest)?.historyGroups.nodes?[0].historyDetails.nodes else {return}
    var modeShouldSkip:[ModeSelection:Bool] = [:]
    for mode in ModeSelection.allCases{
      modeShouldSkip[mode] = true
    }
    for history in histories {
      let id = history.id.base64Decoded().replacingOccurrences(of: "RECENT", with: ModeSelection(rawValue: history.vsMode.id).replacement).base64Encoded()
      if await !inkData.isExist(id: id){
        modeShouldSkip[ModeSelection(rawValue: history.vsMode.id)] = false
      }
    }

    await self.loadFromNet(modeShouldSkip: modeShouldSkip)
    await MainActor.run {
      withAnimation {
        self.fetching = false
      }
    }
    self.stats = .none
  }

  private func loadFromNet(modeShouldSkip:[ModeSelection:Bool]) async {
    await withTaskGroup(of: VsHistoryDetail?.self) { group in
      DispatchQueue.main.async {
        withAnimation {
          self.fetching = true
        }
      }
      for skip in modeShouldSkip{
        if skip.value{
          continue
        }

        guard let tempNodes = await inkNet.fetchBattleHistory(for: skip.key.fetchEnum)?.historyGroups.nodes, !tempNodes.isEmpty, let his = tempNodes[0].historyDetails.nodes else {continue}
        for h in his{
          group.addTask {
            if await self.inkData.isExist(id: h.id){
              return nil
            }
            if let completeDetail = await self.inkNet.fetchVsHistoryDetail(id: h.id){
              return completeDetail
            }
            return nil
          }
        }
      }

      for await result in group{
        if let completeDetail = result{
          await inkData.addBattle(detail: completeDetail)
          DispatchQueue.main.async {
            if self.rows.isEmpty || !self.battleCanGroup(current: self.rows[0][0], new: completeDetail){
              withAnimation {
                self.rows.insert([completeDetail], at: 0)
              }
            }else{
              withAnimation {
                self.rows[0].insert(contentsOf: [completeDetail])
              }
            }
          }
        }
      }



    }
  }

  func loadFromData(length:Int, filter: FilterProps? = nil)async {
    let count = self.rows.flatMap { $0 }.count
    let offset = count
    let limit = length - count
    var read = 0
    var details:[VsHistoryDetail] = []
    while read < limit{
      details += await self.inkData.queryDetail(offset: offset+read,limit: min(limit-read,BATCH_SIZE), filter: filter)
      if self.rows.count < min(BATCH_SIZE, limit-read){
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

  private enum ModeSelection:String,CaseIterable{
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
  }


  private func battleCanGroup(current detail: VsHistoryDetail,new:VsHistoryDetail)->Bool{
    return detail.vsRule.rule == new.vsRule.rule && detail.vsMode == new.vsMode
  }
}
