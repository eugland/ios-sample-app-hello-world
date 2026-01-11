import SwiftUI

struct PhotoPickView: View {
    @EnvironmentObject private var services: AppServices
    @State private var sampledColor: PickedColor = PickedColor(argb: 0xFFFFC107, name: "Sunrise")

    var body: some View {
        VStack(spacing: 24) {
            ColorPreviewCard(color: sampledColor)
            Text("Photo picker placeholder")
                .font(.headline)
                .foregroundColor(.secondary)
            Button("Sample Tap Color") {
                let name = services.colorNameService.nearestName(for: sampledColor.argb)
                sampledColor = PickedColor(argb: sampledColor.argb, name: name)
                services.recentPicksStore.addPick(argb: sampledColor.argb, name: name)
            }
            .buttonStyle(.borderedProminent)
        }
        .padding()
        .navigationTitle("Photo Picker")
    }
}

struct PhotoPickView_Previews: PreviewProvider {
    static var previews: some View {
        PhotoPickView()
            .environmentObject(AppServices.shared)
    }
}
