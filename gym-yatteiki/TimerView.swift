import SwiftUI

struct TimerView: View {
    @Binding var loadByMenu: LoadByMenu
    @State private var timer: Timer? = nil
    @State private var isPaused: Bool = false
    @State private var initialRestTime: Int = 0
    private let CIRCLE_LINE_WIDTH: CGFloat = 5.0

    var body: some View {
        ZStack {
            Color.black.edgesIgnoringSafeArea(.all)

            VStack {
                ZStack {
                    Circle()
                        .stroke(lineWidth: CIRCLE_LINE_WIDTH)
                        .opacity(0.3)
                        .foregroundColor(Color.gray)
                        .frame(width: 300, height: 300)

                    Circle()
                        .trim(from: 0.0, to: CGFloat(loadByMenu.rest) / Double(initialRestTime))
                        .stroke(style: StrokeStyle(lineWidth: CIRCLE_LINE_WIDTH, lineCap: .round, lineJoin: .round))
                        .foregroundColor(Color.orange)
                        .rotationEffect(Angle(degrees: 270.0))
                        .animation(.linear, value: loadByMenu.rest)

                    VStack {
                        Text(timeString(time: Double(loadByMenu.rest)))
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
                        self.cancelTimer()
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
                        self.pauseResumeTimer()
                    }) {
                        if isPaused {
                            Text("Resume")
                                .font(.title2)
                                .foregroundColor(.green)
                                .frame(width: 100, height: 100)
                                .background(Color.green.opacity(0.3))
                                .clipShape(Circle())
                        } else {
                            Text("Pause")
                                .font(.title2)
                                .foregroundColor(.orange)
                                .frame(width: 100, height: 100)
                                .background(Color.orange.opacity(0.3))
                                .clipShape(Circle())
                        }
                    }
                }
                .padding()
            }
            .onAppear {
                self.initialRestTime = self.loadByMenu.rest
                self.startTimer()
            }
        }
    }

    func startTimer() {
        self.timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            if self.loadByMenu.rest > 0 {
                self.loadByMenu.rest -= 1
            } else {
                self.timer?.invalidate()
                self.timer = nil
            }
        }
    }

    func cancelTimer() {
        self.timer?.invalidate()
        self.timer = nil
        self.loadByMenu.rest = self.initialRestTime
        isPaused.toggle()
    }

    func pauseResumeTimer() {
        if isPaused {
            self.startTimer()
        } else {
            self.timer?.invalidate()
            self.timer = nil
        }
        self.isPaused.toggle()
    }

    func timeString(time: Double) -> String {
        let minutes: Int = Int(time) / 60
        let seconds: Int = Int(time) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
}

struct TimerView_Previews: PreviewProvider {
    static var previews: some View {
        TimerView(
            loadByMenu: .constant(
                LoadByMenu.create(
                    menu: Menu(name: "Bench Press", type: .CHEST),
                    rest: 60
                )
            )
        )
    }
}
