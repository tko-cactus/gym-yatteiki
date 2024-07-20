import Foundation
import SwiftUI
import SwiftData

struct TimePickerView: View {
    @Binding var selectedMinutes: Int
    @Binding var selectedSeconds: Int
    
    let minuteRange = 0...10
    let secondRange = stride(from: 0, through: 59, by: 15)
    
    var body: some View {
        VStack {
            HStack {
                Picker("Minutes", selection: $selectedMinutes) {
                    ForEach(minuteRange, id: \.self) { minute in
                        Text("\(minute) min").tag(minute)
                    }
                }
                .pickerStyle(.wheel)
                .frame(width: 100)
                .clipped()
                
                Picker("Seconds", selection: $selectedSeconds) {
                    ForEach(Array(secondRange), id: \.self) { second in
                        Text("\(second) sec").tag(second)
                    }
                }
                .pickerStyle(WheelPickerStyle())
                .frame(width: 100)
                .clipped()
            }
        }
    }
}

struct TimePickerView_Previews: PreviewProvider {
    static var previews: some View {
        TimePickerView(selectedMinutes: .constant(0), selectedSeconds: .constant(0))
    }
}
