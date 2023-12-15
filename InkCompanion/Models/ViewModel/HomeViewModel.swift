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
  @Published var scheduleDict:[ScheduleMode:[any Schedule]]
  @Published var regularShift:[CoopSchedule] = []
  @Published var bigrunShift:[CoopSchedule] = []
  @Published var teamContestShift:[CoopSchedule] = []
  @Published var coopWinLoseDrawResult:[Judgement] = []
  @Published var battleWinLoseDrawResult:[Judgement] = []
  @Published var todayCoop:TodayCoop = TodayCoop()
  @Published var todayBattle:TodayBattle = TodayBattle()

  private var inkNet = InkNet.shared
  private var inkData = InkData.shared

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
      self.regularShift = (data?.data.coopGroupingSchedule?.regularSchedules.nodes ?? [])
      self.bigrunShift = (data?.data.coopGroupingSchedule?.bigRunSchedules.nodes ?? [])
    }
  }
  
  @MainActor
  func loadGrids() {
      if let userKey = InkUserDefaults.shared.currentUserKey, let id = Int64(userKey) {
          // 使用后台线程进行数据库操作
          DispatchQueue.global(qos: .userInitiated).async {
              let coopResult = self.inkData.coopStatus(accountId: id)
              let battleResult = self.inkData.battleStatus(accountId: id)

              // 返回主线程更新UI
              DispatchQueue.main.async {
                  self.coopWinLoseDrawResult = coopResult
                  self.battleWinLoseDrawResult = battleResult
              }
          }
      }
  }


  @MainActor
  func loadTodayCoop(){
    if let userKey = InkUserDefaults.shared.currentUserKey, let id = Int64(userKey){
      self.todayCoop = inkData.recentGroupCoop(accountId: id)
      self.todayBattle = inkData.todayBattle(accountId: id)
    }
  }

  func shouldShowFestival()->Bool{

    return false
  }
}
