//
//  Task.swift
//  InkCompanion
//
//  Created by 姜锋 on 11/26/23.
//

import Foundation
import SwiftUI
import BackgroundTasks
import OSLog


final class InkBackgroundRefresher {

  static let shared = InkBackgroundRefresher()

  internal let logger = Logger(.background)

  private let inkNet = InkNet.shared
  private let inkData = InkData.shared
  private let nintendo = InkNet.NintendoService()
  private init() { }

  
  @Sendable
  nonisolated func handleAppRefresh() async{
    scheduleAppRefresh()

      do{
        let (web,bullet) = try await nintendo.updateTokens()
        if let web = web{
          inkNet.webServiceToken = web
        }
        if let bullet = bullet{
          inkNet.bulletToken = bullet
        }
      }catch{
        return
      }
    
    let coopCount = await self.fetchCoopHistory()
    if coopCount > 0{
      postUserNotification(title: "新记录", body: "InkCompanion已在后台加载\(coopCount)个打工记录，请打开应用以确认。", interval: 1)
    }
  }

  func fetchCoopHistory() async -> Int{
    var result = 0
    let newCoopGroups = await inkNet.fetchCoopHistories()?.historyGroups?.nodes ?? []
    for group in newCoopGroups.reversed() {
      if let details = group.historyDetails?.nodes{
        await withTaskGroup(of: CoopHistoryDetail?.self) { group in
          for detail in details {
            group.addTask {
              if await self.inkData.isExist(id: detail.id){
                return nil
              }
              if let completeDetail = await self.inkNet.fetchCoopHistoryDetail(id: detail.id, diff: detail.gradePointDiff ?? .NONE){
                return completeDetail
              }
              return nil
            }
          }
          for await detail in group{
            if let completeDetail = detail{
              await inkData.addCoop(detail: completeDetail)
              result += 1
            }
          }
        }
      }
    }
    return result
  }

  func scheduleAppRefresh() {
    let request = BGAppRefreshTaskRequest(identifier: InkBackgroundTaskIdentifier.backgroundRefresh)
    request.earliestBeginDate = Date(timeIntervalSinceNow: 1 * 60 * 15)
    do {
      try BGTaskScheduler.shared.submit(request)
    } catch {
      print("Schedule background task Failed due to: \(error)")
    }
  }
}

enum InkBackgroundTaskIdentifier {
  static let backgroundRefresh = "InkCompanionRefresh"
  static let backgroundNotification = "inkCompanion.BackgroundNotification"
}

