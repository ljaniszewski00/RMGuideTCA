import SwiftUI

struct LoadingIndicatorModal: ViewModifier {

    @Binding var isPresented: Bool

    init(isPresented: Binding<Bool>) {
        _isPresented = isPresented
    }

    func body(content: Content) -> some View {
        content
            .allowsHitTesting(!isPresented)
            .blur(radius: isPresented ? 
                  Views.Constants.backgroundBlurRadiusWhenModalPresented : Views.Constants.backgroundBlurRadiusWhenModalNotPresented)
            .overlay(popupContent())
    }

    @ViewBuilder private func popupContent() -> some View {
        if isPresented {
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle(tint: Color.accentColor))
                .scaleEffect(Views.Constants.progressViewScaleEffect)
                .transition(.move(edge: .bottom))
                .animation(.default.speed(Views.Constants.progressViewAnimationSpeed))
        }
    }
}

private extension Views {
    struct Constants {
        static let backgroundBlurRadiusWhenModalPresented: CGFloat = 3
        static let backgroundBlurRadiusWhenModalNotPresented: CGFloat = 0
        static let progressViewScaleEffect: CGFloat = 1.5
        static let progressViewAnimationSpeed: CGFloat = 1
    }
}
