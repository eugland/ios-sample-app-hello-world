import SwiftUI

struct ColorPreviewRow: View {
    let color: PickedColor

    var body: some View {
        HStack(spacing: 12) {
            Circle()
                .fill(Color(argb: color.argb))
                .frame(width: 32, height: 32)
            VStack(alignment: .leading) {
                Text(color.name)
                    .font(.headline)
                Text(String(format: "#%02X%02X%02X", (color.argb >> 16) & 0xFF, (color.argb >> 8) & 0xFF, color.argb & 0xFF))
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
    }
}

struct ColorPreviewRow_Previews: PreviewProvider {
    static var previews: some View {
        ColorPreviewRow(color: PickedColor(argb: 0xFFFF9800, name: "Amber"))
    }
}
