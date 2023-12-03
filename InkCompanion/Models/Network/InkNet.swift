//
//  InkNetService.swift
//  InkCompanion
//
//  Created by 姜锋 on 11/15/23.
//

import Foundation
import Combine


final class InkNet {

  static let shared = InkNet()

  private init() {}

  func fetchCoopHistories() async -> CoopResult?{
    do {
      let data = try await fetchGraphQL(hash: .CoopHistoryQuery) as CoopHistories
      return data.data.coopResult
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
      return try await fetchGraphQL(hash: .StageScheduleQuery) as StageSchedules
    }catch let error as NSError{
      print("\(error) \(error.userInfo)")
      return nil
    }
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
    variables: [String:Any]? = nil
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

    // 解析响应数据
    let result = try JSONDecoder().decode(T.self, from: data)
    return result
  }

}

