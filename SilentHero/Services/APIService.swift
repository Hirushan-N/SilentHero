import Foundation

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
}
