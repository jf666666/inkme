//
//  KeyChainStorage.swift
//  hailuowan
//  存储一些临时小的变量，如toke之类的
//  Created by 姜锋 on 10/31/23.
//

import Foundation
import Security

class KeychainManager {
  static func save(key: String, value: String) -> Bool {
    let query = [
      kSecClass as String: kSecClassGenericPassword as String,
      kSecAttrAccount as String: key,
      kSecValueData as String: value.data(using: .utf8)!
    ] as [String: Any]

    SecItemDelete(query as CFDictionary)  // 先删除旧值
    let status = SecItemAdd(query as CFDictionary, nil)
    return status == errSecSuccess
  }

  static func load(key: String) -> String? {
    let query = [
      kSecClass as String: kSecClassGenericPassword,
      kSecAttrAccount as String: key,
      kSecReturnData as String: kCFBooleanTrue!,
      kSecMatchLimit as String: kSecMatchLimitOne
    ] as [String: Any]

    var dataTypeRef: AnyObject?
    let status = SecItemCopyMatching(query as CFDictionary, &dataTypeRef)
    if status == errSecSuccess {
      if let data = dataTypeRef as? Data {
        return String(data: data, encoding: .utf8)
      }
    }
    return nil
  }
}





struct UserDefaultsManager {

  enum Keys:String {
    case SessionToken = "sessionToken2"
    case WebServiceToken = "webServiceToken2"
    case BulletToken = "bulletToken2"
    case Language = "language"
    case Icon = "icon"
    case CatalogLevel = "catalogLevel"
    case Level = "level"
    case Rank = "rank"
    case SplatZonesXPower = "splatZonesXPower"
    case TowerControlXPower = "towerControlXPower"
    case RainmakerXPower = "rainmakerXPower"
    case ClamBlitzXPower = "clamBlitzXPower"
    case Grade = "grade"
    case PlayedTime = "playedTime"
    case Filter = "filter"
    case BackgroundRefresh = "backgroundRefresh"
    case SalmonRunFriendlyMode = "salmonRunFriendlyMode"
    case AutoRefresh = "autoRefresh"
    case LastRefreshTime = "lastRefreshTime"
    case WebSessionTokenAccessToken = "WebSessionTokenAccessToken"
    case WebSessionTokenCountry = "WebSessionTokenCountry"
    case WebSessionTokenLanguage = "WebSessionTokenLanguage"
  }
  // 存储基本数据类型
  static func set<T>(value: T, forKey key: Keys) where T: Any {
    UserDefaults.standard.set(value, forKey: key.rawValue)
  }

  static func set<T: Codable>(object: T, forKey key: Keys) {
    let encoder = JSONEncoder()
    do {
      let encoded = try encoder.encode(object)
      UserDefaults.standard.set(encoded, forKey: key.rawValue)
    } catch {
      print("Failed to encode object: \(error)")
    }
  }

  static func string(forKey key: Keys) -> String? {
    UserDefaults.standard.string(forKey: key.rawValue)
  }

  static func integer(forKey key: Keys) -> Int {
    UserDefaults.standard.integer(forKey: key.rawValue)
  }

  static func bool(forKey key: Keys) -> Bool {
    UserDefaults.standard.bool(forKey: key.rawValue)
  }

  static func date(forkey key: Keys)->Date{
    UserDefaults.standard.object(forKey: key.rawValue) as? Date ?? Date.distantPast
  }

  static func object<T: Codable>(forKey key: Keys) -> T? {
    if let data = UserDefaults.standard.data(forKey: key.rawValue) {
      let decoder = JSONDecoder()
      do {
        let object = try decoder.decode(T.self, from: data)
        return object
      } catch {
        print("Failed to decode object: \(error)")
      }
    }
    return nil
  }

  static func clear(forKey key: Keys) {
    UserDefaults.standard.removeObject(forKey: key.rawValue)
  }

  static func isSet(forKey key: String) -> Bool {
    UserDefaults.standard.object(forKey: key) != nil
  }
}


