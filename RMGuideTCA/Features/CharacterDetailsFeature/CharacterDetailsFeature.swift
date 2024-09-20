import ComposableArchitecture
import Foundation

@Reducer
struct CharacterDetailsFeature {
    
    @ObservableState
    struct State: Equatable {
        let character: RMCharacter
        var displayingEpisodeDetailsView: Bool = false
        var selectedEpisodeNumber: String?
        
        @Presents var destination: Destination.State?
        var path = StackState<Path.State>()
        
        @Shared(.appStorage(AppStorageKey.favoriteCharacters.rawValue)) var favoriteCharactersIds: [Int] = []
        
        var isCharacterFavorite: Bool {
            favoriteCharactersIds.contains(character.id)
        }
    }
    
    enum Action {
        case destination(PresentationAction<Destination.Action>)
        case displayEpisodeDetails(Bool)
        case episodeButtonTapped(String)
        case favoriteButtonTapped
        case path(StackActionOf<Path>)
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
                
                state.destination = .episodeDetails(
                    EpisodeDetailsFeature.State(
                        episodeNumberString: episodeNumberString
                    )
                )
                
                return .none
            case .favoriteButtonTapped:
                var newFavoriteCharactersIds = state.favoriteCharactersIds
                let characterId: Int = state.character.id
                if newFavoriteCharactersIds.contains(characterId) {
                    guard let indexToBeRemoved = newFavoriteCharactersIds.firstIndex(of: characterId) else {
                        newFavoriteCharactersIds.append(characterId)
                        return .none
                    }
                    newFavoriteCharactersIds.remove(at: indexToBeRemoved)
                } else {
                    newFavoriteCharactersIds.append(characterId)
                }
                state.favoriteCharactersIds = newFavoriteCharactersIds
                
                return .none
            case .destination:
                return .none
            case .path:
                return .none
            }
        }
        .ifLet(\.$destination, action: \.destination)
        .forEach(\.path, action: \.path)
    }
}

extension CharacterDetailsFeature {
    @Reducer(state: .equatable)
    enum Destination {
        case charactersList(CharactersListFeature)
        case episodeDetails(EpisodeDetailsFeature)
    }
    
    @Reducer(state: .equatable)
    enum Path {
        case charactersList(CharactersListFeature)
        case episodeDetails(EpisodeDetailsFeature)
    }
}
