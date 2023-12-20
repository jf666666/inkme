//
//  LoginAPI.swift
//  hailuowan
//
//  Created by 姜锋 on 10/31/23.
//


import Foundation
import CryptoKit
import AuthenticationServices
import SwiftyJSON
import CoreData




func digestString(_ input: String) -> String? {
  guard let inputData = input.data(using: .utf8) else { return nil }
  let hashed = SHA256.hash(data: inputData)
  return Data(hashed).base64EncodedString()
}

func shouldUpdate()->Bool{
  guard let lastUpdate = InkUserDefaults.shared.tokensLastRefreshTime else {return true}
  let currentTime = Date()
  let updateInterval = 1 * 60 * 60 // 1小时

  if currentTime.timeIntervalSince(lastUpdate) > TimeInterval(updateInterval) {
    return true
  }
  return false
}

// 用于生成随机字节的辅助函数
struct SecureRandomNumberGenerator {
  static func randomBytes(count: Int) throws -> Data {
    var randomBytes = [UInt8](repeating: 0, count: count)
    let status = SecRandomCopyBytes(kSecRandomDefault, count, &randomBytes)
    if status == errSecSuccess {
      return Data(randomBytes)
    } else {
      throw NSError(domain: NSOSStatusErrorDomain, code: Int(status))
    }
  }
}


func randomBytesBase64Encoded(count: Int) -> String {
  var randomBytes = [UInt8](repeating: 0, count: count)
  let _ = SecRandomCopyBytes(kSecRandomDefault, count, &randomBytes)
  return Data(randomBytes).base64EncodedString()
}


func getParam(from url: URL, param: String) -> String? {
  // 将片段参数转换为查询参数的形式
  guard let components = URLComponents(url: url, resolvingAgainstBaseURL: false) else { return nil }
  var combinedQuery = components.query ?? ""
  if let fragment = components.fragment {
    combinedQuery += "&" + fragment
  }

  // 解析查询参数
  guard let queryItems = URLComponents(string: "?" + combinedQuery)?.queryItems else { return nil }
  return queryItems.first(where: { $0.name == param })?.value
}


struct WebServiceTokenStruct: Codable {
  let accessToken: String
  let country: String
  let language: String
}



func httpAcceptLanguageFormat() -> String? {
  if let languageCode = Locale.current.language.languageCode?.identifier, let regionCode = Locale.current.region?.identifier {
    return "\(languageCode)-\(regionCode)"
  } else if let languageCode = Locale.current.language.languageCode?.identifier {
    return languageCode
  }
  return nil
}
