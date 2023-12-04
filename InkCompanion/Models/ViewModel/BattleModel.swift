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
//    histories.map{ModeSelection(rawValue: $0.vsMode.id) == .anarchy}

    await withTaskGroup(of: VsHistoryDetail?.self) { group in
      for history in histories {
        let id = history.id.base64Decoded().replacingOccurrences(of: "RECENT", with: ModeSelection(rawValue: history.vsMode.id).replacement).base64Encoded()
        group.addTask {
          if await self.inkData.isExist(id: id){
            return nil
          }
          if let completeDetail = await self.inkNet.fetchVsHistoryDetail(id: id){
            return completeDetail
          }
          return nil
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

  private enum ModeSelection:String{
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
  }


  private func battleCanGroup(current detail: VsHistoryDetail,new:VsHistoryDetail)->Bool{
    return detail.vsRule.rule == new.vsRule.rule && detail.vsMode == new.vsMode
  }
}
