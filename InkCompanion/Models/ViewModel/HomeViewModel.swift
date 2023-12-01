//
//  HomeViewModelswift.swift
//  InkCompanion
//
//  Created by 姜锋 on 11/30/23.
//

import Foundation


class HomeViewModel: ObservableObject{
  @Published var currentMode:ScheduleMode = .regular
  @Published var anarchyMode:BankaraMatchMode = .CHALLENGE
  @Published var festMode:FestMatchMode = .challenge
  private var inkNet = InkNet.shared
  @Published var scheduleDict:[ScheduleMode:[any Schedule]]

  init() {
    self.scheduleDict = [:]
    for mode in ScheduleMode.allCases {
      scheduleDict[mode] = []
    }
  }

  func loadSchedules() async {
    let data = await self.inkNet.fetchSchedule()
    DispatchQueue.main.async {
      self.scheduleDict[.regular] = (data?.data.regularSchedules?.nodes ?? []).compactMap{ $0.toSchedule()}
      self.scheduleDict[.anarchy] = (data?.data.bankaraSchedules?.nodes ?? []).compactMap{ $0.toSchedule()}
      self.scheduleDict[.fest] = (data?.data.festSchedules?.nodes ?? []).compactMap{ $0.toSchedule()}
      self.scheduleDict[.x] = (data?.data.xSchedules?.nodes ?? []).compactMap{ $0.toSchedule()}
    }
  }

  func shouldShowFestival()->Bool{

    return false
  }
}
