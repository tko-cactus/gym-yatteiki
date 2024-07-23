import SwiftUI

struct TimerView: View {
    @Binding var loadByMenu: LoadByMenu
    @Binding var timerMap: [UUID: RestTimer]
    @StateObject private var currentTimer: RestTimer
    
    init(loadByMenu: Binding<LoadByMenu>, timerMap: Binding<[UUID: RestTimer]>) {
        self._loadByMenu = loadByMenu
        self._timerMap = timerMap
        let timer = timerMap.wrappedValue[loadByMenu.wrappedValue.uuid] ?? RestTimer.getDefaultRestTimer(isPaused: false)
        self._currentTimer = StateObject(wrappedValue: timer)
    }
    
    var body: some View {
        ZStack {
            Color.black.edgesIgnoringSafeArea(.all)
            VStack {
                ZStack {
                    Circle()
                        .stroke(lineWidth: 5.0)
                        .opacity(0.3)
                        .foregroundColor(Color.gray)
                        .frame(width: 300, height: 300)
                    
                    Circle()
                        .trim(from: 0.0, to: CGFloat(currentTimer.timeRemaining) / CGFloat(currentTimer.initialTimeRemaining))
                        .stroke(style: StrokeStyle(lineWidth: 5.0, lineCap: .round, lineJoin: .round))
                        .foregroundColor(Color.orange)
                        .rotationEffect(Angle(degrees: 270.0))
                        .animation(.linear, value: currentTimer.timeRemaining)
                    
                    VStack {
                        Text(timeString(time: currentTimer.timeRemaining))
                            .font(.system(size: 64, weight: .light, design: .default))
                            .foregroundColor(.white)
                        HStack {
                            Image(systemName: "alarm")
                                .foregroundColor(.gray)
                            Text("4:46 PM")
                                .font(.system(size: 20, weight: .regular, design: .default))
                                .foregroundColor(.gray)
                        }
                    }
                }
                .frame(width: 250, height: 250)
                
                HStack(spacing: 40) {
                    Button(action: {
                        currentTimer.reset()
                    }) {
                        Text("Cancel")
                            .font(.title2)
                            .foregroundColor(.white)
                            .frame(width: 100, height: 100)
                            .background(Color.gray.opacity(0.3))
                            .clipShape(Circle())
                    }
                    Spacer()
                    
                    Button(action: {
                        if currentTimer.isPaused {
                            currentTimer.start()
                        } else {
                            currentTimer.pause()
                        }
                    }) {
                        Text(currentTimer.isPaused ? "Resume" : "Pause")
                            .font(.title2)
                            .foregroundColor(currentTimer.isPaused ? .green : .orange)
                            .frame(width: 100, height: 100)
                            .background(currentTimer.isPaused ? Color.green.opacity(0.3) : Color.orange.opacity(0.3))
                            .clipShape(Circle())
                    }
                }
                .padding()
            }
        }
        .onAppear {
            currentTimer.start()
        }
    }
    
    func timeString(time: TimeInterval) -> String {
        let minutes = Int(time) / 60
        let seconds = Int(time) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
}

struct TimerView_Previews: PreviewProvider {
    static var previews: some View {
        let sampleMenu = Menu(name: "Bench Press", type: .CHEST)
        let sampleLoadByMenu = LoadByMenu.create(menu: sampleMenu, rest: 60)
        let sampleTimer = RestTimer(timeRemaining: 60, isPaused: false)
        
        let loadByMenuBinding = Binding<LoadByMenu>(
            get: { sampleLoadByMenu },
            set: { _ in }
        )
        
        let timerMapBinding = Binding<[UUID: RestTimer]>(
            get: { [sampleLoadByMenu.uuid: sampleTimer] },
            set: { _ in }
        )
        
        return TimerView(
            loadByMenu: loadByMenuBinding,
            timerMap: timerMapBinding
        )
    }
}
