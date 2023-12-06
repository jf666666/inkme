//
//  ScheduleList.swift
//  InkCompanion
//
//  Created by 姜锋 on 12/1/23.
//

import SwiftUI
import Kingfisher

struct BattleScheduleView: View {
  @EnvironmentObject var viewModel:HomeViewModel

  var mode:ScheduleMode{viewModel.currentMode}
  var schedules:[any Schedule]{
    viewModel.scheduleDict[mode] ?? []
  }
  var body: some View {
    if viewModel.regularShift.count == 0{
      makeLoadingView(isFailed: false) {

      }
    }else{
      content
    }
  }

  var content:some View{
    Group{
      if let schedules = schedules as? [Battle2CasesSchedule]{
        if viewModel.currentMode == .anarchy{
          if viewModel.anarchyMode == .CHALLENGE{
            let challengeSchedules = schedules.map{$0.toRegularSchedule(isChallenge: true)}
            BattleScheduleList(schedules: challengeSchedules)
          }else{
            let openSchedules = schedules.map{$0.toRegularSchedule(isChallenge: false)}
            BattleScheduleList(schedules: openSchedules)
          }
        }else{
          if viewModel.festMode == .challenge{
            let challengeSchedules = schedules.map{$0.toRegularSchedule(isChallenge: true)}
            BattleScheduleList(schedules: challengeSchedules)
          }else{
            let regularSchedules = schedules.map{$0.toRegularSchedule(isChallenge: false)}
            BattleScheduleList(schedules: regularSchedules)
          }
        }
      }else if let schedules = schedules as? [BattleRegularSchedule]{
        BattleScheduleList(schedules: schedules)
      }
    }
    .animation(
      .bouncy,
      value: schedules.map { $0.startTime })
  }

  func makeLoadingView(isFailed: Bool, onReload: @escaping () -> Void) -> some View {
    HStack {
      Spacer()
      if isFailed {
        Text("Reload")
          .foregroundColor(.accentColor)
      } else {
        ProgressView()
      }
      Spacer()
    }
    .padding()
    .background(AppColor.listItemBackgroundColor)
    .continuousCornerRadius(10)
    .onTapGesture {
      onReload()
    }
  }
}


#Preview {
  BattleScheduleView()
    .environmentObject(HomeViewModel())
    .environmentObject(TimePublisher.shared)
}
