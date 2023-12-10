//
//  Schedule.swift
//  InkCompanion
//
//  Created by 姜锋 on 12/10/23.
//

import SwiftUI

struct ScheduleView: View {
  @EnvironmentObject var viewModel:HomeViewModel

  var mode:ScheduleMode{viewModel.currentMode}
  var schedules:[any Schedule]{
    viewModel.scheduleDict[mode] ?? []
  }

  var body: some View {
    ScrollView{
      TabView {
        regular
          .tag(0)
        x
          .tag(1)
        anarchyOpen
          .tag(2)
        anarchyChallenge
          .tag(3)
        coop
          .tag(4)
      }
      .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
      .frame(height: 5000)
    }

  }
  var anarchyOpen:some View{
    BattleScheduleList(schedules: (viewModel.scheduleDict[.anarchy] as? [Battle2CasesSchedule] ?? []).map{$0.toRegularSchedule(isChallenge: false)})
  }

  var anarchyChallenge:some View{
    BattleScheduleList(schedules: (viewModel.scheduleDict[.anarchy] as? [Battle2CasesSchedule] ?? []).map{$0.toRegularSchedule(isChallenge:true)})
  }

  var x:some View{
    BattleScheduleList(schedules: (viewModel.scheduleDict[.x] as? [BattleRegularSchedule] ?? []))
  }

  var regular:some View{
    BattleScheduleList(schedules: (viewModel.scheduleDict[.regular] as? [BattleRegularSchedule] ?? []))
  }

  var coop:some View{
    CoopScheduleView()
  }

}

#Preview {
  ScheduleView()
    .environmentObject(HomeViewModel())
}
