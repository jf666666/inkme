//
//  RotationProtocols.swift
//  InkCompanion
//
//  Created by 姜锋 on 11/9/23.
//



import Foundation

protocol Schedule:Identifiable,Equatable,Hashable {
  associatedtype Mode: CaseIterable
      associatedtype Rule: CaseIterable

  var mode:Mode {get set} //regular anarchy event x
  var rule:Rule {get set} // turf zone rainmaker tower...
  var startTime:Date {get set}
  var endTime:Date {get set}
  var stages:[Stage] {get set}
  var id:String {get}
}

extension Schedule {
  var id: String { "\(mode)-\(startTime)-\(endTime)" }

  /// Determines whether the rotation has expired based on the current time.
  func isExpired(_ currentTime: Date) -> Bool {
    endTime <= currentTime
  }

  /// Determines whether the rotation is currently active based on the current time.
  func isCurrent(_ currentTime: Date) -> Bool {
    startTime <= currentTime &&
      endTime > currentTime
  }

  /// Determines whether the rotation is scheduled for the future based on the current time.
  func isFuture(_ currentTime: Date) -> Bool {
    startTime > currentTime
  }
}



extension Schedule{
  static func == (lhs: Self, rhs: Self) -> Bool {
    lhs.hashValue == rhs.hashValue
  }

  func hash(into hasher: inout Hasher) {
    hasher.combine(id)
  }
}


