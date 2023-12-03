//
//  ScheduleList.swift
//  InkCompanion
//
//  Created by 姜锋 on 12/1/23.
//

import SwiftUI
import Kingfisher

struct ScheduleView: View {
  @EnvironmentObject var viewModel:HomeViewModel

  var mode:ScheduleMode{viewModel.currentMode}
  var schedules:[any Schedule]{
    viewModel.scheduleDict[mode] ?? []
  }
  var body: some View {
    Group{

      if let schedules = schedules as? [Battle2CasesSchedule]{
        if viewModel.currentMode == .anarchy{
          if viewModel.anarchyMode == .CHALLENGE{
            let challengeSchedules = schedules.map{$0.toRegularSchedule(isChallenge: true)}
            ScheduleList(schedules: challengeSchedules)
          }else{
            let openSchedules = schedules.map{$0.toRegularSchedule(isChallenge: false)}
            ScheduleList(schedules: openSchedules)
          }
        }else{
          if viewModel.festMode == .challenge{
            let challengeSchedules = schedules.map{$0.toRegularSchedule(isChallenge: true)}
            ScheduleList(schedules: challengeSchedules)
          }else{
            let regularSchedules = schedules.map{$0.toRegularSchedule(isChallenge: false)}
            ScheduleList(schedules: regularSchedules)
          }
        }
      }else if let schedules = schedules as? [BattleRegularSchedule]{
        ScheduleList(schedules: schedules)
      }

    }
    .animation(
      .bouncy,
      value: schedules.map { $0.startTime })
//    .frame(width: 377)
  }
}


#Preview {
  ScheduleView()
    .environmentObject(HomeViewModel())
    .environmentObject(TimePublisher.shared)
}
