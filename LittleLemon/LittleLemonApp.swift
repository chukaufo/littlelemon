//
//  LittleLemonApp.swift
//  LittleLemon
//
//  Created by Chuka Uwefoh on 2026-07-27.
//

import SwiftUI
import CoreData

@main
struct LittleLemonApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
