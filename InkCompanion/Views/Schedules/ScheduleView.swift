//
//  ScheduleList.swift
//  InkCompanion
//
//  Created by 姜锋 on 12/1/23.
//

import SwiftUI
import Kingfisher

struct ScheduleView: View {
    @EnvironmentObject var viewModel: HomeViewModel

    var mode: ScheduleMode { viewModel.currentMode }
    var schedules: [any Schedule] {
        viewModel.scheduleDict[mode] ?? []
    }

    private var processedSchedules: [BattleRegularSchedule] {
        if let schedules = schedules as? [Battle2CasesSchedule] {
            let isChallenge = (mode == .anarchy && viewModel.anarchyMode == .CHALLENGE) ||
                              (mode != .anarchy && viewModel.festMode == .challenge)
            return schedules.map { $0.toRegularSchedule(isChallenge: isChallenge) }
        } else if let schedules = schedules as? [BattleRegularSchedule] {
            return schedules
        }
        return []
    }
  

    var body: some View {
      
        ScheduleList(schedules: processedSchedules)
            .animation(.bouncy, value: schedules.map { $0.startTime })
            .frame(width: 377)

    }
}


#Preview {
  ScheduleView()
    .environmentObject(HomeViewModel())
    .environmentObject(TimePublisher.shared)
}
