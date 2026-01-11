import SwiftUI

struct ColorSliderView: View {
    enum Mode: String, CaseIterable, Identifiable {
        case rgb = "RGB"
        case hsl = "HSL"
        case hsv = "HSV"
        case cmyk = "CMYK"

        var id: String { rawValue }
    }

    @EnvironmentObject private var services: AppServices
    @State private var mode: Mode = .rgb
    @State private var red: Double = 138
    @State private var green: Double = 43
    @State private var blue: Double = 226

    var body: some View {
        VStack(spacing: 16) {
            Picker("Mode", selection: $mode) {
                ForEach(Mode.allCases) { mode in
                    Text(mode.rawValue).tag(mode)
                }
            }
            .pickerStyle(.segmented)

            ColorPreviewCard(color: PickedColor(argb: argbValue, name: services.colorNameService.nearestName(for: argbValue)))

            VStack {
                SliderRow(label: "R", value: $red, range: 0...255)
                SliderRow(label: "G", value: $green, range: 0...255)
                SliderRow(label: "B", value: $blue, range: 0...255)
            }

            Button("Copy Hex") {
                UIPasteboard.general.string = String(format: "#%02X%02X%02X", Int(red), Int(green), Int(blue))
            }
            .buttonStyle(.bordered)
        }
        .padding()
        .navigationTitle("Color Slider")
    }

    private var argbValue: Int {
        (0xFF << 24) | (Int(red) << 16) | (Int(green) << 8) | Int(blue)
    }
}

struct ColorSliderView_Previews: PreviewProvider {
    static var previews: some View {
        ColorSliderView()
            .environmentObject(AppServices.shared)
    }
}
