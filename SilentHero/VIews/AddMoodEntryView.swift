import SwiftUI

struct AddMoodEntryView: View {
    @StateObject private var viewModel = MoodEntryViewModel()
    @Environment(\.dismiss) var dismiss

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("How are you feeling?")
                .font(.headline)
                .foregroundColor(AppColors.calmBlue)

            TextField("e.g., Happy, Anxious", text: $viewModel.mood)
                .padding(12)
                .background(Color(.systemBackground))
                .cornerRadius(10)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                )

            Text("Add some notes (optional)")
                .font(.headline)
                .foregroundColor(AppColors.calmBlue)

            TextEditor(text: $viewModel.notes)
                .frame(height: 120)
                .padding(8)
                .background(Color(.systemBackground))
                .cornerRadius(10)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                )

            Spacer()

            HStack(spacing: 16) {
                Button("Cancel") {
                    dismiss()
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(AppColors.alertRed.opacity(0.9))
                .foregroundColor(.white)
                .cornerRadius(12)

                Button("Save") {
                    viewModel.saveMoodEntry()
                    dismiss()
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(AppColors.calmBlue)
                .foregroundColor(.white)
                .cornerRadius(12)
            }
        }
        .padding()
        .background(AppColors.neutralGray.ignoresSafeArea())
        .presentationDetents([.medium]) // 👈 Makes it a card-style sheet
        .presentationDragIndicator(.visible)
    }
}
