import Algorithms
import ComposableArchitecture
import Foundation

@Reducer
struct CharactersListFeature {
    
    @Dependency(\.apiClient) var apiClient
    
    @ObservableState
    struct State: Equatable {
        var characters: [RMCharacter] = []
        var displayingCharactersList: Bool = false
        var displayingMode: CharactersListDisplayMode = .grid
        var displayingOnlyFavoriteCharacters: Bool = false
        
        var displayingLoadingModal: Bool = false
        var displayingErrorModal: Bool = false
        var errorText: String = ""
        
        @Shared(.appStorage(AppStorageKey.favoriteCharacters.rawValue)) var favoriteCharactersIds: [Int] = []
        
        @Presents var destination: Destination.State?
        var path = StackState<Path.State>()
        
        var searchText: String = ""
        
        var charactersToDisplay: [RMCharacter] {
            var charactersToDisplay = characters
            
            if !searchText.isEmpty {
                charactersToDisplay = charactersToDisplay
                    .filter {
                        $0.name.contains(searchText)
                    }
            }
            
            if displayingOnlyFavoriteCharacters {
                charactersToDisplay = charactersToDisplay
                    .filter { characterToDisplay in
                        favoriteCharactersIds.contains(characterToDisplay.id)
                    }
            }
            
            return charactersToDisplay
        }
    }
    
    enum Action {
        case changeDisplayModeButtonTapped
        case destination(PresentationAction<Destination.Action>)
        case displayCharacterDetailsButtonTapped(RMCharacter)
        case displayCharactersListButtonTapped
        case displayErrorModal(Bool)
        case displayFavoriteCharactersButtonTapped
        case displayLoadingModal(Bool)
        case exitCharactersListButtonTapped
        case errorOccured(String)
        case favoriteButtonTapped(Int)
        case gotCharactersResponse([RMCharacter])
        case path(StackActionOf<Path>)
        case searchTextChanged(String)
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .changeDisplayModeButtonTapped:
                state.displayingMode = (state.displayingMode == .grid ? .list : .grid)
                return .none
            case let .displayCharacterDetailsButtonTapped(character):
                state.destination = .characterDetails(
                    CharacterDetailsFeature.State(character: character)
                )
                
                return .none
            case .displayCharactersListButtonTapped:
                state.displayingCharactersList = true
                
                return .run { send in
                    do {
                        let getCharactersResult = await getRMCharacters()
                        
                        switch getCharactersResult {
                        case .success(let characters):
                            await send(.gotCharactersResponse(characters))
                        case .failure(let error):
                            await send(.errorOccured(error.localizedDescription))
                        }
                    }
                }
            case let .displayErrorModal(toBeDisplayed):
                state.displayingErrorModal = toBeDisplayed
                return .none
            case .displayFavoriteCharactersButtonTapped:
                state.displayingOnlyFavoriteCharacters.toggle()
                return .none
            case let .displayLoadingModal(toBeDisplayed):
                state.displayingLoadingModal = toBeDisplayed
                return .none
            case .exitCharactersListButtonTapped:
                state.displayingCharactersList = false
                return .none
            case let .errorOccured(error):
                state.errorText = error
                state.displayingErrorModal = true
                return .none
            case let .favoriteButtonTapped(characterId):
                var newFavoriteCharactersIds = state.favoriteCharactersIds
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
            case let .gotCharactersResponse(characters):
                state.characters = characters
                return .none
            case let .searchTextChanged(newText):
                state.searchText = newText
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
    
    private func getRMCharacters() async -> Result<[RMCharacter], Error> {
        do {
            return try await apiClient
                .makeCharactersRequest()
        } catch(let error) {
            return .failure(error)
        }
    }
}

extension CharactersListFeature {
    @Reducer(state: .equatable)
    enum Destination {
        case characterDetails(CharacterDetailsFeature)
    }
    
    @Reducer(state: .equatable)
    enum Path {
        case characterDetails(CharacterDetailsFeature)
    }
}
