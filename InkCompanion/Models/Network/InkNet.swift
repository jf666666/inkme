//
//  InkNetService.swift
//  InkCompanion
//
//  Created by 姜锋 on 11/15/23.
//

import Foundation
import Combine

extension CodingUserInfoKey {
    static let dynamicCodingKey = CodingUserInfoKey(rawValue: "dynamicCodingKey")!
}

final class InkNet {

  static let shared = InkNet()

  private init() {}

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
      let data =  try await fetchGraphQL(hash: kind.hash,decoder: decoder) as HistoriesQuery
      let detail = data.data.battleHistories
      return detail
    }catch let error as NSError{
      print("failed \(error): \(error.userInfo)")
      return nil
    }
  }

  func fetchCoopHistories() async -> CoopResult?{
    do {
      let data = try await fetchGraphQL(hash: .CoopHistoryQuery) as CoopHistories
      return data.data.coopResult
    }catch let error as NSError{
      print("failed \(error): \(error.userInfo)")
      return nil
    }
  }



  func fetchVsHistoryDetail(id:String) async ->VsHistoryDetail?{
    struct DetailQuery:Codable{
      struct Data:Codable{
        let vsHistoryDetail:VsHistoryDetail
      }
      let data:Data
    }
    do {
      let data =  try await fetchGraphQL(hash: .VsHistoryDetailQuery,variables: ["vsResultId": id]) as DetailQuery
      let detail = data.data.vsHistoryDetail
      return detail
    }catch let error as NSError{
      print("failed \(error): \(error.userInfo)")
      return nil
    }
  }

  func fetchCoopHistoryDetail(id:String,diff:CoopGradePointDiff) async -> CoopHistoryDetail?{
    do {
      let data =  try await fetchGraphQL(hash: .CoopHistoryDetailQuery,variables: ["coopHistoryDetailId": id]) as CoopHistoryDetailQuery
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
//      return try await fetchScheduleFromSplatoon3DotInk()
      return try await fetchGraphQL(hash: .StageScheduleQuery) as StageSchedules
    }catch let error as NSError{
      print("\(error) \(error.userInfo)")
      do{
          return try await fetchGraphQL(hash: .StageScheduleQuery) as StageSchedules
      }catch{
        return nil
      }
    }
  }

  private func fetchScheduleFromSplatoon3DotInk() async throws-> StageSchedules{
    var request = URLRequest(url: URL(string: "https://splatoon3.ink/data/schedules.json")!)
    request.timeoutInterval = 60
    request.addValue(USER_AGENT, forHTTPHeaderField: "User-Agent")
    let (data, _) = try await URLSession.shared.data(for: request)

    // 解析响应数据
    let result = try JSONDecoder().decode(StageSchedules.self, from: data)
    return result
  }

  func fetchFriend() async -> FriendListResult?{
    do {
      return try await fetchGraphQL(hash: .FriendListQuery) as FriendListResult
    }catch{
      return nil
    }
  }

  private func fetchGraphQL<T:Codable>(
    language:String? = "zh-CN",
    hash:RequestId,
    variables: [String:Any]? = nil,
    decoder:JSONDecoder? = nil
  ) async throws -> T{

    guard let webServiceToken:WebServiceTokenStruct = UserDefaultsManager.object(forKey: .WebServiceToken),let bulletToken = UserDefaultsManager.string(forKey: .BulletToken) else {
      throw NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "获取会话令牌失败"])
    }
    let body: [String: Any] = [
        "extensions": [
            "persistedQuery": [
                "sha256Hash": hash.rawValue,
                "version": 1
            ]
        ],
        "variables":variables ?? ""
    ]


    // 将请求体转换为 JSON 数据
    guard let jsonData = try? JSONSerialization.data(withJSONObject: body, options: []) else {
      throw NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "将请求体转换为 JSON 数据失败"])
    }

    // 创建请求
    var request = URLRequest(url: URL(string: "https://api.lp1.av5ja.srv.nintendo.net/api/graphql")!)
    request.httpMethod = "POST"
    request.httpBody = jsonData
    request.addValue("*/*", forHTTPHeaderField: "Accept")
    request.addValue("gzip, deflate", forHTTPHeaderField: "Accept-Encoding")
    request.addValue(language ?? "", forHTTPHeaderField: "Accept-Language")
    request.addValue("Bearer \(bulletToken)", forHTTPHeaderField: "Authorization")
    request.addValue(String(jsonData.count), forHTTPHeaderField: "Content-Length")
    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
    request.addValue("_dnt=0; _gtoken=\(webServiceToken.accessToken);", forHTTPHeaderField: "Cookie")
    request.addValue("https://api.lp1.av5ja.srv.nintendo.net", forHTTPHeaderField: "Origin")
    request.addValue("https://api.lp1.av5ja.srv.nintendo.net/?lang=\(language ?? "")&na_country=\(webServiceToken.country)&na_lang=\(webServiceToken.language)", forHTTPHeaderField: "Referer")
    request.addValue("empty", forHTTPHeaderField: "Sec-Fetch-Dest")
    request.addValue("cors", forHTTPHeaderField: "Sec-Fetch-Mode")
    request.addValue("same-origin", forHTTPHeaderField: "Sec-Fetch-Site")
    request.addValue("Mozilla/5.0 (Linux; Android 11; sdk_gphone_arm64 Build/RSR1.210722.013.A6; wv) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/91.0.4472.114 Mobile Safari/537.36", forHTTPHeaderField: "User-Agent")
    request.addValue("com.nintendo.znca", forHTTPHeaderField: "X-Requested-With")
    request.addValue(SPLATNET_VERSION, forHTTPHeaderField: "X-Web-View-Ver")
    // 发送请求
    let (data, _) = try await URLSession.shared.data(for: request)
    
    if let decoder = decoder{
      let result = try decoder.decode(T.self, from: data)
      return result
    }
    // 解析响应数据
    let result = try JSONDecoder().decode(T.self, from: data)
    return result
  }

private struct HistoriesQuery:Codable{
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
  var hash:RequestId{
    switch self {
    case .Latest:
      return .LatestBattleHistoriesQuery
    case .Bankara:
      return .BankaraBattleHistoriesQuery
    case .XMatch:
      return .XBattleHistoriesQuery
    case .Regular:
      return .RegularBattleHistoriesQuery
    case .Event:
      return .EventBattleHistoriesQuery
    case .Private:
      return .PrivateBattleHistoriesQuery
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

extension InkNet{
  private struct DynamicCodingKey: CodingKey {
    var stringValue: String
    var intValue: Int?

    init?(stringValue: String) {
      self.stringValue = stringValue
      self.intValue = nil
    }

    init?(intValue: Int) {
      self.stringValue = "\(intValue)"
      self.intValue = intValue
    }
  }
}
