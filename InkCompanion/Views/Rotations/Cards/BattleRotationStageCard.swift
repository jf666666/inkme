//
//  ScheduleStageCard.swift
//  InkCompanion
//
//  Created by 姜锋 on 11/11/23.
//

import SwiftUI
import Kingfisher

enum BattleStageSelection {
  case stageA
  case stageB
}

struct BattleRotationStageCard: View {
  let rotation:BattleRotation
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

struct BattleRotationStageCardPrimary: View {
  typealias Scoped = Constants.Style.Rotation.Battle.Card.Primary

  let rotation:BattleRotation
  let stageSelection: BattleStageSelection

  private var stage: any Stage {
    stageSelection == .stageA ? rotation.stageA : rotation.stageB
  }

  var body: some View {
    KFImage(URL(string: stage.image?.url ?? ""))
      .resizable()
      .antialiased(true)
      .cornerRadius(Scoped.IMG_CORNER_RADIUS)
      .shadow(radius: Constants.Style.Global.SHADOW_RADIUS)
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

struct BattleRotationStageCardSecondary: View {
  typealias Scoped = Constants.Style.Rotation.Battle.Card.Secondary

  let rotation:BattleRotation
  let stageSelection: BattleStageSelection

  private var stage: any Stage {
    stageSelection == .stageA ? rotation.stageA : rotation.stageB
  }

  var body: some View {
    VStack(alignment: .trailing,spacing: Scoped.SPACING_V){
      KFImage(URL(string: stage.image?.url ?? ""))
        .resizable()
        .antialiased(true)
        .cornerRadius(Scoped.IMG_CORNER_RADIUS)
        .shadow(radius: Constants.Style.Global.SHADOW_RADIUS)
        .scaledToFit()
        .alignmentGuide(.battleStagesImageAlignment) { $0[.bottom]}
        .layoutPriority(1)

      Text(stage.name ?? "nil")
        .scaledLimitedLine()
        .inkFont(.font1, size: Scoped.FONT_SIZE, relativeTo: .body)
    }
  }
}

struct StageTitleLabel: View {
  typealias Scoped = Constants.Style.Rotation.Label

  let title: String
  let fontSize: CGFloat
  let relTextStyle: Font.TextStyle

  var body: some View {
    Text(title)
      .scaledLimitedLine()
      .inkFont(.font1, size: fontSize, relativeTo: relTextStyle)
      .padding(.horizontal, Scoped.TEXT_PADDING_H)
      .padding(.vertical, Scoped.TEXT_PADDING_V)
      .background(.ultraThinMaterial)
      .cornerRadius(Scoped.BACKGROUND_CORNER_RADIUS)

  }
}


struct BattleRotationStageCard_Preview :PreviewProvider{
  static var previews: some View{
    let rotation = MockData.getBattleRotation(preferredMode: .anarchy(.CHALLENGE),preferredRule: .splatZones)
    BattleRotationStageCardPrimary(rotation: rotation, stageSelection: .stageA)
    
  }
}
