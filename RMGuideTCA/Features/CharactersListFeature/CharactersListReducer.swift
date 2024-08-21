import ComposableArchitecture
import Foundation

@Reducer
struct CharactersListFeature {
    
    @ObservableState
    struct State: Equatable {
        var showCharactersList: Bool = false
    }
    
    enum Action: Equatable {
        case showCharactersListButtonTapped
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .showCharactersListButtonTapped:
                state.showCharactersList = true
                return .none
            }
        }
    }
}
