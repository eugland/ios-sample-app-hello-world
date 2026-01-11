import Foundation

@MainActor
final class RecentPicksStore: ObservableObject {
    @Published private(set) var history: [PickedColor] = []
    @Published private(set) var saved: [PickedColor] = []

    private let analyticsTracker: AnalyticsTracker
    private let fileURL: URL
    private let maxItems = 100

    init(analyticsTracker: AnalyticsTracker) {
        self.analyticsTracker = analyticsTracker
        fileURL = FileManager.default
            .urls(for: .applicationSupportDirectory, in: .userDomainMask)[0]
            .appendingPathComponent("recents.json")
    }

    func load() {
        guard let data = try? Data(contentsOf: fileURL) else { return }
        if let stored = try? JSONDecoder().decode(StoragePayload.self, from: data) {
            history = stored.history
            saved = stored.saved
        }
    }

    func addPick(argb: Int, name: String) {
        let pick = PickedColor(argb: argb, name: name)
        history.removeAll { $0.argb == argb }
        history.insert(pick, at: 0)
        history = Array(history.prefix(maxItems))
        analyticsTracker.trackColorPick(name: name, argb: argb)
        save()
    }

    func toggleSaved(argb: Int, name: String) {
        if let index = saved.firstIndex(where: { $0.argb == argb }) {
            saved.remove(at: index)
        } else {
            let pick = PickedColor(argb: argb, name: name)
            saved.insert(pick, at: 0)
            saved = Array(saved.prefix(maxItems))
            analyticsTracker.trackColorSaved(name: name, argb: argb)
        }
        save()
    }

    private func save() {
        let payload = StoragePayload(history: history, saved: saved)
        do {
            try FileManager.default.createDirectory(
                at: fileURL.deletingLastPathComponent(),
                withIntermediateDirectories: true
            )
            let data = try JSONEncoder().encode(payload)
            try data.write(to: fileURL, options: [.atomic])
        } catch {
            #if DEBUG
            print("Failed to save recents: \(error)")
            #endif
        }
    }
}

private struct StoragePayload: Codable {
    let history: [PickedColor]
    let saved: [PickedColor]
}
