import SwiftUI

struct ExploreView: View {
    @EnvironmentObject private var services: AppServices

    var body: some View {
        NavigationStack {
            List {
                NavigationLink("Info") {
                    InfoDetailView(page: "privacy")
                }
                NavigationLink("Terms") {
                    InfoDetailView(page: "terms")
                }
                NavigationLink("Usage") {
                    InfoDetailView(page: "usage")
                }
                NavigationLink("Language") {
                    LanguageSelectionView()
                }
            }
            .navigationTitle("Explore")
        }
    }
}

struct ExploreView_Previews: PreviewProvider {
    static var previews: some View {
        ExploreView()
            .environmentObject(AppServices.shared)
    }
}
