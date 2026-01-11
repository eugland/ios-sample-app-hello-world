import Foundation

final class AnalyticsTracker {
    func trackColorPick(name: String, argb: Int) {
        logEvent("color_pick", properties: ["name": name, "argb": argb])
    }

    func trackColorSaved(name: String, argb: Int) {
        logEvent("color_saved", properties: ["name": name, "argb": argb])
    }

    func trackPaletteCreated(name: String) {
        logEvent("palette_create", properties: ["name": name])
    }

    private func logEvent(_ name: String, properties: [String: Any]) {
        #if DEBUG
        print("[Analytics] \(name): \(properties)")
        #endif
    }
}
