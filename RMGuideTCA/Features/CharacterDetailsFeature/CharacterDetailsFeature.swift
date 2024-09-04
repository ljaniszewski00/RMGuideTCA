import ComposableArchitecture
import Foundation

@Reducer
struct CharacterDetailsFeature {
    
    @ObservableState
    struct State: Equatable {
        let character: RMCharacter
        var displayingEpisodeDetailsView: Bool = false
        var selectedEpisodeNumber: String?
        
        @Shared(.appStorage(AppStorageKey.favoriteCharacters.rawValue)) var favoriteCharactersIds: [Int] = []
        var isCharacterFavorite: Bool {
            favoriteCharactersIds.contains(character.id)
        }
    }
    
    enum Action: Equatable {
        case displayEpisodeDetails(Bool)
        case episodeButtonTapped(String)
        case favoriteButtonTapped
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
            }
        }
    }
}
