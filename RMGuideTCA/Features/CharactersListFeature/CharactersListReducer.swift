import ComposableArchitecture
import Foundation

@Reducer
struct CharactersListFeature {
    
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
                return .none
            case .exitCharactersListButtonTapped:
                state.displayingCharactersList = false
                return .none
            case let .searchTextChanged(newText):
                state.searchText = newText
                return .none
            }
        }
    }
}
