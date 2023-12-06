//
//  Users.swift
//  InkCompanion
//
//  Created by 姜锋 on 12/6/23.
//

import Foundation

struct InkPlayer:Codable{
  var id:Int64
  var sessionToken:String
  var avatarUrl:String
  var name:String
  var lastRefreshTime:Date
  var friendCode:String
}

struct InkPlayers:Codable{
  var inkPlayers:[InkPlayer]
}


