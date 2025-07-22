import SwiftUI
import CoreData

struct MoodJournalView: View {
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \MoodEntry.createdAt, ascending: false)],
        animation: .default)
    private var moodEntries: FetchedResults<MoodEntry>

    @State private var showAddMood = false

    var body: some View {
        ZStack {
            AppColors.neutralGray.ignoresSafeArea()

            if moodEntries.isEmpty {
                VStack {
                    Spacer()
                    Text("No mood entries yet.")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                    Spacer()
                }
            } else {
                List {
                    ForEach(moodEntries) { entry in
                        VStack(alignment: .leading, spacing: 6) {
                            Text(entry.mood ?? "Unknown Mood")
                                .font(.headline)
                                .foregroundColor(AppColors.calmBlue)

                            if let notes = entry.notes, !notes.isEmpty {
                                Text(notes)
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                            }

                            Text(entry.createdAt ?? Date(), formatter: itemFormatter)
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        .padding(.vertical, 4)
                    }
                    .onDelete(perform: deleteEntries)
                }
                .listStyle(.plain)
            }
        }
        .navigationTitle("Mood Journal")
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                EditButton().foregroundColor(AppColors.alertRed)
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: { showAddMood = true }) {
                    Label("Add Entry", systemImage: "plus")
                        .foregroundColor(AppColors.calmBlue)
                }
            }
        }
        .sheet(isPresented: $showAddMood) {
            AddMoodEntryView()
                .environment(\.managedObjectContext, viewContext)
        }
    }

    private func deleteEntries(offsets: IndexSet) {
        withAnimation {
            offsets.map { moodEntries[$0] }.forEach(viewContext.delete)

            do {
                try viewContext.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
}

private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .short
    return formatter
}()
