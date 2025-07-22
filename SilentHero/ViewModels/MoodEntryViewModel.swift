import Foundation
import CoreData
import SwiftUI

class MoodEntryViewModel: ObservableObject {
    @Published var mood: String = ""
    @Published var notes: String = ""

    private let context = PersistenceController.shared.container.viewContext

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
}
