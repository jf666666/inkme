//
//  InkCompanionApp.swift
//  InkCompanion
//
//  Created by 姜锋 on 11/1/23.
//

import SwiftUI
import Kingfisher
import BackgroundTasks



@main
struct InkCompanionApp: App {
  @Environment(\.scenePhase) private var phase

  let persistenceController = PersistenceController.shared
  @StateObject var timePublisher: TimePublisher = .shared
  @StateObject var coopModel = CoopModel()
  @StateObject var homeViewModel = HomeViewModel()
  @StateObject var battleModel = BattleModel()
  private let refresher:InkBackgroundRefresher = .shared

  init() {
    KingfisherManager.shared.downloader.downloadTimeout = 60
    KingfisherManager.shared.cache.diskStorage.config.expiration = .never

  }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .environmentObject(timePublisher)
                .environmentObject(coopModel)
                .environmentObject(homeViewModel)
                .environmentObject(battleModel)

        }
        .backgroundTask(.appRefresh("InkCompanionRefresh"),action: refresher.handleAppRefresh)
        .onChange(of: phase) { newPhase in
             switch newPhase {
             case .background: scheduleAppRefresh()
             default: break
             }
         }
    }
}

func scheduleAppRefresh() {
  
  let request = BGAppRefreshTaskRequest(identifier: "InkCompanionRefresh")
  request.earliestBeginDate = Calendar.current.date(byAdding: .minute,value: 15, to: .now)
  do {
    try BGTaskScheduler.shared.submit(request)
    print("Background Task Scheduled!")
  } catch {
    print("无法安排任务: \(error.localizedDescription)")
  }
}



