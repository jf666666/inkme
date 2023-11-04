//
//  DataController.swift
//  hailuowan
//
//  Created by 姜锋 on 11/1/23.
//

import CoreData
import SwiftUI

//class DataController: ObservableObject {
//    // 持有 NSPersistentContainer 实例
//    let container: NSPersistentContainer
//
//    // 初始化方法
//    init(inMemory: Bool = false) {
//        container = NSPersistentContainer(name: "InkCompanion") // 替换为您的 .xcdatamodeld 文件的名称
//        if inMemory {
//            container.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")
//        }
//        container.loadPersistentStores { storeDescription, error in
//            if let error = error as NSError? {
//                // 实际应用中应该适当处理错误
//                fatalError("Unresolved error \(error), \(error.userInfo)")
//            }
//        }
//    }
//    
//    // 保存上下文的方法
//    func save() {
//        let context = container.viewContext
//        if context.hasChanges {
//            do {
//                try context.save()
//            } catch {
//                // 实际应用中应该适当处理错误
//                let nserror = error as NSError
//                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
//            }
//        }
//    }
//}
