import Foundation

@MainActor
final class AppServices: ObservableObject {
    static let shared = AppServices()

    let analyticsTracker: AnalyticsTracker
    let colorNameService: ColorNameService
    let colorDetailsService: ColorDetailsService
    let paletteStore: PaletteStore
    let recentPicksStore: RecentPicksStore
    let settingsStore: SettingsStore
    let infoContentService: InfoContentService

    private init() {
        analyticsTracker = AnalyticsTracker()
        colorNameService = ColorNameService()
        colorDetailsService = ColorDetailsService(colorNameService: colorNameService)
        paletteStore = PaletteStore(analyticsTracker: analyticsTracker)
        recentPicksStore = RecentPicksStore(analyticsTracker: analyticsTracker)
        settingsStore = SettingsStore()
        infoContentService = InfoContentService()
    }

    func initialize() {
        colorNameService.loadCachedDatasetIfNeeded()
        paletteStore.load()
        recentPicksStore.load()
        infoContentService.loadCachedMetadata()
    }
}
