//
//  AppUserDefaults.swift
//  InkCompanion
//
//  Created by 姜锋 on 12/5/23.
//

import Foundation
import SwiftUI

class InkUserDefaults:ObservableObject{
  static let shared = InkUserDefaults()
  private init() {}

  @AppStorage("firstLaunch")
  var firstLaunch:Bool = true

  @AppStorage("NSOVersion")
  var NSOVersion:String = "2.9.0"

  @AppStorage("splatnet_version")
  var SplatNetVersion:String = "6.0.0-eb33aadc"

  @AppStorage("sessionToken")
  var sessionToken:String? {
    didSet{
      if oldValue != nil, sessionToken == nil{
        NotificationCenter.default.post(name: NSNotification.Name("Logout"), object: nil)
      }
    }
  }

  @AppStorage("currentUserKey")
  var currentUserKey:String?

  @AppStorage("inkPlayers")
  var inkPlayers:Data?

  @AppStorage("webServiceToken")
  var webServiceToken:Data?

  @AppStorage("bulletToken")
  var bulletToken:String?

  @StoredDate(key: "tokensLastRefreshTime")
  var tokensLastRefreshTime: Date?
  
  @AppStorage("currentLanguage")
  var currentLanguage:String = "zh_CN"
}


@propertyWrapper
struct StoredDate {
    let key: String
    let store: UserDefaults = UserDefaults.standard

    var wrappedValue: Date? {
        get {
            guard let timestamp = store.object(forKey: key) as? TimeInterval else {
                return nil
            }
            return Date(timeIntervalSince1970: timestamp)
        }
        set {
            if let newDate = newValue {
                store.set(newDate.timeIntervalSince1970, forKey: key)
            } else {
                store.removeObject(forKey: key)
            }
        }
    }
}
