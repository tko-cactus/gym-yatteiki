import Foundation
import SwiftUI
import Charts

struct GraphView: View {
    var data = [
        "4/1": 1000,
        "4/2": 1500,
        "4/4": 1200,
        "4/3": 800
    ]
    
    var body: some View {
        NavigationStack {
            Chart {
                ForEach(data.sorted(by: { $0.key < $1.key }), id: \.key) { key, value in
                    BarMark(
                        x: .value("Date", key),
                        y: .value("Price", value)
                    )
                    .cornerRadius(15)
                }
            }
            .frame(height: 350)
            .navigationTitle("Graph")
        }
    }
}

struct GraphView_Previews: PreviewProvider {
    static var previews: some View {
        GraphView()
    }
}
