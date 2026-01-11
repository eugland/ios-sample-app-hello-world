import SwiftUI

struct ColorDetailsView: View {
    @EnvironmentObject private var services: AppServices
    let argb: Int

    var body: some View {
        let details = services.colorDetailsService.details(for: argb)
        Form {
            Section("Preview") {
                ColorPreviewCard(color: PickedColor(argb: argb, name: details.name))
            }
            Section("Values") {
                DetailRow(label: "Name", value: details.name)
                DetailRow(label: "Hex", value: details.hex)
                DetailRow(label: "RGB", value: "\(details.rgb.0), \(details.rgb.1), \(details.rgb.2)")
                DetailRow(label: "HSV", value: String(format: "%.0f°, %.2f, %.2f", details.hsv.0, details.hsv.1, details.hsv.2))
                DetailRow(label: "HSL", value: String(format: "%.0f°, %.2f, %.2f", details.hsl.0, details.hsl.1, details.hsl.2))
                DetailRow(label: "Luminance", value: String(format: "%.2f", details.luminance))
            }
        }
        .navigationTitle("Color Details")
    }
}

struct ColorDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        ColorDetailsView(argb: 0xFF4CAF50)
            .environmentObject(AppServices.shared)
    }
}
