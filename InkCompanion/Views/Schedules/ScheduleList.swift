//
//  ScheduleList.swift
//  InkCompanion
//
//  Created by 姜锋 on 12/1/23.
//

import SwiftUI
import Kingfisher

struct ScheduleList: View {
  @EnvironmentObject private var timePublisher: TimePublisher

  let schedules:[BattleRegularSchedule]
  private var validSchedules: [BattleRegularSchedule] {
    schedules.filter{!$0.isExpired(timePublisher.currentTime)}
  }

  var body: some View {
    

        VStack(spacing:20) {
          ForEach(validSchedules) { schedule in
            if schedule.isCurrent(timePublisher.currentTime){
              ScheduleCellPrimary( rowWidth: 400, rotation: schedule)
                .padding()
                .textureBackground(texture: .bubble, radius: 18)
            }else{
              ScheduleCellSecondary(schedule: schedule, rowWidth: 400)
                .padding()
                .textureBackground(texture: .bubble, radius: 18)
            }
          }
        }

      .padding(.horizontal, 7)
//      .fixSafeareaBackground()


  }


}






#Preview {

  ScrollView {
    ScheduleList(schedules: MockData.getStageQuery().data.regularSchedules?.nodes?.compactMap{$0.toSchedule()} ?? [])
      .environmentObject(TimePublisher.shared)
  }
}
