//
//  InkFont.swift
//  InkCompanion
//
//  Created by 姜锋 on 11/12/23.
//


import SwiftUI

// MARK: - InkFont

enum InkFont: String {
  case font1 = "DFPZongYiW7"
  case Splatoon1 = "Splatoon2"
  case Splatoon2 = "Splatfont 1 v1.008"
}

extension View {
  /// A modifier function that quickly applies a custom ika font to the view.
  ///
  /// - Parameters:
  ///   - ikaFont: The type of the ika font.
  ///   - size: The size of the ika font.
  ///   - textStyle: The text style that this size is relative to.
  /// - Returns: The modified view.
  func inkFont(
    _ ikaFont: InkFont,
    size: CGFloat,
    relativeTo textStyle: Font.TextStyle)
    -> some View
  {
    modifier(
      InkFontTextStyle(
        ikaFont: ikaFont,
        size: size,
        textStyle: textStyle))
  }
}

// MARK: - InkFontTextStyle

struct InkFontTextStyle: ViewModifier {
  var ikaFont: InkFont
  var size: CGFloat
  var textStyle: Font.TextStyle

  func body(content: Content) -> some View {
    content
      .font(
        .custom(
          ikaFont.rawValue,
          size: size,
          relativeTo: textStyle))
  }
}
