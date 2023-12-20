//
//  StageTitleLabel.swift
//  InkCompanion
//
//  Created by 姜锋 on 12/1/23.
//

import SwiftUI

struct StageTitleLabel: View {
  typealias Scoped = Constants.Style.Rotation.Label

  let title: String
  let fontSize: CGFloat
  let relTextStyle: Font.TextStyle

  var body: some View {
    // 新地图会有一段时间没有名字，在这里处理
    if title != ""{
      Text(title)
        .scaledLimitedLine()
        .inkFont(.font1, size: fontSize, relativeTo: relTextStyle)
        .padding(.horizontal, Scoped.TEXT_PADDING_H)
        .padding(.vertical, Scoped.TEXT_PADDING_V)
        .background(.ultraThinMaterial)
        .cornerRadius(Scoped.BACKGROUND_CORNER_RADIUS)
    }else{
      EmptyView()
    }

  }
}
