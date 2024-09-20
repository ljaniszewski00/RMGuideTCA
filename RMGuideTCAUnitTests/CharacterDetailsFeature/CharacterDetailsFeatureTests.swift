import ComposableArchitecture
import XCTest
@testable import RMGuideTCA

final class CharacterDetailsFeatureTests: XCTestCase {
    
    @MainActor
    func test_displayEpisodeDetails() async {
        let store = TestStore(initialState: CharacterDetailsFeature.State(
            character: .sampleCharacter
        )) {
            CharacterDetailsFeature()
        }
        
        XCTAssertFalse(store.state.displayingEpisodeDetailsView)
        
        await store.send(.displayEpisodeDetails(true)) {
            $0.displayingEpisodeDetailsView = true
        }
    }
    
    @MainActor
    func test_episodeButtonTapped() async {
        let store = TestStore(initialState: CharacterDetailsFeature.State(
            character: .sampleCharacter
        )) {
            CharacterDetailsFeature()
        }
        
        let selectedEpisodeNumberString: String = "1"
        let newDestination: CharacterDetailsFeature.Destination.State = .episodeDetails(
            EpisodeDetailsFeature.State(
                episodeNumberString: selectedEpisodeNumberString
            )
        )
        
        await store.send(.episodeButtonTapped(selectedEpisodeNumberString)) {
            $0.selectedEpisodeNumber = selectedEpisodeNumberString
            $0.displayingEpisodeDetailsView = true
            $0.destination = newDestination
        }
    }

    @MainActor
    func test_afterInit_thereShouldBeNoFavoriteCharacters() async {
        let store = TestStore(initialState: CharacterDetailsFeature.State(
            character: .sampleCharacter
        )) {
            CharacterDetailsFeature()
        }
        
        XCTAssertTrue(store.state.favoriteCharactersIds.isEmpty)
        XCTAssertFalse(store.state.isCharacterFavorite)
    }
    
    @MainActor
    func test_favoriteButtonTapped_characterShouldBeFavorite() async {
        let store = TestStore(initialState: CharacterDetailsFeature.State(
            character: .sampleCharacter,
            favoriteCharactersIds: [0, 1, 2]
        )) {
            CharacterDetailsFeature()
        }
        
        XCTAssertTrue(
            store.state.favoriteCharactersIds.contains(
                RMCharacter.sampleCharacter.id
            )
        )
        
        XCTAssertTrue(store.state.isCharacterFavorite)
    }
    
    @MainActor
    func test_favoriteButtonTapped_characterShouldBeAddedToFavorites() async {
        let store = TestStore(initialState: CharacterDetailsFeature.State(
            character: .sampleCharacter,
            favoriteCharactersIds: [1, 2]
        )) {
            CharacterDetailsFeature()
        }
        
        store.exhaustivity = .off
        
        XCTAssertFalse(store.state.favoriteCharactersIds.isEmpty)
        
        await store.send(.favoriteButtonTapped) {
            XCTAssertEqual($0.favoriteCharactersIds.count, 3)
            XCTAssertEqual($0.favoriteCharactersIds.last, 0)
        }
    }
    
    @MainActor
    func test_favoriteButtonTapped_characterShouldBeRemovedFromFavorites() async {
        let store = TestStore(initialState: CharacterDetailsFeature.State(
            character: .sampleCharacter,
            favoriteCharactersIds: [0, 1, 2]
        )) {
            CharacterDetailsFeature()
        }
        
        store.exhaustivity = .off
        
        XCTAssertFalse(store.state.favoriteCharactersIds.isEmpty)
        
        await store.send(.favoriteButtonTapped) {
            XCTAssertEqual($0.favoriteCharactersIds.count, 2)
            XCTAssertEqual($0.favoriteCharactersIds.last, 2)
        }
    }
    
    @MainActor
    func test_favoriteButtonTapped_characterShouldBeRemovedFromFavorites_inCharactersListFeature() async {
        let characterDetailsStore = TestStore(
            initialState: CharacterDetailsFeature.State(
                character: .sampleCharacter,
                favoriteCharactersIds: [0, 1, 2]
            )
        ) {
            CharacterDetailsFeature()
        }
        
        let charactersListFeatureStore = TestStore(
            initialState: CharactersListFeature.State()
        ) {
            CharactersListFeature()
        }
        
        characterDetailsStore.exhaustivity = .off
        
        XCTAssertEqual(characterDetailsStore.state.favoriteCharactersIds.count, 3)
        XCTAssertEqual(charactersListFeatureStore.state.favoriteCharactersIds.count, 3)
        
        await characterDetailsStore.send(.favoriteButtonTapped) {
            XCTAssertEqual($0.favoriteCharactersIds.count, 2)
            XCTAssertEqual(charactersListFeatureStore.state.favoriteCharactersIds.count, 2)
        }
    }
}
