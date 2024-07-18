import SwiftUI

struct Drawer<Content: View>: View {
    @Binding var isOpen: Bool
    let content: Content

    init(isOpen: Binding<Bool>, @ViewBuilder content: () -> Content) {
        self._isOpen = isOpen
        self.content = content()
    }

    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .bottom) {
                if isOpen {
                    Color.black.opacity(0.3)
                        .ignoresSafeArea()
                        .onTapGesture {
                            isOpen = false
                        }
                }

                VStack {
                    content
                }
                .frame(height: geometry.size.height * 0.7)
                .frame(maxWidth: .infinity)
                .background(Color.white)
                .cornerRadius(16)
                .offset(y: isOpen ? 0 : geometry.size.height)
                .animation(.spring(), value: isOpen)
            }
        }
        .ignoresSafeArea()
    }
}

struct DrawerView_Previews: PreviewProvider {
    static var previews: some View {
        Drawer(isOpen: .constant(true)) {
            Text("Drawer Content")
        }
    }
}
