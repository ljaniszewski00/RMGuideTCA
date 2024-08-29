import ComposableArchitecture
import Foundation

@Reducer
struct CharacterDetailsFeature {
    
    @ObservableState
    struct State: Equatable {
        let character: RMCharacter
    }
    
    enum Action: Equatable {
        
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            }
        }
    }
}
