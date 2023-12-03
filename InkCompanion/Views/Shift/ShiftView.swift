//
//  ShiftList.swift
//  InkCompanion
//
//  Created by 姜锋 on 12/2/23.
//

import SwiftUI

struct ShiftView: View {
  @EnvironmentObject var viewModel:HomeViewModel
//  let shifts:CoopGroupingSchedule
  var regularSchedules:[CoopSchedule]{viewModel.regularShift}
  var bigRunSchedule:CoopSchedule?{if viewModel.bigrunShift.count > 0{
    return viewModel.bigrunShift[0]
  }
  return nil}
    var body: some View {
      VStack(spacing:15){
        if let bigRunSchedule = bigRunSchedule{
          ShiftCell(shift: bigRunSchedule)
            .padding(15)
            .textureBackground(texture: .streak, radius: 18)
        }
        ForEach(regularSchedules,id:\.startTime){ schedule in
          ShiftCell(shift: schedule)
            .padding(15)
            .textureBackground(texture: .streak, radius: 18)
        }
      }
    }
}

#Preview {
  ShiftView(/*shifts: MockData.getStageQuery().data.coopGroupingSchedule!*/)
    .environmentObject(HomeViewModel())
}
