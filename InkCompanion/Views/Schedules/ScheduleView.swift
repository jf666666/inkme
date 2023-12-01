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
    VStack{
      ForEach(schedules ,id:\.startTime){schedule in
        if let schedule = schedule as? Battle2CasesSchedule{

        }else if let schedule = schedule as? BattleRegularSchedule{

        }
      }
    }
    .animation(
      .bouncy,
      value: schedules.map { $0.startTime })
  }
}

#Preview {
  ScheduleView()
    .environmentObject(HomeViewModel())
}
