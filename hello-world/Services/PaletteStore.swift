import Foundation

@MainActor
final class PaletteStore: ObservableObject {
    @Published private(set) var palettes: [Palette] = []

    private let analyticsTracker: AnalyticsTracker
    private let fileURL: URL
    private let seededKey = "palettes_seeded"

    init(analyticsTracker: AnalyticsTracker) {
        self.analyticsTracker = analyticsTracker
        fileURL = FileManager.default
            .urls(for: .applicationSupportDirectory, in: .userDomainMask)[0]
            .appendingPathComponent("palettes.json")
    }

    func load() {
        if let data = try? Data(contentsOf: fileURL),
           let stored = try? JSONDecoder().decode([Palette].self, from: data) {
            palettes = stored
        } else {
            seedIfNeeded()
        }
    }

    func addPalette(name: String) {
        let palette = Palette(name: name)
        palettes.insert(palette, at: 0)
        analyticsTracker.trackPaletteCreated(name: name)
        save()
    }

    func updatePalette(_ palette: Palette) {
        guard let index = palettes.firstIndex(where: { $0.id == palette.id }) else { return }
        var updated = palette
        updated.updatedAt = Date()
        palettes[index] = updated
        save()
    }

    private func save() {
        do {
            try FileManager.default.createDirectory(
                at: fileURL.deletingLastPathComponent(),
                withIntermediateDirectories: true
            )
            let data = try JSONEncoder().encode(palettes)
            try data.write(to: fileURL, options: [.atomic])
        } catch {
            #if DEBUG
            print("Failed to save palettes: \(error)")
            #endif
        }
    }

    private func seedIfNeeded() {
        let defaults = UserDefaults.standard
        guard !defaults.bool(forKey: seededKey) else { return }
        palettes = [
            Palette(name: "Warm Neutrals"),
            Palette(name: "Ocean Cool"),
            Palette(name: "Studio Lights")
        ]
        defaults.set(true, forKey: seededKey)
        save()
    }
}
