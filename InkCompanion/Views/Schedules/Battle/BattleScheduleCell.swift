//
//  ScheduleCellPrimary.swift
//  InkCompanion
//
//  Created by 姜锋 on 12/1/23.
//

import SwiftUI

struct BattleScheduleCell: View {
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
      if scheduleType == .primary {
        CustomProgressView(
          value: min(timePublisher.currentTime, schedule.endTime) - schedule.startTime,
          total: schedule.endTime - schedule.startTime,
          color: schedule.mode.themeColor
        )
      }else{
        CustomProgressView(
          value: 0,
          total: 1,
          color:Color.secondary
        )
        .tint(schedule.mode.themeColor)
      }

      HStack{
        BattleStageCard(stage: schedule.stages[0])
        BattleStageCard(stage: schedule.stages[1])
      }
    }
    .padding(.all,10)
    .background(.listItemBackground)
    .continuousCornerRadius(18)
  }


  private var ruleIcon: some View {
    schedule.rule.image
      .resizable()
      .antialiased(true)
      .scaledToFit()
      .frame(width: 30,height: 30)
      .shadow(radius: 4)


  }
  var timeRangeSection:some View{
    Text("\(startTimeString) - \(endTimeString)")
      .scaledLimitedLine()
      .inkFont(
        .font1,
        size: 16,
        relativeTo: .headline)
      .foregroundStyle(.secondary)
  }
  private var ruleSection: some View {
    HStack(
      alignment: .center,
      spacing: 8)
    {
      ruleIcon
      ruleTitle
    }
  }

  private var ruleTitle: some View {
    IdealFontLayout(anchor: .leading) {
      Text(schedule.rule.name)
        .scaledLimitedLine()
        .inkFont(.font1, size: 22, relativeTo: Scoped.RULE_TITLE_TEXT_STYLE_RELATIVE_TO)

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
      .inkFont(.font1, size: 16, relativeTo: .headline)
      .frame(alignment: .trailing)
  }
}

struct BattleScheduleCell_Previews: PreviewProvider {

  static var previews: some View {
    ScheduleWrapper{
      let schedules = MockData.getBattleSchedules(preferredMode: .regular)
      VStack(alignment: .center,spacing: 10) {
        BattleScheduleCell(schedule: schedules[0],scheduleType: .primary)


        ForEach(schedules[1..<schedules.count]) { item in
          BattleScheduleCell(schedule: item,scheduleType: .secondary)

        }
      }
    }
  }
}

struct CustomProgressView: View {
  var value: CGFloat  // 当前进度值
  var total: CGFloat  // 总进度值
  var color:Color = Color.init(.sRGB, white: 0.8, opacity: 0.3)
      private var progress: CGFloat {
          1 - max(0, min(value / total, 1))
      }

    var body: some View {
        GeometryReader { geo in
            ZStack(alignment: .leading) {
                // 背景线
                Path { path in
                    path.move(to: .init(x: 0, y: 0))
                    path.addLine(to: .init(x: geo.size.width * progress, y: 0))
                }
                .stroke(style: StrokeStyle(lineWidth: 3, dash: [3.5, 3.5]))
                .foregroundColor(color) // 背景颜色设置为更透明

//                // 填充线
//                Path { path in
//                    path.move(to: .init(x: 0, y: 0))
//                    path.addLine(to: .init(x: geo.size.width * progress, y: 0))
//                }
//                .stroke(style: StrokeStyle(lineWidth: 2))
//                .foregroundColor(Color.init(.sRGB, white: 0.2, opacity: 1)) // 填充颜色保持不变
            }
        }
        .frame(height: 1)
    }
}

struct ScheduleWrapper<Content:View>:View {
  @ViewBuilder let content: () -> Content
  var body: some View {
    NavigationStack {
      ScrollView {
        VStack(alignment: .center,spacing: 10) {
          VStack(spacing:5) {
            content()
              .environmentObject(TimePublisher.shared)
          }
        }
        .frame(maxWidth: .infinity)
        .padding(.horizontal,15)
      }
      .fixSafeareaBackground()
    }
  }
}
