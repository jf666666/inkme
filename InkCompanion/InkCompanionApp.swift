//
//  InkCompanionApp.swift
//  InkCompanion
//
//  Created by 姜锋 on 11/1/23.
//

import SwiftUI

@main
struct InkCompanionApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
