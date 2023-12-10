//
//  ScheduleList.swift
//  InkCompanion
//
//  Created by 姜锋 on 12/1/23.
//

import SwiftUI
import Kingfisher

struct BattleScheduleList: View {
  @EnvironmentObject private var timePublisher: TimePublisher

  let schedules:[BattleRegularSchedule]
  private var validSchedules: [BattleRegularSchedule] {
    schedules.filter{!$0.isExpired(timePublisher.currentTime)}
  }


  var body: some View {
    VStack(alignment: .center,spacing: 10){
      ForEach(validSchedules, id:\.startTime) { schedule in
        var type:BattleScheduleCell.type{schedule.isCurrent(timePublisher.currentTime) ? .primary : .secondary}
        VStack{
          BattleScheduleCell(schedule: schedule,scheduleType:type)
            
        }
      }
    }
  }
}






#Preview {

  ScrollView {
    BattleScheduleList(schedules: MockData.getStageQuery().data.regularSchedules?.nodes?.compactMap{$0.toSchedule()} ?? [])
      .environmentObject(TimePublisher.shared)
  }
}
