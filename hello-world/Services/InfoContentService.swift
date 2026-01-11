import Foundation

struct InfoContent: Codable, Hashable {
    let title: String
    let body: String
}

@MainActor
final class InfoContentService: ObservableObject {
    private let cacheURL: URL
    private let cacheTTL: TimeInterval = 60 * 60 * 24 * 7

    init() {
        cacheURL = FileManager.default
            .urls(for: .cachesDirectory, in: .userDomainMask)[0]
            .appendingPathComponent("info-content.json")
    }

    func loadCachedMetadata() {
        _ = loadCache()
    }

    func fetchContent(page: String, languageTag: String) async -> InfoContent? {
        if let cached = loadCache(), !cached.isExpired,
           let payload = cached.items[cacheKey(page: page, languageTag: languageTag)] {
            return payload
        }
        guard let url = URL(string: "https://eugland.github.io/color-picker-pages/\(page)/\(languageTag).json") else {
            return nil
        }
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let content = try JSONDecoder().decode(InfoContent.self, from: data)
            var updated = loadCache() ?? CachedInfo(items: [:], fetchedAt: Date())
            updated.items[cacheKey(page: page, languageTag: languageTag)] = content
            updated.fetchedAt = Date()
            try saveCache(updated)
            return content
        } catch {
            return nil
        }
    }

    private func cacheKey(page: String, languageTag: String) -> String {
        "\(page)-\(languageTag)"
    }

    private func loadCache() -> CachedInfo? {
        guard let data = try? Data(contentsOf: cacheURL) else { return nil }
        return try? JSONDecoder().decode(CachedInfo.self, from: data)
    }

    private func saveCache(_ cache: CachedInfo) throws {
        let data = try JSONEncoder().encode(cache)
        try data.write(to: cacheURL, options: [.atomic])
    }
}

private struct CachedInfo: Codable {
    var items: [String: InfoContent]
    var fetchedAt: Date

    var isExpired: Bool {
        Date().timeIntervalSince(fetchedAt) > 60 * 60 * 24 * 7
    }
}
