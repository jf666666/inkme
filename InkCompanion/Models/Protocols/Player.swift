//
//  Player.swift
//  InkCompanion
//
//  Created by 姜锋 on 12/20/23.
//

import Foundation

protocol Player:Codable{
  var name: String {get set}
  var nameId: String {get set}
  var byname: String {get set}
  var nameplate: Nameplate {get set}
}
