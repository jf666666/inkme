//
//  InkNetService.swift
//  InkCompanion
//
//  Created by 姜锋 on 11/15/23.
//

import Foundation
import Combine
import OSLog


final class InkNet {

  static let shared = InkNet()

  let logger = Logger(.custom(InkNet.self))

  private init() {}

  var sessionToken:String?
  var webServiceToken:WebServiceTokenStruct?
  var bulletToken:String?

  enum BattleHistoryFetchType{
    case Latest
    case Bankara
    case XMatch
    case Regular
    case Event
    case Private
  }

  func fetchBattleHistory(for kind:BattleHistoryFetchType) async ->GeneralBattleHistories?{
    do {
      let decoder = JSONDecoder()
      decoder.userInfo[.dynamicCodingKey] = kind.key
      let data =  try await fetchGraphQL(graphql: kind.graphql, decoder: decoder) as HistoriesQuery
      let detail = data.data.battleHistories
      return detail
    }catch let error as NSError{
      logger.error("\(#fileID)->\(#line)->\(#function) Failed: \(error.localizedDescription)")
      return nil
    }
  }

  func fetchCoopHistories() async -> CoopResult?{
    do {
      let data:CoopHistories = try await fetchGraphQL(graphql: .coopHistory)
      return data.data.coopResult
    }catch let error as NSError{
      logger.error("\(#fileID)->line:\(#line)->\(#function) Failed: \(error.localizedDescription)")
            return nil
    }
  }
  
  func fetchHistoryRecord() async -> HistoryRecordQuery?{
    do {
      let data:HistoryRecordQuery = try await fetchGraphQL(graphql: .HistoryRecord)
      return data
    }catch let error as NSError{
      logger.error("\(#fileID)->line:\(#line)->\(#function) Failed: \(error.localizedDescription)")
            return nil
    }
  }

  func fetchVsHistoryDetail(id:String,udemae:String? = nil, paintPoint:Double? = 0) async ->VsHistoryDetail?{
    struct DetailQuery:Codable{
      struct Data:Codable{
        let vsHistoryDetail:VsHistoryDetail
      }
      let data:Data
    }
    do {
      let data =  try await fetchGraphQL(graphql: .vsHistoryDetail(id: id)) as DetailQuery
      var detail = data.data.vsHistoryDetail
      if let udemae = udemae{
        detail.udemae = udemae
      }
      if let paintPoint = paintPoint{
        detail.myTeam.result?.paintPoint = paintPoint
      }
      return detail
    }catch let error as NSError{
      print("failed \(error): \(error.userInfo)")
      return nil
    }
  }


  func fetchCoopHistoryDetail(id:String,diff:CoopGradePointDiff) async -> CoopHistoryDetail?{
    do {
      let data:CoopHistoryDetailQuery = try await fetchGraphQL(graphql: .coopHistoryDetail(id: id))
      var detail = data.data.coopHistoryDetail
      detail.gradePointDiff = diff
      return detail
    }catch let error as NSError{
      print("failed \(error): \(error.userInfo)")
      return nil
    }

  }

  func fetchSchedule() async->StageSchedules?{
    do{
      return try await fetchScheduleFromSplatoon3DotInk()
    }catch let error as NSError{
      print("\(error) \(error.userInfo)")
      do{
        return try await fetchGraphQL(graphql: .StageSchedule) as StageSchedules
      }catch{
        return nil
      }
    }
  }

  private func fetchScheduleFromSplatoon3DotInk() async throws-> StageSchedules{
    var request = URLRequest(url: URL(string: "https://splatoon3.ink/data/schedules.json")!)
    request.timeoutInterval = 60
//    request.addValue(USER_AGENT, forHTTPHeaderField: "User-Agent")
    let (data, _) = try await URLSession.shared.data(for: request)

    // 解析响应数据
    let result = try JSONDecoder().decode(StageSchedules.self, from: data)
    return result
  }

  func fetchCoopRecord() async -> CoopRecord?{
    do{
      let data:CoopRecordQuery = try await fetchGraphQL(graphql: .CoopRecord)
      return data.data.coopRecord
    }catch{
      logger.error("InkNet.\(#function): \(error.localizedDescription)")
      return nil
    }
  }

  func fetchFriend() async -> FriendListResult?{
    do {
      return try await fetchGraphQL(graphql: .FriendList) as FriendListResult
    }catch{
      logger.error("\(#fileID)->\(#line)->\(#function)->\(error.localizedDescription)")
      return nil
    }
  }
  
  private func fetchGraphQL<T:Codable>(graphql:GraphQL, decoder:JSONDecoder? = nil) async throws -> T{

    guard let webServiceToken = self.webServiceToken, let bulletToken = self.bulletToken else {
      logger.error("InkNet的webServiceToken和bulletToken未初始化")
      throw NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "获取会话令牌失败"])
    }
    let api = Splatoon3API.graphQL(type: graphql, bulletToken: bulletToken, language: "zh-CN", webServiceToken: webServiceToken)
    guard let request = api.urlLRequest else {
      logger.error("InkNet的webServiceToken和bulletToken未初始化")
      throw NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "获取会话令牌失败"])
    }
    let (data, _) = try await URLSession.shared.data(for: request)
    if let decoder = decoder{
      let result = try decoder.decode(T.self, from: data)
      return result
    }
    // 解析响应数据
    let result = try JSONDecoder().decode(T.self, from: data)
    return result
  }



  struct HistoriesQuery:Codable{
    struct Data:Codable{
      let battleHistories:GeneralBattleHistories
      init(from decoder: Decoder) throws {
        guard let codingKey = decoder.userInfo[.dynamicCodingKey] as? String else {
          throw DecodingError.dataCorrupted(DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Dynamic coding key not found"))
        }

        let container = try decoder.container(keyedBy: DynamicCodingKey.self)
        self.battleHistories = try container.decode(GeneralBattleHistories.self, forKey: DynamicCodingKey(stringValue: codingKey)!)
      }
    }
    let data:Data
  }
}


extension InkNet.BattleHistoryFetchType{
  var graphql:GraphQL{
    switch self {
    case .Latest:
      return .LatestBattleHistory
    case .Bankara:
      return .BankaraBattleHistory
    case .XMatch:
      return .XMatchBattleHistory
    case .Regular:
      return .RegularBattleHistory
    case .Event:
      return .EventBattleHistory
    case .Private:
      return .PrivateBattleHistory
    }
  }

  var key:String{
    switch self {
    case .Latest:
      return "latestBattleHistories"
    case .Bankara:
      return "bankaraBattleHistories"
    case .XMatch:
      return "xBattleHistories"
    case .Regular:
      return "regularBattleHistories"
    case .Event:
      return "eventBattleHistories"
    case .Private:
      return "privateBattleHistories"
    }
  }
}




