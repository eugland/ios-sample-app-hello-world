import SwiftUI

struct InfoDetailView: View {
    @EnvironmentObject private var services: AppServices
    @State private var content: InfoContent?

    let page: String

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                if let content {
                    Text(content.title)
                        .font(.title.bold())
                    Text(content.body)
                        .font(.body)
                } else {
                    Text("Loading content...")
                        .foregroundColor(.secondary)
                }
            }
            .padding()
        }
        .navigationTitle("Info")
        .task {
            let language = services.settingsStore.languageTag
            content = await services.infoContentService.fetchContent(page: page, languageTag: language)
        }
    }
}

struct InfoDetailView_Previews: PreviewProvider {
    static var previews: some View {
        InfoDetailView(page: "privacy")
            .environmentObject(AppServices.shared)
    }
}
