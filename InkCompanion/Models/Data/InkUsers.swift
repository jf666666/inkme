//
//  Users.swift
//  InkCompanion
//
//  Created by 姜锋 on 12/6/23.
//

import Foundation

struct User:Codable{
  var key:String
  var sessionToken:String
  var avatarUrl:String
  var playerName:String
  var lastRefreshTime:Date
}

struct InkPlayers:Codable{
  var users:[User]
}

