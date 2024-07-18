import SwiftUI

struct BottomDrawer<Content: View>: View {
    @Binding var isOpen: Bool
    @State private var dragOffset: CGFloat = 0
    let content: Content

    init(isOpen: Binding<Bool>, @ViewBuilder content: () -> Content) {
        self._isOpen = isOpen
        self.content = content()
    }

    var body: some View {
        GeometryReader { geometry in
            VStack {
                Spacer()
                VStack {
                    Capsule()
                        .fill(Color.secondary)
                        .frame(width: 40, height: 5)
                        .padding(.top, 8)
                    self.content
                }
                .frame(width: geometry.size.width, height: geometry.size.height * 0.5)
                .background(Color(.systemBackground))
                .clipShape(RoundedRectangle(cornerRadius: 16))
                .offset(y: self.isOpen ? self.dragOffset : geometry.size.height * 0.5)
                .gesture(
                    DragGesture()
                        .onChanged { value in
                            self.dragOffset = value.translation.height
                        }
                        .onEnded { value in
                            if value.translation.height > 100 {
                                self.isOpen = false
                            } else {
                                self.isOpen = true
                            }
                            self.dragOffset = 0
                        }
                )
                .animation(.spring(), value: isOpen)
            }
        }
        .edgesIgnoringSafeArea(.bottom)
    }
}


extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
}

struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}
