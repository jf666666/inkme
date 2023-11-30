//
//  DateFormatter+Ext.swift
//  Ikalendar2
//
//  Copyright (c) 2023 TIANWEI ZHANG. All rights reserved.
//

import Foundation

extension DateFormatter {
  enum IkaDateFormatterType {
    case time
    case date
  }

  // MARK: Lifecycle

  /// A convenience init for some custom DateFormatter types.
  /// - Parameter ikaType: The custom type of the dateFormatter.
  convenience init(ikaType: IkaDateFormatterType) {
    self.init()

    locale = Locale.current

    switch ikaType {
    case .time:
      if locale.identifier.starts(with: "ja") {
        // Japanese
        dateFormat = "ah:mm"
      }
//      else if locale.identifier.starts(with: "zh_Hans") {
//        // Simplified Han
//        dateFormat = "a h:mm"
//      }
//      else if locale.identifier.starts(with: "zh_Hant") {
//        // Traditional Han
//        dateFormat = "a h:mm"
//      }
      else {
        // default: English
        dateFormat = "h:mm a"
      }
    case .date:
      if locale.identifier.starts(with: "ja") {
        // Japanese
        dateFormat = "M/d(E) "
      }
//      else if locale.identifier.starts(with: "zh_Hans") {
//        // Simplified Han
//        dateFormat = "ah:mm"
//      }
//
//      else if locale.identifier.starts(with: "zh_Hant") {
//        // Traditional Han
//        dateFormat = "ah:mm"
//      }
      else {
        // default: English
        dateFormat = "E, M/d, "
      }
    }
  }
}
