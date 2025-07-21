import SwiftUI

struct PanicView: View {
    @State private var isSending = false
    @State private var showConfirmation = false

    var body: some View {
        VStack(spacing: 20) {
            Text("Send a silent panic alert if you’re in danger.")
                .multilineTextAlignment(.center)

            Button(action: sendPanicAlert) {
                Text(isSending ? "Sending..." : "Send Panic Alert")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(AppColors.alertRed)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .disabled(isSending)

            if showConfirmation {
                Text("Panic alert sent!")
                    .foregroundColor(.green)
                    .bold()
            }
        }
        .padding()
        .navigationTitle("Panic Alert")
    }

    private func sendPanicAlert() {
        isSending = true
        APIService.shared.sendPanicAlert { success in
            DispatchQueue.main.async {
                self.isSending = false
                self.showConfirmation = success
            }
        }
    }
}
