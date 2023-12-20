//
//  Summable.swift
//  InkCompanion
//
//  Created by 姜锋 on 12/11/23.
//

import Foundation

protocol Summable {
    static func +(lhs: Self, rhs: Self) -> Self
  static var zero:Self { get  }
}

extension Summable {
    static func sum(of elements: [Self]) -> Self {
      return elements.reduce(self.zero, +)
    }
}
