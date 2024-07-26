import SwiftUI

struct TimerView: View {
    @State private var timeRemaining: Double = 586
    @State private var timer: Timer? = nil
    @State private var isPaused: Bool = false
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
                        .trim(from: 0.0, to: CGFloat(min(self.timeRemaining / 600, 1.0)))
                        .stroke(style: StrokeStyle(lineWidth: CIRCLE_LINE_WIDTH, lineCap: .round, lineJoin: .round))
                        .foregroundColor(Color.orange)
                        .rotationEffect(Angle(degrees: 270.0))
                        .animation(.linear, value: timeRemaining)

                    VStack {
                        Text(timeString(time: timeRemaining))
                            .font(.system(size: 64, weight: .light, design: .default))
                            .foregroundColor(.white)
                        Text("4:46 PM")
                            .font(.system(size: 20, weight: .regular, design: .default))
                            .foregroundColor(.gray)
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
        }
        .onAppear {
            self.startTimer()
        }
    }

    func startTimer() {
        self.timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            if self.timeRemaining > 0 {
                self.timeRemaining -= 1
            } else {
                self.timer?.invalidate()
                self.timer = nil
            }
        }
    }

    func cancelTimer() {
        self.timer?.invalidate()
        self.timer = nil
        self.timeRemaining = 586
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
        let minutes = Int(time) / 60
        let seconds = Int(time) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
}

struct TimerView_Previews: PreviewProvider {
    static var previews: some View {
        TimerView()
    }
}
