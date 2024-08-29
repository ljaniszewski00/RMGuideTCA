import ComposableArchitecture
import SwiftUI

struct CharacterDetailsView: View {
    @Perception.Bindable var store: StoreOf<CharacterDetailsFeature>
    
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

#Preview {
    CharacterDetailsView(
        store: Store(
            initialState: CharacterDetailsFeature.State(character: .sampleCharacter),
            reducer: {
                CharacterDetailsFeature()
            }
        )
    )
}
