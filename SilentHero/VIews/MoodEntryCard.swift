import SwiftUI

struct MoodEntryCard: View {
    let entry: MoodEntry
    var onDelete: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                Text(entry.mood ?? "Unknown Mood")
                    .font(.headline)
                    .foregroundColor(AppColors.calmBlue)

                Spacer()

                Button(action: onDelete) {
                    Image(systemName: "trash")
                        .foregroundColor(AppColors.alertRed)
                }
                .buttonStyle(.plain)
            }

            if let notes = entry.notes, !notes.isEmpty {
                Text(notes)
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }

            Text(entry.createdAt ?? Date(), formatter: itemFormatter)
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 2)
    }
}

private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "EEEE, MMMM d 'at' h:mm a" // e.g. Monday, July 22 at 9:45 PM
    return formatter
}()

