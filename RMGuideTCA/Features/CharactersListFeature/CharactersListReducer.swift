import ComposableArchitecture
import Foundation

@Reducer
struct CharactersListFeature {
    
    @Dependency(\.getRMCharactersAPIClient) var getRMCharactersAPIClient
    
    @ObservableState
    struct State: Equatable {
        var characters: [RMCharacter] = []
        var displayingCharactersList: Bool = false
        var displayingMode: CharactersListDisplayMode = .grid
        var displayingOnlyFavoriteCharacters: Bool = false
        
        var displayingLoadingModal: Bool = false
        var displayingErrorModal: Bool = false
        var errorText: String = ""
        
        var searchText: String = ""
        
        var charactersToDisplay: [RMCharacter] {
            var charactersToDisplay = characters
            
            if !searchText.isEmpty {
                charactersToDisplay = charactersToDisplay
                    .filter {
                        $0.name.contains(searchText)
                    }
            }
            
//            if displayOnlyFavoriteCharacters {
//                guard let favoriteCharactersIds = favoriteCharactersManager.getData() else {
//                    return charactersToDisplay
//                }
//                
//                charactersToDisplay = charactersToDisplay
//                    .filter { characterToDisplay in
//                        favoriteCharactersIds.contains(characterToDisplay.id)
//                    }
//            }
            
            return charactersToDisplay
        }
    }
    
    enum Action: Equatable {
        case changeDisplayModeButtonTapped
        case changeToFavoriteCharacters
        case displayCharactersListButtonTapped
        case displayErrorModal(Bool)
        case displayLoadingModal(Bool)
        case exitCharactersListButtonTapped
        case errorOccured(String)
        case gotCharactersResponse([RMCharacter])
        case searchTextChanged(String)
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .changeDisplayModeButtonTapped:
                state.displayingMode = (state.displayingMode == .grid ? .list : .grid)
                return .none
            case .changeToFavoriteCharacters:
                state.displayingOnlyFavoriteCharacters.toggle()
                return .none
            case let .displayErrorModal(toBeDisplayed):
                state.displayingErrorModal = toBeDisplayed
                return .none
            case let .displayLoadingModal(toBeDisplayed):
                state.displayingLoadingModal = toBeDisplayed
                return .none
            case .displayCharactersListButtonTapped:
                state.displayingCharactersList = true
                
                if state.displayingCharactersList {
                    return .run { send in
                        do {
                            let getCharactersResult = await getRMCharacters()
                            
                            switch getCharactersResult {
                            case .success(let characters):
                                await send(.gotCharactersResponse(characters))
                            case .failure(let error):
                                await send(.errorOccured(error.localizedDescription))
                            }
                        } catch {
                            
                        }
                    }
                } else {
                    state.characters.removeAll()
                    return .none
                }
            case .exitCharactersListButtonTapped:
                state.displayingCharactersList = false
                return .none
            case let .errorOccured(error):
                state.errorText = error
                state.displayingErrorModal = true
                return .none
            case let .gotCharactersResponse(characters):
                state.characters = characters
                return .none
            case let .searchTextChanged(newText):
                state.searchText = newText
                return .none
            }
        }
    }
    
    private func getRMCharacters() async -> Result<[RMCharacter], Error> {
        do {
            return try await getRMCharactersAPIClient
                .request(RickAndMortyEndpoints.character,
                         requestInput: EmptyRequestInput())
                .map {
                    $0.results
                }
        } catch(let error) {
            return .failure(error)
        }
    }
}
