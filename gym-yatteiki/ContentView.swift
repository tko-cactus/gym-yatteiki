import SwiftUI


struct ContentView: View {
    var body: some View {
        TabView {
            TimerListView()
                .tabItem {
                    Label("Timer", systemImage: "timer")
                }
            GraphView()
                .tabItem {
                    Label("Graph", systemImage: "chart.bar")
                }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
