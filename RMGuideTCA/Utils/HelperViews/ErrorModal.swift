import SwiftUI

struct ErrorModal: ViewModifier {

    @Binding var isPresented: Bool
    
    @State private var stopModalDisappear: Bool = false
    @State private var timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    @State private var secondsElapsed: Int = 0
    
    var errorDescription: String
    
    private let secondsToElapseToModalDisappear: Int = 4

    init(isPresented: Binding<Bool>, errorDescription: String) {
        _isPresented = isPresented
        self.errorDescription = errorDescription
    }

    func body(content: Content) -> some View {
        content
            .overlay(popupContent(), alignment: .top)
    }

    @ViewBuilder private func popupContent() -> some View {
        if isPresented {
            ZStack {
                Rectangle()
                    .foregroundColor(.errorModalInside)
                    .background {
                        Rectangle()
                            .stroke(lineWidth: Views.Constants.backgroundStrokeLineWidth)
                            .foregroundColor(.errorModalStroke)
                    }
                
                Text(errorDescription)
                    .font(.body)
                    .fontWeight(.semibold)
                    .foregroundStyle(.black.opacity(Views.Constants.errorDescriptionTextColorOpacity))
                    .padding()
            }
            .animation(.easeInOut(duration: Views.Constants.animationDuration))
            .transition(.offset(x: Views.Constants.xAxisTransition,
                                y: Views.Constants.yAxisTransition))
            .frame(height: Views.Constants.errorViewHeight)
            .onTapGesture {
                stopModalDisappear.toggle()
                secondsElapsed = 0
                if stopModalDisappear {
                    timer.upstream.connect().cancel()
                } else {
                    timer = timer.upstream.autoconnect()
                }
            }
            .onReceive(timer) { _ in
                secondsElapsed += 1
                if secondsElapsed == secondsToElapseToModalDisappear && !stopModalDisappear {
                    timer.upstream.connect().cancel()
                    DispatchQueue.main.async {
                        withAnimation {
                            $isPresented.wrappedValue = false
                        }
                    }
                }
            }
            .onDisappear {
                secondsElapsed = 0
                stopModalDisappear = false
            }
        }
    }
}

private extension Views {
    struct Constants {
        static let backgroundStrokeLineWidth: CGFloat = 3
        static let errorDescriptionTextColorOpacity: CGFloat = 0.7
        static let animationDuration: CGFloat = 0.5
        static let delay: DispatchTime = DispatchTime.now() + 3
        static let errorViewHeight: CGFloat = 80
        static let xAxisTransition: CGFloat = 0
        static let yAxisTransition: CGFloat = -UIScreen.main.bounds.height
    }
}
