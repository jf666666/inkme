//
//  ScheduleStageView.swift
//  InkCompanion
//
//  Created by 姜锋 on 11/9/23.
//

import SwiftUI

struct BattleRotationCell: View {
  enum CellType {
    case primary
    case secondary
  }

  let type: CellType
  let rotation:BattleRotation
  let rowWidth:CGFloat
  var isPrimary:Bool { type == .primary}
    var body: some View {
      if isPrimary{
        BattleRotationCellPrimary(rotation: rotation, rowWidth: rowWidth)
      }else{
        BattleRotationCellSecondary(rotation: rotation, rowWidth: rowWidth)
      }
    }
}

struct BattleRotationCellPrimary: View {
  typealias Scoped = Constants.Style.Rotation.Battle.Cell.Primary
  @Environment(\.horizontalSizeClass) private var horizontalSizeClass

  @EnvironmentObject private var TimePublisher: TimePublisher

  let rotation:BattleRotation
  let rowWidth: CGFloat

  private var isHorizontalCompact: Bool { horizontalSizeClass == .compact }

  var body: some View {
    VStack(spacing: 8) {
      HStack(alignment: .center) {
        ruleSection
        Spacer()
        remainingTimeSection
      }

      ProgressView(
        value: min(TimePublisher.currentTime, rotation.endTime) - rotation.startTime,
        total: rotation.endTime - rotation.startTime)
        .padding(.bottom, 8)
        .tint(rotation.mode.themeColor)

      // MARK: Stage Section

      HStack {
        battleStageCardA
        battleStageCardB
      }
    }
    .padding(.top, 8)
    .padding(.bottom, 8)
  }

  // MARK: Rule Section

  private var ruleIcon: some View {
    rotation.rule.image
      .antialiased(true)
      .resizable()
      .scaledToFit()
      .shadow(radius: 4)
      .layoutPriority(1)

  }

  private var battleStageCardA: some View {
    BattleRotationStageCardPrimary(
      rotation: rotation,
      stageSelection: .stageA)
  }

  private var battleStageCardB: some View {
    BattleRotationStageCardPrimary(
      rotation: rotation,
      stageSelection: .stageB)
  }

  private var ruleSection: some View {
    HStack(
      alignment: .center,
      spacing: 8)
    {
      ruleIcon
      ruleTitle
    }
    .frame(
      width: rowWidth * 0.45,
      height: rowWidth * 0.115,
      alignment: .leading)
    .hAlignment(.leading)
  }

  private var ruleTitle: some View {
    IdealFontLayout(anchor: .leading) {
      // actual rule title
      Text(rotation.rule.name)
        .scaledLimitedLine()
        .inkFont(.Splatoon1, size: Scoped.RULE_TITLE_FONT_SIZE_MAX, relativeTo: Scoped.RULE_TITLE_TEXT_STYLE_RELATIVE_TO)

      // all other possible rule titles for the layout to compute ideal size
      ForEach(BattleRule.allCases) { rule in
        Text(rule.name)
          .scaledLimitedLine()
          .inkFont(.font1, size: Scoped.RULE_TITLE_FONT_SIZE_MAX, relativeTo: Scoped.RULE_TITLE_TEXT_STYLE_RELATIVE_TO)
      }
    }
    .padding(.vertical, Scoped.RULE_TITLE_PADDING_V)

  }


  // MARK: Remaining Time Section

  private var remainingTimeSection: some View {
    Text(TimePublisher.currentTime.toTimeRemainingStringKey(until: rotation.endTime))
      .contentTransition(.numericText(countsDown: true))
      .animation(.snappy, value: TimePublisher.currentTime)
      .scaledLimitedLine()
      .foregroundStyle(Color.secondary)
      .inkFont(.Splatoon1, size: 15, relativeTo: .headline)
      .frame(
        width: rowWidth * 0.32,
        alignment: .trailing)
  }
}

struct BattleRotationCellSecondary: View {
  typealias Scoped = Constants.Style.Rotation.Battle.Cell.Secondary
  @Environment(\.horizontalSizeClass) private var horizontalSizeClass



  let rotation:BattleRotation
  let rowWidth: CGFloat

  private var isHorizontalCompact: Bool { horizontalSizeClass == .compact }

  var body: some View {
    HStack{
      VStack(spacing: Scoped.RULE_SECTION_SPACING) {
        ruleIcon
        ruleTitle
      }
      .frame(width: rowWidth * Scoped.RULE_SECTION_WIDTH_RATIO)
      .padding(.trailing,Scoped.RULE_SECTION_PADDING_TRAILING)
      // MARK: Stage Section

      HStack {
        battleStageCardA
        battleStageCardB
      }
    }
    .padding(.top, 8)
    .padding(.bottom, 8)
  }

  // MARK: Rule Section

  private var ruleIcon: some View {
    Rectangle()
      .overlay {
        rotation.rule.image
          .antialiased(true)
          .resizable()
          .scaledToFit()
//          .shadow(radius: Constants.Style.Global.SHADOW_RADIUS)
//          .frame(height: Scoped.RULE_IMG_HEIGHT_RATIO*rowWidth)
//          .background(Color.systemBackgroundTertiary)
//          .cornerRadius(Scoped.RULE_IMG_FRAME_CORNER_RADIUS)
      }
      .frame(width: Scoped.RULE_IMG_HEIGHT_RATIO*rowWidth, height: Scoped.RULE_IMG_HEIGHT_RATIO*rowWidth)
      .continuousCornerRadius(8)
      .foregroundStyle(Color(.sRGB, white: 151 / 255.0, opacity: 0.1))


  }

  private var battleStageCardA: some View {
    BattleRotationStageCardSecondary(
      rotation: rotation,
      stageSelection: .stageA)
  }

  private var battleStageCardB: some View {
    BattleRotationStageCardSecondary(
      rotation: rotation,
      stageSelection: .stageB)
  }

  private var ruleSection: some View {
    HStack(
      alignment: .center,
      spacing: 8)
    {
      ruleIcon
      ruleTitle
    }
    .frame(
      width: rowWidth * 0.45,
      height: rowWidth * 0.115,
      alignment: .leading)
    .hAlignment(.leading)
  }

  private var ruleTitle: some View {
      Text(rotation.rule.name)
        .scaledLimitedLine()
        .inkFont(.Splatoon1, size: Scoped.RULE_FONT_SIZE, relativeTo: .body)
        .frame(height: Scoped.RULE_TITLE_HEIGHT)
  }



}


struct BattleRotationCell_Previews: PreviewProvider {
    static var previews: some View {
      let TimePublisher: TimePublisher = .shared
      let rotation = MockData.getBattleRotation(preferredMode: .event,preferredRule: .turfWar)
      GeometryReader { geo in
        List {
          Section{
            BattleRotationCell(type: .primary, rotation: rotation, rowWidth: geo.size.width)
              .environmentObject(TimePublisher)
          }
          Section{
            BattleRotationCell(type: .secondary, rotation: rotation, rowWidth: geo.size.width)
              .environmentObject(TimePublisher)
          }
        }
      }
    }
}
