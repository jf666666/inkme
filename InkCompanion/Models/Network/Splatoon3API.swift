//
//  Splatoon3API.swift
//  InkCompanion
//
//  Created by 姜锋 on 12/15/23.
//

import Foundation

enum Splatoon3API {
  case graphQL(type:GraphQL,
               bulletToken:String,
               language:String,
               webServiceToken:WebServiceTokenStruct
  )
  case bulletToken(WebServiceToken:WebServiceTokenStruct, language:String)
}

extension Splatoon3API: APITargetType {
  var baseURL: URL {
    switch self {
    case .graphQL, .bulletToken:
      URL(string:"https://api.lp1.av5ja.srv.nintendo.net/api")!
    }
  }

  var path: String {
    switch self {
    case .graphQL:
      "/graphql"
    case .bulletToken:
      "/bullet_tokens"
    }
  }

  var method: APIMethod {
    switch self {
    case .graphQL, .bulletToken:
        .post
    }
  }

  var headers: [String : String]? {
    switch self {
    case .graphQL(_, let bulletToken, let language, let webServiceToken):
      return [
        "Accept": "*/*",
        "Accept-Encoding": "gzip, deflate",
        "Accept-Language": language,
        "Authorization": "Bearer \(bulletToken)",
        "Content-Type": "application/json",
        "Cookie": "_dnt=0; _gtoken=\(webServiceToken.accessToken);",
        "Origin": "https://api.lp1.av5ja.srv.nintendo.net",
        "Referer": "https://api.lp1.av5ja.srv.nintendo.net/?lang=\(language)&na_country=\(webServiceToken.country)&na_lang=\(webServiceToken.language)",
        "Sec-Fetch-Dest": "empty",
        "Sec-Fetch-Mode": "cors",
        "Sec-Fetch-Site": "same-origin",
        "User-Agent": "Mozilla/5.0 (Linux; Android 11; sdk_gphone_arm64 Build/RSR1.210722.013.A6; wv) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/91.0.4472.114 Mobile Safari/537.36",
        "X-Requested-With": "com.nintendo.znca",
        "X-Web-View-Ver": InkUserDefaults.shared.SplatNetVersion
      ]
    case .bulletToken(let webServiceToken, let language):
      return [
        "Accept": "*/*",
        "Accept-Encoding": "gzip, deflate",
        "Accept-Language": language,
        "Content-Type": "application/json",
        "Cookie": "_dnt=0; _gtoken=\(webServiceToken.accessToken);",
        "Origin": "https://api.lp1.av5ja.srv.nintendo.net",
        "Referer": "https://api.lp1.av5ja.srv.nintendo.net/?lang=\(language)&na_country=\(webServiceToken.country)&na_lang=\(webServiceToken.language)",
        "Sec-Fetch-Dest": "empty",
        "Sec-Fetch-Mode": "cors",
        "Sec-Fetch-Site": "same-origin",
        "User-Agent": "Mozilla/5.0 (Linux; Android 11; sdk_gphone_arm64 Build/RSR1.210722.013.A6; wv) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/91.0.4472.114 Mobile Safari/537.36",
        "X-NACOUNTRY":webServiceToken.country,
        "X-Requested-With": "com.nintendo.znca",
        "X-Web-View-Ver": InkUserDefaults.shared.SplatNetVersion
      ]
    }
  }

  var querys: [(String, String?)]? {
    switch self {
    case .graphQL:
      nil
    case .bulletToken:
      nil
    }
  }

  var data: MediaType? {
    switch self {
    case .graphQL(let type,_,_,_):
      let requestBody = GraphQLRequestBody(
        extensions: .init(
          persistedQuery: .init(
            sha256Hash: type.hash.rawValue,
            version: 1
          )
        ),
        variables: type.variables
      )
      return .jsonData(requestBody)
    case .bulletToken:
      return nil
    }
  }

}

enum GraphQL {
  case vsHistoryDetail(id:String)
  case coopHistoryDetail(id:String)
  case coopHistory
  case LatestBattleHistory
  case BankaraBattleHistory
  case XMatchBattleHistory
  case RegularBattleHistory
  case EventBattleHistory
  case PrivateBattleHistory
  case CoopRecord
  case StageSchedule
  case FriendList
  case HistoryRecord
}

extension GraphQL {
  var hash: RequestId {
    switch self {
    case .vsHistoryDetail:
      return .VsHistoryDetailQuery
    case .coopHistoryDetail:
      return .CoopHistoryDetailQuery
    case .coopHistory:
      return .CoopHistoryQuery
    case .LatestBattleHistory:
      return .LatestBattleHistoriesQuery
    case .BankaraBattleHistory:
      return .BankaraBattleHistoriesQuery
    case .XMatchBattleHistory:
      return .XBattleHistoriesQuery
    case .RegularBattleHistory:
      return .RegularBattleHistoriesQuery
    case .EventBattleHistory:
      return .EventBattleHistoriesQuery
    case .PrivateBattleHistory:
      return .PrivateBattleHistoriesQuery
    case .CoopRecord:
      return .CoopRecordQuery
    case .StageSchedule:
      return .StageScheduleQuery
    case .FriendList:
      return .FriendListQuery
    case .HistoryRecord:
      return .HistoryRecordQuery
    }
  }

  var variables:[String:String]?{
    switch self {
    case .vsHistoryDetail(let id):
      return ["vsResultId":id]
    case .coopHistoryDetail(let id):
      return ["coopHistoryDetailId":id]
    default:
      return nil
    }
  }
}


struct GraphQLRequestBody: Encodable {
  let extensions: Extensions
  let variables: [String: Encodable]?

  struct Extensions: Encodable {
    let persistedQuery: PersistedQuery

    struct PersistedQuery: Encodable {
      let sha256Hash: String
      let version: Int
    }
  }

  func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encode(extensions, forKey: .extensions)

    // 特别处理 variables，因为它是 [String: Encodable] 类型
    if let variables = variables {
      var variablesContainer = container.nestedContainer(keyedBy: DynamicCodingKey.self, forKey: .variables)
      for (key, value) in variables {
        let codingKey = DynamicCodingKey(stringValue: key)!
        try value.encode(to: variablesContainer.superEncoder(forKey: codingKey))
      }
    }
  }

  private struct DynamicCodingKey: CodingKey {
    var stringValue: String
    var intValue: Int?

    init?(stringValue: String) {
      self.stringValue = stringValue
    }

    init?(intValue: Int) {
      self.intValue = intValue
      self.stringValue = "\(intValue)"
    }
  }

  private enum CodingKeys: String, CodingKey {
    case extensions, variables
  }
}
