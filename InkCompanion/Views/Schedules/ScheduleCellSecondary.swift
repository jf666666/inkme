//
//  ScheduleCellSecondary.swift
//  InkCompanion
//
//  Created by 姜锋 on 12/1/23.
//

import SwiftUI
import Kingfisher

struct ScheduleCellSecondary:View {
  typealias Scoped = Constants.Style.Rotation.Battle.Cell.Secondary
  @Environment(\.horizontalSizeClass) private var horizontalSizeClass

  let schedule:BattleRegularSchedule
  let rowWidth: CGFloat

  private var isHorizontalCompact: Bool { horizontalSizeClass == .compact }

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
    VStack(alignment:.leading){

      HStack(alignment: .center){
        ruleSection
        Spacer()
        Text("\(startTimeString) - \(endTimeString)")
          .scaledLimitedLine()
          .inkFont(
            .Splatoon2,
            size: 14,
            relativeTo: .headline)
      }
      HStack{
        //          VStack(spacing: Scoped.RULE_SECTION_SPACING) {
        //            ruleIcon
        //            ruleTitle
        //          }
        //          .frame(width: rowWidth * Scoped.RULE_SECTION_WIDTH_RATIO)
        //          .padding(.trailing,Scoped.RULE_SECTION_PADDING_TRAILING)
        // MARK: Stage Section

        HStack {
          battleStageCardA
          battleStageCardB
        }
      }
    }
    //      .padding(.top, 8)
    //      .padding(.bottom, 8)
  }

  // MARK: Rule Section
  
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

  private var ruleIcon: some View {
    schedule.rule.image
      .antialiased(true)
      .resizable()
      .scaledToFit()
      .shadow(radius: 4)
      .layoutPriority(1)

  }

  private var battleStageCardA: some View {
    BattleRotationStageCardSecondary(stage: schedule.stages[0])
  }

  private var battleStageCardB: some View {
    BattleRotationStageCardSecondary(stage: schedule.stages[1])
  }


  private var ruleTitle: some View {
    Text(schedule.rule.name)
      .scaledLimitedLine()
      .inkFont(.Splatoon1, size: Scoped.RULE_FONT_SIZE, relativeTo: .body)
      .frame(height: Scoped.RULE_TITLE_HEIGHT)
  }

}


struct BattleRotationStageCardSecondary: View {
  typealias Scoped = Constants.Style.Rotation.Battle.Card.Secondary

  let stage:Stage

  var body: some View {
    VStack{
      KFImage(URL(string: stage.image?.url ?? ""))
        .resizable()
        .antialiased(true)
        .continuousCornerRadius(8)
        .shadow(radius: Constants.Style.Global.SHADOW_RADIUS)
        .scaledToFit()
      //        .alignmentGuide(.battleStagesImageAlignment) { $0[.bottom]}
      //        .layoutPriority(1)
      Text(stage.name )
        .scaledLimitedLine()
        .inkFont(.font1, size: Scoped.FONT_SIZE, relativeTo: .body)
    }
  }
}
