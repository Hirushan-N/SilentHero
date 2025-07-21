import Foundation
import CoreData

class MoodEntryViewModel: ObservableObject {
    @Published var mood: String = ""
    @Published var notes: String = ""

    func saveMoodEntry() {
        let context = PersistenceController.shared.container.viewContext
        let newEntry = MoodEntry(context: context)
        newEntry.mood = mood
        newEntry.notes = notes
        newEntry.createdAt = Date()

        do {
            try context.save()
        } catch {
            print("Failed to save mood entry: \(error)")
        }
    }
}
