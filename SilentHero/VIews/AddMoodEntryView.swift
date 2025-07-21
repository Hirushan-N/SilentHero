import SwiftUI

struct AddMoodEntryView: View {
    @StateObject private var viewModel = MoodEntryViewModel()
    @Environment(\.dismiss) var dismiss

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("How are you feeling?")
                    .foregroundColor(AppColors.calmBlue)) {
                    TextField("Mood (e.g., Happy, Stressed)", text: $viewModel.mood)
                        .foregroundColor(.primary)
                }

                Section(header: Text("Notes (optional)")
                    .foregroundColor(AppColors.calmBlue)) {
                    TextEditor(text: $viewModel.notes)
                        .frame(height: 120)
                        .foregroundColor(.primary)
                        .background(AppColors.neutralGray.opacity(0.2))
                        .cornerRadius(8)
                }
            }
            .navigationTitle("New Mood Entry")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        viewModel.saveMoodEntry()
                        dismiss()
                    }
                    .foregroundColor(AppColors.calmBlue)
                }

                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundColor(AppColors.alertRed)
                }
            }
        }
    }
}
