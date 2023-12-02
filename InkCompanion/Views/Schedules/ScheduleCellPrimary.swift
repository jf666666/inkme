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
  let schedule:BattleRegularSchedule
  let scheduleType:type
  enum type{
    case primary
    case secondary
  }
  private var startTimeString: String {
    let shouldIncludeDate = Calendar.current.isDateInYesterday(schedule.startTime) ||
    Calendar.current.isDateInTomorrow(schedule.startTime)

    return schedule.startTime.toBattleTimeString(includeDateIf: shouldIncludeDate)
  }
  private var endTimeString: String {
    let shouldIncludeDate = (
      Calendar.current.isDateInYesterday(schedule.startTime) &&
      Calendar.current.isDateInToday(schedule.endTime)) ||
    (
      Calendar.current.isDateInToday(schedule.startTime) &&
      Calendar.current.isDateInTomorrow(schedule.endTime))

    return schedule.endTime.toBattleTimeString(includeDateIf: shouldIncludeDate)
  }
  var body: some View {
    VStack(spacing:8){
      HStack(alignment: .center){
        ruleSection
        Spacer()
        if self.scheduleType == .primary{
          remainingTimeSection
        }else{
          timeRangeSection
        }
      }
//      if scheduleType == .primary {
//        ProgressView(
//          value: min(timePublisher.currentTime, schedule.endTime) - schedule.startTime,
//          total: schedule.endTime - schedule.startTime)
//        .padding(.bottom, 8)
//      .tint(schedule.mode.themeColor)
//      }
      HStack{
        StageCard(stage: schedule.stages[0])
        StageCard(stage: schedule.stages[1])
      }

    }
  }


  private var ruleIcon: some View {
    schedule.rule.image
      .antialiased(true)
      .resizable()
      .scaledToFit()
      .shadow(radius: 4)
      .layoutPriority(1)

  }
  var timeRangeSection:some View{
    Text("\(startTimeString) - \(endTimeString)")
      .scaledLimitedLine()
      .inkFont(
        .font1,
        size: 16,
        relativeTo: .headline)
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
      width: 400 * 0.45,
      height: 400 * 0.115,
      alignment: .leading)
    .hAlignment(.leading)
  }

  private var ruleTitle: some View {
    IdealFontLayout(anchor: .leading) {
      // actual rule title
      Text(schedule.rule.name)
        .scaledLimitedLine()
        .inkFont(.font1, size: Scoped.RULE_TITLE_FONT_SIZE_MAX, relativeTo: Scoped.RULE_TITLE_TEXT_STYLE_RELATIVE_TO)

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
    Text(timePublisher.currentTime.toTimeRemainingStringKey(until: schedule.endTime))
      .contentTransition(.numericText(countsDown: true))
      .animation(.snappy, value: timePublisher.currentTime)
      .scaledLimitedLine()
      .foregroundStyle(Color.secondary)
      .inkFont(.font1, size: 25, relativeTo: .headline)
      .frame(
        width: 400 * 0.32,
        alignment: .trailing)
  }
}

#Preview {
  ScheduleCellPrimary(schedule: (MockData.getStageQuery().data.regularSchedules?.nodes![0].toSchedule())!,scheduleType: .primary)
    .environmentObject(TimePublisher.shared)
}
