import SwiftUI

struct ColorPreviewCard: View {
    let color: PickedColor

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Rectangle()
                .fill(Color(argb: color.argb))
                .frame(height: 120)
                .cornerRadius(12)
            Text(color.name)
                .font(.headline)
            Text(String(format: "#%02X%02X%02X", (color.argb >> 16) & 0xFF, (color.argb >> 8) & 0xFF, color.argb & 0xFF))
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .padding()
        .background(Color(.secondarySystemBackground))
        .cornerRadius(16)
    }
}

struct ColorPreviewCard_Previews: PreviewProvider {
    static var previews: some View {
        ColorPreviewCard(color: PickedColor(argb: 0xFF8A2BE2, name: "Electric Violet"))
    }
}
