import SwiftUI

import SwiftUI

@main
struct SilentHeroApp: App {
    let persistenceController = PersistenceController.shared
    @AppStorage("token") var token: String = ""

    var body: some Scene {
        WindowGroup {
            if token.isEmpty {
                LoginView()
                    .environment(\.managedObjectContext, persistenceController.container.viewContext)
            } else {
                NavigationStack {
                    SplashScreenView()
                        .environment(\.managedObjectContext, persistenceController.container.viewContext)
                }
            }
        }
    }
}


