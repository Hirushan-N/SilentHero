import SwiftUI

struct SplashScreenView: View {
    @AppStorage("useBiometric") var useBiometric = true
    @State private var isUnlocked = false
    @State private var showAlert = false
    @State private var authErrorMessage = ""
    @Environment(\.managedObjectContext) private var viewContext

    var body: some View {
        ZStack {
            AppColors.calmBlue.ignoresSafeArea()
            VStack {
                Image(systemName: "shield.lefthalf.filled")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100)
                    .foregroundColor(.white)
                Text("SilentHero")
                    .font(.largeTitle)
                    .foregroundColor(.white)
                    .bold()
            }
        }
        .onAppear {
            handleSplash()
        }
        .fullScreenCover(isPresented: $isUnlocked) {
            MainTabView()
                .environment(\.managedObjectContext, viewContext) 
        }
        .alert("Authentication Failed", isPresented: $showAlert) {
            Button("Try Again") {
                handleSplash()
            }
            Button("Cancel", role: .cancel) {}
        } message: {
            Text(authErrorMessage)
        }
    }

    private func handleSplash() {
        if useBiometric {
            BiometricAuthManager.shared.authenticateUser { success, error in
                if success {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        isUnlocked = true
                    }
                } else {
                    authErrorMessage = error ?? "Unknown error"
                    showAlert = true
                }
            }
        } else {
            // Delay for normal splash effect
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                isUnlocked = true
            }
        }
    }
}
