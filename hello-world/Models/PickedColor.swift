import Foundation

struct PickedColor: Codable, Identifiable, Hashable {
    let id: String
    let argb: Int
    let name: String
    let createdAt: Date

    init(id: String = UUID().uuidString, argb: Int, name: String, createdAt: Date = Date()) {
        self.id = id
        self.argb = argb
        self.name = name
        self.createdAt = createdAt
    }
}
