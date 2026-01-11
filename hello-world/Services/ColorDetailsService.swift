import Foundation

struct ColorDetails: Hashable {
    let name: String
    let hex: String
    let rgb: (Int, Int, Int)
    let hsv: (Double, Double, Double)
    let hsl: (Double, Double, Double)
    let luminance: Double
}

final class ColorDetailsService {
    private let colorNameService: ColorNameService

    init(colorNameService: ColorNameService) {
        self.colorNameService = colorNameService
    }

    func details(for argb: Int) -> ColorDetails {
        let name = colorNameService.nearestName(for: argb)
        let rgb = rgbComponents(from: argb)
        let hsv = rgbToHSV(r: rgb.r, g: rgb.g, b: rgb.b)
        let hsl = rgbToHSL(r: rgb.r, g: rgb.g, b: rgb.b)
        let luminance = relativeLuminance(r: rgb.r, g: rgb.g, b: rgb.b)
        return ColorDetails(
            name: name,
            hex: String(format: "#%02X%02X%02X", rgb.r, rgb.g, rgb.b),
            rgb: (rgb.r, rgb.g, rgb.b),
            hsv: hsv,
            hsl: hsl,
            luminance: luminance
        )
    }

    private func rgbComponents(from argb: Int) -> (r: Int, g: Int, b: Int) {
        let r = (argb >> 16) & 0xFF
        let g = (argb >> 8) & 0xFF
        let b = argb & 0xFF
        return (r, g, b)
    }

    private func rgbToHSV(r: Int, g: Int, b: Int) -> (Double, Double, Double) {
        let rf = Double(r) / 255
        let gf = Double(g) / 255
        let bf = Double(b) / 255
        let maxVal = max(rf, gf, bf)
        let minVal = min(rf, gf, bf)
        let delta = maxVal - minVal
        var hue: Double = 0

        if delta != 0 {
            if maxVal == rf {
                hue = ((gf - bf) / delta).truncatingRemainder(dividingBy: 6)
            } else if maxVal == gf {
                hue = ((bf - rf) / delta) + 2
            } else {
                hue = ((rf - gf) / delta) + 4
            }
            hue *= 60
            if hue < 0 { hue += 360 }
        }

        let saturation = maxVal == 0 ? 0 : delta / maxVal
        return (hue, saturation, maxVal)
    }

    private func rgbToHSL(r: Int, g: Int, b: Int) -> (Double, Double, Double) {
        let rf = Double(r) / 255
        let gf = Double(g) / 255
        let bf = Double(b) / 255
        let maxVal = max(rf, gf, bf)
        let minVal = min(rf, gf, bf)
        let delta = maxVal - minVal
        var hue: Double = 0

        if delta != 0 {
            if maxVal == rf {
                hue = ((gf - bf) / delta).truncatingRemainder(dividingBy: 6)
            } else if maxVal == gf {
                hue = ((bf - rf) / delta) + 2
            } else {
                hue = ((rf - gf) / delta) + 4
            }
            hue *= 60
            if hue < 0 { hue += 360 }
        }

        let lightness = (maxVal + minVal) / 2
        let saturation = delta == 0 ? 0 : delta / (1 - abs(2 * lightness - 1))
        return (hue, saturation, lightness)
    }

    private func relativeLuminance(r: Int, g: Int, b: Int) -> Double {
        func adjust(_ value: Int) -> Double {
            let normalized = Double(value) / 255
            return normalized <= 0.03928 ? normalized / 12.92 : pow((normalized + 0.055) / 1.055, 2.4)
        }
        let r = adjust(r)
        let g = adjust(g)
        let b = adjust(b)
        return 0.2126 * r + 0.7152 * g + 0.0722 * b
    }
}
