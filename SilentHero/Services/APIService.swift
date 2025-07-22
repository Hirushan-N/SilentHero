import Foundation

struct MoodEntryDTO: Identifiable, Codable {
    let id: UUID
    let mood: String
    let notes: String
    let createdAt: Date

    enum CodingKeys: String, CodingKey {
        case id, mood, notes, createdAt
    }

    static let dateDecodingStrategy: JSONDecoder.DateDecodingStrategy = .custom { decoder in
        let container = try decoder.singleValueContainer()
        let dateString = try container.decode(String.self)

        let formats = [
            "yyyy-MM-dd'T'HH:mm:ss.SSSSSSZ",  // 2025-07-22T18:00:30.21Z
            "yyyy-MM-dd'T'HH:mm:ss.SSSSZ",    // 2025-07-22T18:00:30.707Z
            "yyyy-MM-dd'T'HH:mm:ssZ"          // 2025-07-22T18:12:52Z
        ]

        for format in formats {
            let formatter = DateFormatter()
            formatter.locale = Locale(identifier: "en_US_POSIX")
            formatter.dateFormat = format
            formatter.timeZone = .current

            if let date = formatter.date(from: dateString) {
                return date
            }
        }

        throw DecodingError.dataCorruptedError(
            in: container,
            debugDescription: "Date string does not match any expected format."
        )
    }
}

class APIService {
    static let shared = APIService()
    private init() {}

    func sendPanicAlert(completion: @escaping (Bool) -> Void) {
        guard let url = URL(string: "https://your-api.com/panic") else {
            completion(false)
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"

        URLSession.shared.dataTask(with: request) { _, response, _ in
            let success = (response as? HTTPURLResponse)?.statusCode == 200
            completion(success)
        }.resume()
    }

    func fetchMoodEntries(completion: @escaping ([MoodEntryDTO]) -> Void) {
        guard let url = URL(string: "http://localhost:5283/api/mood") else {
            completion([])
            return
        }

        URLSession.shared.dataTask(with: url) { data, _, _ in
            if let data = data {
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = MoodEntryDTO.dateDecodingStrategy
                do {
                    let entries = try decoder.decode([MoodEntryDTO].self, from: data)
                    completion(entries)
                } catch {
                    print("❌ Decoding error: \(error)")
                    print("Raw response:\n\(String(data: data, encoding: .utf8) ?? "")")
                    completion([])
                }
            } else {
                completion([])
            }
        }.resume()
    }



    func addMoodEntry(_ entry: MoodEntryDTO, completion: @escaping (Bool) -> Void) {
        guard let url = URL(string: "http://localhost:5283/api/mood") else {
            completion(false)
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        
        guard let jsonData = try? encoder.encode(entry) else {
            completion(false)
            return
        }

        request.httpBody = jsonData

        URLSession.shared.dataTask(with: request) { _, response, _ in
            let statusCode = (response as? HTTPURLResponse)?.statusCode
            let success = statusCode == 200 || statusCode == 201
            completion(success)
        }.resume()
    }


    func deleteMoodEntry(id: UUID, completion: @escaping (Bool) -> Void) {
        guard let url = URL(string: "http://localhost:5283/api/mood/\(id.uuidString)") else {
            completion(false)
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"

        URLSession.shared.dataTask(with: request) { _, response, _ in
            let success = (response as? HTTPURLResponse)?.statusCode == 200
            completion(success)
        }.resume()
    }
}
