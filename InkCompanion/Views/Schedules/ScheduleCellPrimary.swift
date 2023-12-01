//
//  ScheduleCellPrimary.swift
//  InkCompanion
//
//  Created by 姜锋 on 12/1/23.
//

import SwiftUI

struct ScheduleCellPrimary: View {
  @EnvironmentObject var timePublisher:TimePublisher
  typealias Scoped = Constants.Style.Rotation.Battle.Cell.Primary
  let rowWidth: CGFloat
  let rotation:BattleRegularSchedule
  var body: some View {
    VStack(spacing:8){
      HStack(alignment: .center){
        ruleSection
        Spacer()
        remainingTimeSection
      }
      ProgressView(
        value: min(timePublisher.currentTime, rotation.endTime) - rotation.startTime,
        total: rotation.endTime - rotation.startTime)
      .padding(.bottom, 8)
      .tint(rotation.mode.themeColor)
      HStack{
        StageCard(stage: rotation.stages[0])
        StageCard(stage: rotation.stages[1])
      }
    }
  }


  private var ruleIcon: some View {
    rotation.rule.image
      .antialiased(true)
      .resizable()
      .scaledToFit()
      .shadow(radius: 4)
      .layoutPriority(1)

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

  private var remainingTimeSection: some View {
    Text(timePublisher.currentTime.toTimeRemainingStringKey(until: rotation.endTime))
      .contentTransition(.numericText(countsDown: true))
      .animation(.snappy, value: timePublisher.currentTime)
      .scaledLimitedLine()
      .foregroundStyle(Color.secondary)
      .inkFont(.Splatoon1, size: 15, relativeTo: .headline)
      .frame(
        width: 400 * 0.32,
        alignment: .trailing)
  }
}

//#Preview {
//    ScheduleCellPrimary()
//}
