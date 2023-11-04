//
//  KeyChainStorage.swift
//  hailuowan
//  存储一些临时小的变量，如toke之类的
//  Created by 姜锋 on 10/31/23.
//

import Foundation
// 定义一个键，用于在UserDefaults中存储和检索值
struct Keys {
    static let SessionToken = "sessionToken2"
    static let WebServiceToken = "webServiceToken2"
    static let BulletToken = "bulletToken2"
    static let Language = "language"
    static let Icon = "icon"
    static let CatalogLevel = "catalogLevel"
    static let Level = "level"
    static let Rank = "rank"
    static let SplatZonesXPower = "splatZonesXPower"
    static let TowerControlXPower = "towerControlXPower"
    static let RainmakerXPower = "rainmakerXPower"
    static let ClamBlitzXPower = "clamBlitzXPower"
    static let Grade = "grade"
    static let PlayedTime = "playedTime"
    static let Filter = "filter"
    static let BackgroundRefresh = "backgroundRefresh"
    static let SalmonRunFriendlyMode = "salmonRunFriendlyMode"
    static let AutoRefresh = "autoRefresh"
    static let LastRefreshTime = "lastRefreshTime"
}



struct UserDefaultsManager {
    // 存储基本数据类型
    static func set<T>(value: T, forKey key: String) where T: Any {
        UserDefaults.standard.set(value, forKey: key)
    }

    // 存储遵循 Codable 协议的结构体
    static func set<T: Codable>(object: T, forKey key: String) {
        let encoder = JSONEncoder()
        do {
            let encoded = try encoder.encode(object)
            UserDefaults.standard.set(encoded, forKey: key)
        } catch {
            print("Failed to encode object: \(error)")
        }
    }

    // 检索基本数据类型
    static func string(forKey key: String) -> String? {
        UserDefaults.standard.string(forKey: key)
    }

    static func integer(forKey key: String) -> Int {
        UserDefaults.standard.integer(forKey: key)
    }

    static func bool(forKey key: String) -> Bool {
        UserDefaults.standard.bool(forKey: key)
    }
    
    static func date(forkey key: String)->Date{
        UserDefaults.standard.object(forKey: Keys.LastRefreshTime) as? Date ?? Date.distantPast
    }

    // 从 UserDefaults 中读取遵循 Codable 协议的结构体
    static func object<T: Codable>(forKey key: String, castTo type: T.Type) -> T? {
        if let data = UserDefaults.standard.data(forKey: key) {
            let decoder = JSONDecoder()
            do {
                let object = try decoder.decode(type, from: data)
                return object
            } catch {
                print("Failed to decode object: \(error)")
            }
        }
        return nil
    }

    // 清除值
    static func clear(forKey key: String) {
        UserDefaults.standard.removeObject(forKey: key)
    }

    // 检查值是否存在
    static func isSet(forKey key: String) -> Bool {
        UserDefaults.standard.object(forKey: key) != nil
    }
}


// 使用示例
//UserDefaultsManager.set(value: "someToken", forKey: Keys.WebServiceToken)
//let token = UserDefaultsManager.string(forKey: Keys.WebServiceToken)
//UserDefaultsManager.clear(forKey: Keys.WebServiceToken)
//let isTokenSet = UserDefaultsManager.isSet(forKey: Keys.WebServiceToken)
