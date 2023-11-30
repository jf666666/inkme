//
//  InkAppDelegate.swift
//  InkCompanion
//
//  Created by 姜锋 on 11/26/23.
//



import UIKit
import BackgroundTasks
import UserNotifications
import SwiftUI


//@main
class AppDelegate: UIResponder, UIApplicationDelegate {
  var window: UIWindow?

  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    // 请求通知权限

    UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
      // 处理结果
    }

    // 注册后台任务
    BGTaskScheduler.shared.register(forTaskWithIdentifier: "InkCompanionRefresh", using: nil) { task in
      self.handleAppRefresh(task: task as! BGAppRefreshTask)
    }

    return true
  }


  func applicationDidEnterBackground(_ application: UIApplication) {
    print("applicationDidEnterBackground")
    scheduleAppRefresh()
  }


  func handleAppRefresh(task: BGAppRefreshTask) {

    // 安排下一个刷新任务
    scheduleAppRefresh()

    let queue = OperationQueue()
    queue.maxConcurrentOperationCount = 1

    // 设置到期处理程序，以防任务耗时过长
    task.expirationHandler = {
      // 清理任何未完成的任务
      queue.cancelAllOperations()
    }
    
    postUserNotification(title: "新数据", body: "后台任务已获取新数据。", interval: 1)
    // 执行实际的后台任务
    fetchDataAndNotify()

    // 标记任务完成
    task.setTaskCompleted(success: true)
  }

  func scheduleAppRefresh() {
    print("sssssss")
    let request = BGAppRefreshTaskRequest(identifier: "InkCompanionRefresh")
    request.earliestBeginDate = Date(timeIntervalSinceNow: 3) // 例如，1小时后

    do {
      print("ssssss")
      try BGTaskScheduler.shared.submit(request)
    } catch {
      print("无法安排任务: \(error)")
    }
  }

  func fetchDataAndNotify() {

    Task {
      print("fetchDataAndNotify")
      await CoopModel().loadFromNet()

      // 数据获取完成后，发送通知
      postUserNotification(title: "新数据", body: "后台任务已获取新数据。", interval: 1)
    }
  }
}


func postUserNotification(title: String, body: String, interval: TimeInterval) {
  // 1. 创建通知内容
  let content = UNMutableNotificationContent()
  content.title = title
  content.body = body
  content.sound = UNNotificationSound.default

  // 2. 设置触发器
  let trigger = UNTimeIntervalNotificationTrigger(timeInterval: interval, repeats: false)

  // 3. 创建请求
  let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: nil)

  // 4. 将请求添加到通知中心
  UNUserNotificationCenter.current().add(request) { error in
    if let error = error {
      print("Error scheduling notification: \(error)")
      return
    }
    print("Notification scheduled: \(request.identifier)")
  }
}


//class SceneDelegate: UIResponder, UIWindowSceneDelegate {
//  var window: UIWindow?
//
//  func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
//    // Do not config external display. So we can get default mirroring behavior.
//    guard session.role != UISceneSession.Role.windowExternalDisplayNonInteractive else { return }
//
//    if let windowScene = scene as? UIWindowScene {
//      let window = UIWindow(windowScene: windowScene)
//      let contentView = InkCompanionApp()
//      window.rootViewController = UIHostingController(rootView: contentView)
//      self.window = window
//      window.makeKeyAndVisible()
//
//    }
//  }
//}

