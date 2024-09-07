import ComposableArchitecture
import SwiftUI

@main
struct RMGuideTCAApp: App {
    var body: some Scene {
        WindowGroup {
            CharactersListView(
                store: Store(
                    initialState: CharactersListFeature.State(),
                    reducer: {
                        CharactersListFeature()
                    }
                )
            )
            .tint(.red)
            .accentColor(.red)
        }
    }
}
