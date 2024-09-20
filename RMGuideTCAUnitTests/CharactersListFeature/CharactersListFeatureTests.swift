import ComposableArchitecture
import XCTest
@testable import RMGuideTCA

final class CharactersListFeatureTests: XCTestCase {
    
    @MainActor
    func test_changeDisplayModeButtonTapped() async {
        let store = TestStore(initialState: CharactersListFeature.State()) {
            CharactersListFeature()
        }
        
        XCTAssertEqual(store.state.displayingMode, .grid)
        
        await store.send(.changeDisplayModeButtonTapped) {
            $0.displayingMode = .list
        }
    }
    
    @MainActor
    func test_displayCharacterDetailsButtonTapped() async {
        let store = TestStore(initialState: CharactersListFeature.State()) {
            CharactersListFeature()
        }
        
        XCTAssertEqual(store.state.destination, nil)
        
        let newDestination: CharactersListFeature.Destination.State = .characterDetails(
            CharacterDetailsFeature.State(character: .sampleCharacter)
        )
        await store.send(.displayCharacterDetailsButtonTapped(.sampleCharacter)) {
            $0.destination = newDestination
        }
    }
    
    @MainActor
    func test_displayCharactersListButtonTapped() async {
        let store = TestStore(initialState: CharactersListFeature.State()) {
            CharactersListFeature()
        } withDependencies: {
            $0.apiClient = .testValue
        }
        
        XCTAssertTrue(store.state.characters.isEmpty)

        await store.send(.displayCharactersListButtonTapped) {
            $0.displayingCharactersList = true
        }
        
        await store.receive(\.gotCharactersResponse) {
            $0.characters = [.sampleCharacter]
        }
    }
    
    @MainActor
    func test_displayErrorModal() async {
        let store = TestStore(initialState: CharactersListFeature.State()) {
            CharactersListFeature()
        }
        
        XCTAssertFalse(store.state.displayingErrorModal)
        
        await store.send(.displayErrorModal(true)) {
            $0.displayingErrorModal = true
        }
    }
    
    @MainActor
    func test_displayFavoriteCharactersButtonTapped() async {
        let store = TestStore(initialState: CharactersListFeature.State()) {
            CharactersListFeature()
        }
        
        XCTAssertFalse(store.state.displayingOnlyFavoriteCharacters)
        
        await store.send(.displayFavoriteCharactersButtonTapped) {
            $0.displayingOnlyFavoriteCharacters = true
        }
    }
    
    @MainActor
    func test_displayLoadingModal() async {
        let store = TestStore(initialState: CharactersListFeature.State()) {
            CharactersListFeature()
        }
        
        XCTAssertFalse(store.state.displayingLoadingModal)
        
        await store.send(.displayLoadingModal(true)) {
            $0.displayingLoadingModal = true
        }
    }
    
    @MainActor
    func test_exitCharactersListButtonTapped() async {
        let store = TestStore(initialState: CharactersListFeature.State()) {
            CharactersListFeature()
        } withDependencies: {
            $0.apiClient = .testValue
        }
        
        XCTAssertFalse(store.state.displayingCharactersList)
        
        await store.send(.displayCharactersListButtonTapped) {
            $0.displayingCharactersList = true
        }
        
        await store.receive(\.gotCharactersResponse) {
            $0.characters = [.sampleCharacter]
        }
        
        await store.send(.exitCharactersListButtonTapped) {
            $0.displayingCharactersList = false
        }
    }
    
    @MainActor
    func test_errorOccured() async {
        let store = TestStore(initialState: CharactersListFeature.State()) {
            CharactersListFeature()
        }
        
        XCTAssertEqual(store.state.errorText, "")
        XCTAssertFalse(store.state.displayingErrorModal)
        
        let testError: String = "test error"
        await store.send(.errorOccured(testError)) {
            $0.errorText = testError
            $0.displayingErrorModal = true
        }
    }
    
    @MainActor
    func test_searchTextChanged() async {
        let store = TestStore(initialState: CharactersListFeature.State()) {
            CharactersListFeature()
        }
        
        XCTAssertEqual(store.state.searchText, "")
        
        let newSearchText: String = "New search text"
        await store.send(.searchTextChanged(newSearchText)) {
            $0.searchText = newSearchText
        }
    }
    
    @MainActor
    func test_searchTextChanged_andSoCharactersToDisplay() async {
        let store = TestStore(initialState: CharactersListFeature.State(
            characters: [.sampleCharacter],
            displayingCharactersList: true
        )) {
            CharactersListFeature()
        }
        
        XCTAssertEqual(store.state.charactersToDisplay.count, 1)
        
        XCTAssertEqual(store.state.searchText, "")
        
        store.exhaustivity = .off
        
        let newSearchText: String = "New search text"
        await store.send(.searchTextChanged(newSearchText))
        
        XCTAssertTrue(store.state.charactersToDisplay.isEmpty)
    }
    
    @MainActor
    func test_afterInit_thereShouldBeNoFavoriteCharacters() async {
        let store = TestStore(initialState: CharactersListFeature.State()) {
            CharactersListFeature()
        }
        
        XCTAssertTrue(store.state.favoriteCharactersIds.isEmpty)
    }
    
    @MainActor
    func test_favoriteButtonTapped_characterShouldBeAddedToFavorites() async {
        let store = TestStore(initialState: CharactersListFeature.State(
            favoriteCharactersIds: [0, 1, 2]
        )) {
            CharactersListFeature()
        }
        
        store.exhaustivity = .off
        
        XCTAssertFalse(store.state.favoriteCharactersIds.isEmpty)
        
        await store.send(.favoriteButtonTapped(3)) {
            XCTAssertEqual($0.favoriteCharactersIds.count, 4)
            XCTAssertEqual($0.favoriteCharactersIds.last, 3)
        }
    }
    
    @MainActor
    func test_favoriteButtonTapped_characterShouldBeRemovedFromFavorites() async {
        let store = TestStore(initialState: CharactersListFeature.State(
            favoriteCharactersIds: [0, 1, 2]
        )) {
            CharactersListFeature()
        }
        
        store.exhaustivity = .off
        
        XCTAssertFalse(store.state.favoriteCharactersIds.isEmpty)
        
        await store.send(.favoriteButtonTapped(1)) {
            XCTAssertEqual($0.favoriteCharactersIds.count, 2)
            XCTAssertEqual($0.favoriteCharactersIds.last, 2)
        }
    }
}
