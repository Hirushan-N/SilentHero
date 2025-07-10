//
//  SilentHeroApp.swift
//  SilentHero
//
//  Created by Hirushan on 2025-07-10.
//

import SwiftUI

@main
struct SilentHeroApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
