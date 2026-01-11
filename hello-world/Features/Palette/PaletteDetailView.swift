import SwiftUI

struct PaletteDetailView: View {
    @EnvironmentObject private var services: AppServices
    @State var palette: Palette

    var body: some View {
        Form {
            Section("Details") {
                TextField("Name", text: $palette.name)
                TextField("Note", text: $palette.note)
            }

            Section("Colors") {
                if palette.colors.isEmpty {
                    Text("No colors yet")
                        .foregroundColor(.secondary)
                } else {
                    ForEach(palette.colors) { color in
                        ColorPreviewRow(color: color)
                    }
                }
            }
        }
        .navigationTitle(palette.name)
        .toolbar {
            Button("Save") {
                services.paletteStore.updatePalette(palette)
            }
        }
    }
}

struct PaletteDetailView_Previews: PreviewProvider {
    static var previews: some View {
        PaletteDetailView(palette: Palette(name: "Preview"))
            .environmentObject(AppServices.shared)
    }
}
