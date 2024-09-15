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
            $0.getRMCharactersAPIClient = DependencyValues.test.getRMCharactersAPIClient
        }
        
        print()
        print(DependencyValues.test.getRMCharactersAPIClient)
        print(store.dependencies.getRMCharactersAPIClient)
        
        XCTAssertTrue(store.state.characters.isEmpty)

        await store.send(.displayCharactersListButtonTapped) {
            $0.displayingCharactersList = true
        }
        
        await store.receive(\.gotCharactersResponse) {
            $0.characters = [.sampleCharacter]
        }
    }
    
}
