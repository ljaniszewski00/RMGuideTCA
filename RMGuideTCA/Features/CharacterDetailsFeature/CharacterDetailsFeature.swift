import ComposableArchitecture
import Foundation

@Reducer
struct CharacterDetailsFeature {
    
    @ObservableState
    struct State: Equatable {
        let character: RMCharacter
        var displayingEpisodeDetailsView: Bool = false
        var selectedEpisodeNumber: String?
    }
    
    enum Action: Equatable {
        case displayEpisodeDetails(Bool)
        case episodeButtonTapped(String)
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case let .displayEpisodeDetails(toBeDisplayed):
                state.displayingEpisodeDetailsView = toBeDisplayed
                return .none
            case let .episodeButtonTapped(episodeNumberString):
                state.selectedEpisodeNumber = episodeNumberString
                state.displayingEpisodeDetailsView = true
                return .none
                
            }
        }
    }
}
