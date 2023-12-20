//
//  StageCard.swift
//  InkCompanion
//
//  Created by 姜锋 on 12/1/23.
//


import SwiftUI
import Kingfisher

struct BattleStageCard:View {
  typealias Scoped = Constants.Style.Rotation.Battle.Card.Primary

  let stage:Stage
  var s:StageSelection{StageSelection.getStageSelection(from: stage.id)}
  var body: some View {
    s.image
      .resizable()
      .antialiased(true)
      .continuousCornerRadius(8)
      .scaledToFit()
      .overlay(
        StageTitleLabel(
          title: s.name,
          fontSize: Scoped.LABEL_FONT_SIZE,
          relTextStyle: .body)
        .padding(.leading, Scoped.LABEL_PADDING_LEADING)
        .padding([.bottom, .trailing], Scoped.LABEL_PADDING_BOTTOMTRAILING),
        alignment: .bottomTrailing)
      .animation(.snappy, value: true)

  }
}
