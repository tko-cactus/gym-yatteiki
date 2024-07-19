import SwiftUI
import SwiftData

struct TimerListView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var recents: [LoadByMenu]
    @Query private var menus: [Menu]

    @State private var showingDrawer: Bool = false
    @State private var currentTime: String = "00:00"
    @State private var timer: Timer?
    @State private var timeRemaining: Int = 0
    @State var isPaused: Bool = true
        
    var body: some View {
        VStack {
            NavigationView {
                VStack {
                    List(recents, id: \.uuid) { recent in
                        let restTime = Duration.seconds(recent.rest).formatted(.time(pattern: .hourMinuteSecond))
                        NavigationLink(destination: TimerView()) {
                            HStack {
                                VStack(alignment: .leading) {
                                    Text(restTime)
                                        .font(.largeTitle)
                                        .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                                    Text("メニュー")
                                }
                                Spacer()
                            }
                            .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                                Button {
                                    print("delete button taped")
                                    modelContext.delete(recent)
                                } label: {
                                    Text("delete")
                                }
                            }
                            .tint(.red)
                        }
                        .listStyle(.automatic)
                        .onLongPressGesture {
                            showingDrawer = true
                        }
                    }
                }
                .navigationTitle("Recents")
                .toolbar {
                    HStack {
                        Button(action: {
                            showingDrawer = true
                        }) {
                            Image(systemName: "plus").foregroundColor(.blue)
                        }
                    }
                }
                .overlay(
                    BottomDrawer(isOpen: $showingDrawer) {
                        VStack {
                            Text("Drawer Content")
                                .font(.headline)
                                .padding()
                            Button(action: {
                                // TODO 後で新規トレーニングを追加する処理を詰める
                                let newMenu = Menu(name: "New Menu", type: .ARM)
                                let newLoad = LoadByMenu.create(menu: newMenu)
                                modelContext.insert(newLoad)
                                do {
                                    try modelContext.save()
                                    print("Successfully saved new load: \(newLoad)")
                                } catch {
                                    print("Error occurred while saving new load: \(error)")
                                }
                            }, label: {
                                Text("Add New Load")
                            })
                            Button("Close") {
                                showingDrawer = false
                            }
                            .padding()
                            .background(Color.red)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                        }
                    }
                )
            }.task {
                print(modelContext.sqliteCommand)
            }
        }
    }
    
    func startTimer() {
        stopTimer()
        timeRemaining = 120 // Example: 2 minutes
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            if timeRemaining > 0 {
                timeRemaining -= 1
                currentTime = formatTime(timeRemaining)
            } else {
                stopTimer()
            }
        }
    }
    
    func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    func formatTime(_ seconds: Int) -> String {
        let minutes = seconds / 60
        let seconds = seconds % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
}

struct TimerListView_Previews: PreviewProvider {
    static var previews: some View {
        TimerListView()
            .modelContainer(SampleLoadByMenu.previewContainer)
    }
}
