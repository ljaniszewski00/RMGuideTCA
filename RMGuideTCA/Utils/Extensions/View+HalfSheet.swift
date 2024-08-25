import SwiftUI

extension View {
    func halfSheet<SheetView: View>(showSheet: Binding<Bool>,
                                    @ViewBuilder sheetView: @escaping () -> SheetView) -> some View {
        
        
        return self
            .background {
                HalfSheetPresenter(showSheet: showSheet, sheetView: sheetView())
            }
    }
}

private struct HalfSheetPresenter<SheetView: View>: UIViewControllerRepresentable {
    @Binding var showSheet: Bool
    
    var sheetView: SheetView
    
    let controller = UIViewController()
    
    func makeUIViewController(context: Context) -> some UIViewController {
        controller.view.backgroundColor = .clear
        return controller
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        if showSheet {
            let sheetController = CustomHostingController(rootView: sheetView)
            uiViewController.present(sheetController, animated: true) {
                DispatchQueue.main.async {
                    self.showSheet.toggle()
                }
            }
        }
    }
}

private class CustomHostingController<Content: View>: UIHostingController<Content> {
    override func viewDidLoad() {
        if let presentationController = presentationController as? UISheetPresentationController {
            presentationController.detents = [
                .medium()
            ]
            
            presentationController.prefersGrabberVisible = true
        }
    }
}
