import SwiftUI

extension Color {
    init(argb: Int) {
        let red = Double((argb >> 16) & 0xFF) / 255
        let green = Double((argb >> 8) & 0xFF) / 255
        let blue = Double(argb & 0xFF) / 255
        self.init(red: red, green: green, blue: blue)
    }
}
