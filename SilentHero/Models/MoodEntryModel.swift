import Foundation

struct MoodEntryModel: Codable, Identifiable {
    let id: UUID
    let mood: String
    let notes: String
    let createdAt: Date
}
