//
//  StageCard.swift
//  InkCompanion
//
//  Created by 姜锋 on 12/1/23.
//


import SwiftUI
import Kingfisher

struct StageCard:View {
  typealias Scoped = Constants.Style.Rotation.Battle.Card.Primary

  let stage:Stage
  var body: some View {
    KFImage(URL(string: stage.image?.url ?? ""))
      .resizable()
      .antialiased(true)
      .continuousCornerRadius(8)
      .scaledToFit()
      .overlay(
        StageTitleLabel(
          title: stage.name ?? "nil",
          fontSize: Scoped.LABEL_FONT_SIZE,
          relTextStyle: .body)
        .padding(.leading, Scoped.LABEL_PADDING_LEADING)
        .padding([.bottom, .trailing], Scoped.LABEL_PADDING_BOTTOMTRAILING),
        alignment: .bottomTrailing)
      .animation(.snappy, value: true)

  }
}
