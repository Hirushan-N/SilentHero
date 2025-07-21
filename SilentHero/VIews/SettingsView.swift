import SwiftUI

struct SettingsView: View {
    var body: some View {
        Form {
            Section(header: Text("App Settings")) {
                Toggle("Enable Face ID", isOn: .constant(true))
                Toggle("Send Weekly Report", isOn: .constant(false))
            }

            Section {
                Button("About App") {
                    // Placeholder
                }
            }
        }
        .navigationTitle("Settings")
    }
}
