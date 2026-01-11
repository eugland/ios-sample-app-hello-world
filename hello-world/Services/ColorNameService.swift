import Foundation

struct ColorNameEntry: Codable, Hashable {
    let name: String
    let argb: Int
}

@MainActor
final class ColorNameService: ObservableObject {
    @Published private(set) var colors: [ColorNameEntry] = []
    private let cacheURL: URL
    private let cacheTTL: TimeInterval = 60 * 60 * 24 * 7

    init() {
        cacheURL = FileManager.default
            .urls(for: .cachesDirectory, in: .userDomainMask)[0]
            .appendingPathComponent("color-dataset.json")
    }

    func loadCachedDatasetIfNeeded() {
        if let cached = loadCachedDataset(), !cached.isExpired {
            colors = cached.entries
            return
        }
        loadBundledDataset()
    }

    func refreshDataset(languageTag: String) async {
        guard let url = URL(string: "https://eugland.github.io/color-picker-pages/colors/\(languageTag).json") else {
            return
        }
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let entries = try JSONDecoder().decode([ColorNameEntry].self, from: data)
            colors = entries
            try saveCache(entries: entries)
        } catch {
            loadBundledDataset()
        }
    }

    func nearestName(for argb: Int) -> String {
        guard !colors.isEmpty else { return "Unknown" }
        let target = rgbComponents(from: argb)
        let best = colors.min { lhs, rhs in
            colorDistance(rgbComponents(from: lhs.argb), target)
                < colorDistance(rgbComponents(from: rhs.argb), target)
        }
        return best?.name ?? "Unknown"
    }

    private func loadBundledDataset() {
        guard let url = Bundle.main.url(forResource: "colors", withExtension: "json") else {
            colors = []
            return
        }
        do {
            let data = try Data(contentsOf: url)
            colors = try JSONDecoder().decode([ColorNameEntry].self, from: data)
        } catch {
            colors = []
        }
    }

    private func loadCachedDataset() -> CachedDataset? {
        guard let data = try? Data(contentsOf: cacheURL) else { return nil }
        return try? JSONDecoder().decode(CachedDataset.self, from: data)
    }

    private func saveCache(entries: [ColorNameEntry]) throws {
        let payload = CachedDataset(entries: entries, fetchedAt: Date())
        let data = try JSONEncoder().encode(payload)
        try data.write(to: cacheURL, options: [.atomic])
    }

    private func rgbComponents(from argb: Int) -> (r: Double, g: Double, b: Double) {
        let r = Double((argb >> 16) & 0xFF)
        let g = Double((argb >> 8) & 0xFF)
        let b = Double(argb & 0xFF)
        return (r, g, b)
    }

    private func colorDistance(_ lhs: (r: Double, g: Double, b: Double), _ rhs: (r: Double, g: Double, b: Double)) -> Double {
        let dr = lhs.r - rhs.r
        let dg = lhs.g - rhs.g
        let db = lhs.b - rhs.b
        return dr * dr + dg * dg + db * db
    }
}

private struct CachedDataset: Codable {
    let entries: [ColorNameEntry]
    let fetchedAt: Date

    var isExpired: Bool {
        Date().timeIntervalSince(fetchedAt) > 60 * 60 * 24 * 7
    }
}
