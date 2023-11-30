//
//  Persistence.swift
//  InkCompanion
//
//  Created by 姜锋 on 11/1/23.
//

import CoreData



struct PersistenceController {
  static let shared = PersistenceController()


  let container: NSPersistentContainer


  // 为预览目的添加的静态属性
  static let preview: PersistenceController = {
    let controller = PersistenceController(inMemory: true)
    let viewContext = controller.container.viewContext

    // 在这里可以创建和配置一些用于预览的实体


    do {
      try viewContext.save()
    } catch {
      print("preview context save failed")
    }
    return controller
  }()

  init(inMemory: Bool = false) {
    container = NSPersistentContainer(name: "InkCompanion")
    if inMemory {
      container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
    }
    container.loadPersistentStores(completionHandler: { (storeDescription, error) in
      if let error = error as NSError? {
        // Replace this implementation with code to handle the error appropriately.
        // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.

        /*
         Typical reasons for an error here include:
         * The parent directory does not exist, cannot be created, or disallows writing.
         * The persistent store is not accessible, due to permissions or data protection when the device is locked.
         * The device is out of space.
         * The store could not be migrated to the current model version.
         Check the error message to determine what the actual problem was.
         */
        fatalError("Unresolved error \(error), \(error.userInfo)")
      }
    })
    container.viewContext.automaticallyMergesChangesFromParent = true
  }
}
