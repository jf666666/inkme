//
//  ShiftCell.swift
//  InkCompanion
//
//  Created by 姜锋 on 12/3/23.
//

import SwiftUI
import Kingfisher

struct CoopScheduleCell: View {
  @EnvironmentObject private var timePublisher: TimePublisher

  let shift:CoopSchedule
  var stage:StageSelection{StageSelection(rawValue: shift.setting.coopStage.id) ?? .unknown}
  var timeString:String{
    shift.startTime.asDate.toSalmonTimeString(includeWeekday: true) + " - " + shift.endTime.asDate.toSalmonTimeString()
  }
  var weapons:[String]{shift.setting.weapons.map{$0.image?.url ?? ""}}
  var boss:CoopEnemy{shift.setting.boss}
  var rule:CoopRule{shift.setting.rule}
  var body: some View {
    VStack{
      titleSection
      line
      stageAndWeaponSection
//      if shift.isCurrent(timePublisher.currentTime){
//        VStack(alignment: .trailing){
//          remainingTimeSection
//          ProgressView(
//            value: min(timePublisher.currentTime, shift.endTime.asDate) - shift.startTime.asDate,
//            total: shift.endTime.asDate - shift.startTime.asDate)
//          .tint(ScheduleMode.salmonRun.themeColor)
//        }
//      }
    }
    .padding(10)
    .background(.listItemBackground)
    .continuousCornerRadius(18)
    .frame(height: 180)

  }

  private var remainingTimeSection: some View {
    Text(timePublisher.currentTime.toTimeRemainingStringKey(until: shift.endTime.asDate))
      .contentTransition(.numericText(countsDown: true))
      .animation(.snappy, value: timePublisher.currentTime)
      .scaledLimitedLine()
      .foregroundStyle(Color.secondary)
      .inkFont(.font1, size: 15, relativeTo: .headline)
//      .frame(alignment: .trailing)
  }

  var titleSection:some View{
    HStack {
      HStack(spacing:0){
        rule.icon
          .resizable()
          .scaledToFit()
          .frame(width: 35)

        Text(timeString)
//          .colorInvert()
  //        .scaledLimitedLine()
          .foregroundStyle(.appLabel)
          .inkFont(.font1, size: 15, relativeTo: .body)
          .padding(5)
//          .background(Color.secondary)
          .continuousCornerRadius(4)
      }
      Spacer()
      boss.enemy.image
        .resizable()
        .scaledToFit()

    }
  }
  var stageSection:some View{
    VStack{
      stage.image
        .resizable()
        .scaledToFit()
        .clipped(antialiased: true)
        .continuousCornerRadius(3)
        .overlay(
          bossSection,
          alignment: .bottomTrailing
        )
      Text(stage.name)
        .inkFont(.font1, size: 18, relativeTo: .body)
        .foregroundStyle(.secondary)
    }
  }

  private var stageAndWeaponSection: some View {
    SalmonStageAndWeaponsLayout {
      stage.image
        .antialiased(true)
        .resizable()
        .scaledToFit()
        .continuousCornerRadius(4)
        .overlay(
          bossSection,
          alignment: .bottomTrailing
        )
      weaponSection
    }
  }
  var weaponSection:some View{
    LazyVGrid(columns: [
      GridItem(.flexible()),
      GridItem(.flexible()),
    ]){
      ForEach(0..<weapons.count, id:\.self){index in
        KFImage(URL(string: weapons[index]))
          .resizable()
          .resizedToFit()
//          .frame(width: 50)
//          .background(.red)
          .background(.ultraThinMaterial)
          .continuousCornerRadius(5)
      }
    }
  }

  var line:some View{
    VStack {
      if shift.isCurrent(timePublisher.currentTime) {
        CustomProgressView(value: min(timePublisher.currentTime, shift.endTime.asDate) - shift.startTime.asDate, total: shift.endTime.asDate - shift.startTime.asDate,
          color: ScheduleMode.salmonRun.themeColor
        )
      } else {
        CustomProgressView(value: 0,
                           total: 1,
                           color: .secondary
        )
      }
    }
  }
  var bossSection:some View{
//    VStack{
//      Text(boss.name)
//        .inkFont(.font1, size: 18, relativeTo: .body)
    GeometryReader{geo in
      VStack {
        Spacer()
        HStack(alignment: .bottom) {
          Spacer()
          Text(stage.name)
            .inkFont(.font1, size: geo.size.height*0.12, relativeTo: .body)
            .padding(geo.size.height*0.02)
            .background(.ultraThinMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 3))
        }
      }
      .padding(geo.size.height*0.025)
    }

//    }

  }
}

#Preview {
  ScheduleWrapper {
    CoopScheduleCell(shift: MockData.getStageQuery().data.coopGroupingSchedule!.regularSchedules.nodes![2])
      .environmentObject(TimePublisher.shared)
  }
}
