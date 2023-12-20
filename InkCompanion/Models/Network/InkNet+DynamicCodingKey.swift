//
//  InkNet+DynamicCodingKey.swift
//  InkCompanion
//
//  Created by 姜锋 on 12/8/23.
//

import Foundation

extension InkNet{
  struct DynamicCodingKey: CodingKey {
    var stringValue: String
    var intValue: Int?

    init?(stringValue: String) {
      self.stringValue = stringValue
      self.intValue = nil
    }

    init?(intValue: Int) {
      self.stringValue = "\(intValue)"
      self.intValue = intValue
    }
  }
}

extension CodingUserInfoKey {
  static let dynamicCodingKey = CodingUserInfoKey(rawValue: "dynamicCodingKey")!
}
