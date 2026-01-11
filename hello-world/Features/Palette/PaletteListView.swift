import SwiftUI

struct PaletteListView: View {
    @EnvironmentObject private var services: AppServices
    @State private var newPaletteName = ""

    var body: some View {
        NavigationStack {
            List {
                Section("Create") {
                    HStack {
                        TextField("New palette name", text: $newPaletteName)
                        Button("Add") {
                            guard !newPaletteName.isEmpty else { return }
                            services.paletteStore.addPalette(name: newPaletteName)
                            newPaletteName = ""
                        }
                        .buttonStyle(.bordered)
                    }
                }

                Section("Palettes") {
                    ForEach(services.paletteStore.palettes) { palette in
                        NavigationLink(palette.name) {
                            PaletteDetailView(palette: palette)
                        }
                    }
                }
            }
            .navigationTitle("Palettes")
        }
    }
}

struct PaletteListView_Previews: PreviewProvider {
    static var previews: some View {
        PaletteListView()
            .environmentObject(AppServices.shared)
    }
}
