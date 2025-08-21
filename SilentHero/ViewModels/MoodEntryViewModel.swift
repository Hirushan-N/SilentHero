import Foundation
import CoreData
import SwiftUI

class MoodEntryViewModel: ObservableObject {
    @Published var mood: String = ""
    @Published var notes: String = ""

    private let context = PersistenceController.shared.container.viewContext

    // MARK: - Save new mood entry
    func saveMoodEntry() {
        let newEntryDTO = MoodEntryDTO(
            id: UUID(),
            mood: mood,
            notes: notes,
            createdAt: Date()
        )

        APIService.shared.addMoodEntry(newEntryDTO) { success in
            DispatchQueue.main.async {
                if success {
                    self.saveToCoreData(dto: newEntryDTO)
                } else {
                    print("❌ Failed to save to API")
                }
            }
        }
    }

    // MARK: - Sync entries from API
    func syncMoodEntriesWithAPI() {
        APIService.shared.fetchMoodEntries { entries in
            DispatchQueue.main.async {
                self.clearCoreData()
                entries.forEach { self.saveToCoreData(dto: $0) }
            }
        }
    }

    // MARK: - Save to Core Data
    private func saveToCoreData(dto: MoodEntryDTO) {
        let newEntry = MoodEntry(context: context)
        newEntry.id = dto.id
        newEntry.mood = dto.mood
        newEntry.notes = dto.notes
        newEntry.createdAt = dto.createdAt

        do {
            try context.save()
            print("✅ Mood saved locally")
        } catch {
            print("❌ Core Data save failed: \(error)")
        }
    }

    // MARK: - Clear existing Core Data entries
    private func clearCoreData() {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = MoodEntry.fetchRequest()
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)

        do {
            try context.execute(deleteRequest)
            try context.save()
            print("🧼 Cleared old Core Data mood entries")
        } catch {
            print("❌ Failed to clear Core Data: \(error)")
        }
    }
}
