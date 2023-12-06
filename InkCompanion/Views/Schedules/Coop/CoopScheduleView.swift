//
//  ShiftList.swift
//  InkCompanion
//
//  Created by 姜锋 on 12/2/23.
//

import SwiftUI

struct CoopScheduleView: View {
  @EnvironmentObject var viewModel:HomeViewModel
  @EnvironmentObject private var timePublisher: TimePublisher
//  let shifts:CoopGroupingSchedule
  var regularSchedules:[CoopSchedule]{viewModel.regularShift}
  var bigRunSchedule:CoopSchedule?{if viewModel.bigrunShift.count > 0{
    return viewModel.bigrunShift[0]
  }
  return nil}
    var body: some View {
      VStack(spacing:15){
        if let bigRunSchedule = bigRunSchedule{
          CoopScheduleCell(shift: bigRunSchedule)
            .padding(10)
            .textureBackground(texture: .streak, radius: 18)
        }
        ForEach(regularSchedules,id:\.startTime){ schedule in
          CoopScheduleCell(shift: schedule)
            .padding(10)
            .textureBackground(texture: .streak, radius: 18)
        }
      }
    }
}

#Preview {
  CoopScheduleView(/*shifts: MockData.getStageQuery().data.coopGroupingSchedule!*/)
    .environmentObject(HomeViewModel())
    .environmentObject(TimePublisher.shared)
}