import ComposableArchitecture
import SwiftUI

@main
struct RMGuideTCAApp: App {
    var body: some Scene {
        WindowGroup {
            NavigationView {
                CharactersListView(
                    store: Store(
                        initialState: CharactersListFeature.State(),
                        reducer: {
                            CharactersListFeature()
                        }
                    )
                )
            }
        }
    }
}
