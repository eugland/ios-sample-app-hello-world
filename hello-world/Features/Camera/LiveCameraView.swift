import SwiftUI

struct LiveCameraView: View {
    @EnvironmentObject private var services: AppServices
    @State private var sampledColor: PickedColor = PickedColor(argb: 0xFF8A2BE2, name: "Sample")

    var body: some View {
        VStack(spacing: 24) {
            ColorPreviewCard(color: sampledColor)
            Text("Camera preview placeholder")
                .font(.headline)
                .foregroundColor(.secondary)
            Button("Sample Center Color") {
                let name = services.colorNameService.nearestName(for: sampledColor.argb)
                sampledColor = PickedColor(argb: sampledColor.argb, name: name)
                services.recentPicksStore.addPick(argb: sampledColor.argb, name: name)
            }
            .buttonStyle(.borderedProminent)
        }
        .padding()
        .navigationTitle("Live Camera")
    }
}

struct LiveCameraView_Previews: PreviewProvider {
    static var previews: some View {
        LiveCameraView()
            .environmentObject(AppServices.shared)
    }
}
