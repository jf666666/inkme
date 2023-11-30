//
//  ScaledLimitedLine.swift
//  Ikalendar2
//
//  Copyright (c) 2023 TIANWEI ZHANG. All rights reserved.
//

import SwiftUI

extension View {
  /// A modifier that limits the text to a limited lines
  /// and automatically scales down if needed.
  ///
  /// - Parameters:
  ///   - lineLimit: The max number of lines (default to 1).
  ///   - minScaleFactor: The minimum scale factor of the text (default to 0.3).
  /// - Returns: The modified view.
  func scaledLimitedLine(
    lineLimit: Int = 1,
    minScaleFactor: CGFloat = 0.3)
    -> some View
  {
    modifier(
      ScaledLimitedLine(
        lineLimit: lineLimit,
        minScaleFactor: minScaleFactor))
  }
}

// MARK: - ScaledLimitedLine

struct ScaledLimitedLine: ViewModifier {
  var lineLimit: Int
  var minScaleFactor: CGFloat

  // MARK: Internal

  func body(content: Content) -> some View {
    content
      .lineLimit(lineLimit)
      .minimumScaleFactor(minScaleFactor)
  }
}
