import Combine
import SwiftData
import SwiftUI

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
    @State var activeTimerList: [UUID: RestTimer] = [:]

    var body: some View {
        NavigationView {
            VStack {
                recentsList
            }
            .navigationTitle("Recents")
            .toolbar {
                toolbarContent
            }
        }
    }

    private var recentsList: some View {
        List(recents, id: \.uuid) { recent in
            NavigationLink(destination: TimerView(loadByMenu: Binding(get: { recent }, set: { _ in }), timerMap: $activeTimerList)) {
                recentRow(recent: recent)
            }
            .listStyle(.automatic)
            .onLongPressGesture {
                showingDrawer = true
            }
        }
    }

    private func recentRow(recent: LoadByMenu) -> some View {
        HStack {
            VStack(alignment: .leading) {
                Text(recent.menu.name)
                    .font(.title)
                    .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                Text(recent.menu.type.rawValue + " - " + RestTimer.timeString(time: activeTimerList[recent.uuid]?.timeRemaining ?? 0))
                    .font(.subheadline)
            }
            Spacer()
        }
        .swipeActions(edge: .trailing, allowsFullSwipe: true) {
            Button {
                print("delete button tapped")
                modelContext.delete(recent)
            } label: {
                Text("delete")
            }
            .tint(.red)
        }
    }

    private var toolbarContent: some View {
        HStack {
            Button(action: {
                showingDrawer = true
            }) {
                Image(systemName: "plus").foregroundColor(.blue)
            }
            .sheet(isPresented: $showingDrawer, content: {
                drawerContent
            })
            .ignoresSafeArea()
            .presentationDetents([.medium, .large])
            .presentationDragIndicator(.visible)
        }
    }

    private var drawerContent: some View {
        VStack {
            Text("Drawer Content")
                .font(.headline)
                .padding()
            HStack {
                Picker("Type", selection: $newMenuType) {
                    ForEach(MenuType.allCases, id: \.self) { type in
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
            Button(action: addNewLoad, label: {
                Text("Add New Load")
            })
            .padding()
        }
    }

    private func addNewLoad() {
        let newMenu = Menu(name: newMenuName, type: newMenuType)
        let restSeconds = LoadByMenu.convertToSeconds(
            minutes: newRestTimeMinutes,
            seconds: newRestTimeSeconds)
        let newLoad = LoadByMenu.create(menu: newMenu, rest: restSeconds)
        modelContext.insert(newLoad)
        let newTimer = RestTimer(timeRemaining: TimeInterval(restSeconds), isPaused: false)
        activeTimerList[newLoad.uuid] = newTimer

        do {
            try modelContext.save()
            print("Successfully saved new load: \(newLoad)")
            showingDrawer = false
        } catch {
            print("Error occurred while saving new load: \(error)")
        }
    }
}

struct TimerListView_Previews: PreviewProvider {
    static var previews: some View {
        TimerListView()
            .modelContainer(SampleLoadByMenuArray.previewContainer)
    }
}
