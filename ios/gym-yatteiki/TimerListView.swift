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
    @State var newMenuName: String = ""
    @State var newMenuType: MenuType = .ARM
    @State var newRestTimeMinutes: Int = 0
    @State var newRestTimeSeconds: Int = 0
        
    var body: some View {
        VStack {
            NavigationView {
                VStack {
                    List(recents, id: \.uuid) { recent in
                        NavigationLink(destination: TimerView()) {
                            HStack {
                                VStack(alignment: .leading) {
                                    Text(recent.menu.name)
                                        .font(.title)
                                        .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                                    Text(recent.menu.type.rawValue + " - " + recent.getRestTime())
                                        .font(.subheadline)
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
                        .sheet(isPresented: $showingDrawer, content: {
                            VStack {
                                Text("Drawer Content")
                                    .font(.headline)
                                    .padding()
                                HStack {
                                    Picker("Type", selection: $newMenuType) {
                                        ForEach(MenuType.allCases, id: \.self) {type in
                                            Text(type.rawValue).tag(type)
                                        }
                                    }
                                    .padding()
                                    TextField("Name", text: $newMenuName)
                                        .textFieldStyle(.roundedBorder)
                                }
                                TimePickerView(
                                    selectedMinutes: $newRestTimeMinutes,
                                    selectedSeconds: $newRestTimeSeconds)
                                Button(action: {
                                    let newMenu = Menu(name: newMenuName, type: newMenuType)
                                    let restSeconds = newRestTimeMinutes * 60 + newRestTimeSeconds
                                    let newLoad = LoadByMenu.create(menu: newMenu, rest: restSeconds)
                                    modelContext.insert(newLoad)
                                    do {
                                        try modelContext.save()
                                        print("Successfully saved new load: \(newLoad)")
                                        showingDrawer = false
                                    } catch {
                                        print("Error occurred while saving new load: \(error)")
                                    }
                                }, label: {
                                    Text("Add New Load")
                                })
                                .padding()
                            }
                        })
                        .ignoresSafeArea()
                        .presentationDetents([.medium, .large])
                        .presentationDragIndicator(.visible)
                    }
                }
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
