import SwiftUI

struct MainTabView: View {
    @Environment(\.managedObjectContext) private var viewContext

    var body: some View {
        TabView {
            NavigationStack {
                MoodJournalView()
            }
            .environment(\.managedObjectContext, viewContext)
            .tabItem {
                Label("Journal", systemImage: "book")
            }

            PanicView()
                .tabItem {
                    Label("Panic", systemImage: "exclamationmark.triangle.fill")
                }

            SettingsView()
                .tabItem {
                    Label("Settings", systemImage: "gear")
                }
        }
        .accentColor(AppColors.calmBlue)
    }
}
