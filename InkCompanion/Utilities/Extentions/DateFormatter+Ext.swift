//
//  DateFormatter+Ext.swift
//  Ikalendar2
//
//  Copyright (c) 2023 TIANWEI ZHANG. All rights reserved.
//

import Foundation

extension DateFormatter {
  enum InkDateFormatterType {
    case time
    case date
  }
  convenience init(inkType: InkDateFormatterType) {
    self.init()

    locale = Locale.current

    switch inkType {
    case .time:
      dateFormat = "HH:mm"
    case .date:
      dateFormat = "MM/dd "
    }
  }
}
