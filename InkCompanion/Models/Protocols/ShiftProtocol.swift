//
//  ShiftProtocol.swift
//  InkCompanion
//
//  Created by 姜锋 on 11/10/23.
//

import Foundation

protocol Shift:Codable{
  var startTime:Date {get set}
  var endTime:Date {get set}
  var stage:Stage {get set}
  var weapons:[Weapon] {get set}
}
