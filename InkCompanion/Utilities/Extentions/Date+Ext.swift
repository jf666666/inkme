//
//  Date+Ext.swift
//  Ikalendar2
//
//  Copyright (c) 2023 TIANWEI ZHANG. All rights reserved.
//

import Foundation
import SwiftUI

//extension Date {
//  /// Get the TimeInterval between two Dates.
//  /// - Parameters:
//  ///   - lhs: The date to be subtracted from.
//  ///   - rhs: The date to subtracted.
//  /// - Returns: The difference of the two Dates in TimeInterval format.
//  static func - (
//    lhs: Date,
//    rhs: Date)
//    -> TimeInterval
//  {
//    lhs.timeIntervalSinceReferenceDate - rhs.timeIntervalSinceReferenceDate
//  }
//}

extension Date {
  /// Strip the minutes and below components of the Date.
  /// - Returns: The stripped Date.
  func removeMinutes() -> Date? {
    let components = Calendar.current.dateComponents([.year, .month, .day, .hour], from: self)
    return Calendar.current.date(from: components)
  }
}

extension Date {
  static private let ikaTimeFormatter = DateFormatter(ikaType: .time)
  static private let ikaDateFormatter = DateFormatter(ikaType: .date)

  // MARK: Internal

  /// Convert the Date to a battle time string.
  /// - Parameters:
  ///   - shouldIncludeDate: If including the date in the time string (default to false).
  ///   parameter has changed.
  /// - Returns: The battle time string.
  func toBattleTimeString(includeDateIf shouldIncludeDate: Bool = false)
    -> String
  {
    let timeString = Date.ikaTimeFormatter.string(from: self)

    guard shouldIncludeDate
    else { return timeString }

    guard !Calendar.current.isDateInToday(self)
    else { return String(localized: "Today") + " " + timeString }

    guard !Calendar.current.isDateInYesterday(self)
    else { return String(localized: "Yesterday") + " " + timeString }

    guard !Calendar.current.isDateInTomorrow(self)
    else { return String(localized: "Tomorrow") + " " + timeString }

    // should not happen, but in case other than Today, Yesterday or Tomorrow
    return timeString
  }

  /// Convert the Date to a salmon time string.
  /// - Parameters:
  ///   - shouldIncludeDate: If including the date in the time string (default to false).
  ///   parameter has changed.
  /// - Returns: The salmon time string.
  func toSalmonTimeString(includeDateIf shouldIncludeDate: Bool = false)
    -> String
  {
    let timeString = Date.ikaTimeFormatter.string(from: self)

    guard shouldIncludeDate
    else { return timeString }

    guard !Calendar.current.isDateInToday(self)
    else { return String(localized: "Today") + " " + timeString }

    guard !Calendar.current.isDateInYesterday(self)
    else { return String(localized: "Yesterday") + " " + timeString }

    guard !Calendar.current.isDateInTomorrow(self)
    else { return String(localized: "Tomorrow") + " " + timeString }

    // other than Today, Yesterday or Tomorrow
    let dateString = Date.ikaDateFormatter.string(from: self)
    return dateString + timeString
  }

  /// Convert a Date to the string key for the remaining time.
  /// - Parameter deadline: The deadline to compute the remaining time from.
  /// - Returns: The string key for remaining time.
  func toTimeRemainingStringKey(until deadline: Date) -> LocalizedStringKey {
    let remainingTime = Int(deadline - self)
    // if time has already passed
    if remainingTime < 0 { return "Time's Up" }
    // convert time interval to TimeLength
    let days = remainingTime / (24 * 60 * 60)
    let hours = (remainingTime / (60 * 60)) % 24
    let minutes = (remainingTime / 60) % 60
    let seconds = remainingTime % 60
    let timeLength = TimeLength(days: days, hours: hours, minutes: minutes, seconds: seconds)
    let timeLengthString = timeLength.getLocalizedDescriptionString()

    return "remaining \(timeLengthString)"
  }

  /// Convert a Date to the string key for the until time.
  /// - Parameter deadline: The deadline to compute the remaining time from.
  /// - Returns: The string key for until time.
  func toTimeUntilStringKey(until deadline: Date) -> LocalizedStringKey {
    let untilTime = Int(deadline - self)
    // if time has already passed
    if untilTime < 0 { return "Time's Up" }
    // convert time interval to TimeLength
    let days = untilTime / (24 * 60 * 60)
    let hours = (untilTime / (60 * 60)) % 24
    let minutes = (untilTime / 60) % 60
    let seconds = untilTime % 60
    let timeLength = TimeLength(days: days, hours: hours, minutes: minutes, seconds: seconds)
    let timeLengthString = timeLength.getLocalizedDescriptionString()

    return "\(timeLengthString) until"
  }

  func toPlayedTimeString(full:Bool = false) -> String {
    let calendar = Calendar.current
    let now = Date()

    let formatter = DateFormatter()

    if calendar.isDateInToday(self) {
      // 如果是当天，只显示小时和分钟
      formatter.dateFormat = "HH:mm"
    } else if calendar.isDate(self, equalTo: now, toGranularity: .year) {
      // 如果是当年，不显示年份
      formatter.dateFormat = "MM/dd HH:mm"
    } else {
      // 其他情况，显示完整日期
      formatter.dateFormat = "yyyy MM/dd HH:mm"
    }
    if full{
      formatter.dateFormat = "yyyy MM/dd HH:mm"
    }
    return formatter.string(from: self)
  }
}
