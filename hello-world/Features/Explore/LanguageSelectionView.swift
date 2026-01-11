import SwiftUI

struct LanguageSelectionView: View {
    @EnvironmentObject private var services: AppServices
    private let languages = ["en", "es", "fr", "de", "ja"]

    var body: some View {
        List {
            ForEach(languages, id: \.self) { tag in
                HStack {
                    Text(tag.uppercased())
                    Spacer()
                    if services.settingsStore.languageTag == tag {
                        Image(systemName: "checkmark")
                    }
                }
                .contentShape(Rectangle())
                .onTapGesture {
                    services.settingsStore.languageTag = tag
                }
            }
        }
        .navigationTitle("Language")
    }
}

struct LanguageSelectionView_Previews: PreviewProvider {
    static var previews: some View {
        LanguageSelectionView()
            .environmentObject(AppServices.shared)
    }
}
