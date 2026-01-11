import SwiftUI

struct ContentView: View {
    @EnvironmentObject private var services: AppServices

    var body: some View {
        TabView {
            PaletteListView()
                .tabItem {
                    Label("Palette", systemImage: "square.grid.2x2")
                }

            CameraTabView()
                .tabItem {
                    Label("Camera", systemImage: "camera")
                }

            ExploreView()
                .tabItem {
                    Label("Explore", systemImage: "sparkles")
                }
        }
        .environment(\.locale, Locale(identifier: services.settingsStore.languageTag))
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(AppServices.shared)
    }
}
