import SwiftUI

struct SliderRow: View {
    let label: String
    @Binding var value: Double
    let range: ClosedRange<Double>

    var body: some View {
        HStack {
            Text(label)
                .frame(width: 24, alignment: .leading)
            Slider(value: $value, in: range)
            Text("\(Int(value))")
                .frame(width: 40, alignment: .trailing)
                .monospacedDigit()
        }
    }
}

struct SliderRow_Previews: PreviewProvider {
    static var previews: some View {
        SliderRow(label: "R", value: .constant(128), range: 0...255)
            .padding()
    }
}
