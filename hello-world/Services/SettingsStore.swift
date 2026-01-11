import Foundation
import SwiftUI

@MainActor
final class SettingsStore: ObservableObject {
    @AppStorage("theme_mode") var themeMode: ThemeMode = .system
    @AppStorage("crosshair_size") var crosshairSize: Double = 24
    @AppStorage("crosshair_style") var crosshairStyle: CrosshairStyle = .circle
    @AppStorage("picker_sensitivity") var pickerSensitivity: Double = 0.5
    @AppStorage("language_tag") var languageTag: String = "en"
}

enum ThemeMode: String, CaseIterable, Codable, Identifiable {
    case system
    case light
    case dark

    var id: String { rawValue }
}

enum CrosshairStyle: String, CaseIterable, Codable, Identifiable {
    case circle
    case square

    var id: String { rawValue }
}
