import ComposableArchitecture
import XCTest
@testable import RMGuideTCA

final class EpisodeDetailsFeatureTests: XCTestCase {

    @MainActor
    func test_displayErrorModal() async {
        let store = TestStore(initialState: EpisodeDetailsFeature.State(
            episodeNumberString: String(RMEpisode.sampleEpisode.id)
        )) {
            EpisodeDetailsFeature()
        }
        
        XCTAssertFalse(store.state.displayingErrorModal)
        
        await store.send(.displayErrorModal(true)) {
            $0.displayingErrorModal = true
        }
    }
    
    @MainActor
    func test_displayLoadingModal() async {
        let store = TestStore(initialState: EpisodeDetailsFeature.State(
            episodeNumberString: String(RMEpisode.sampleEpisode.id)
        )) {
            EpisodeDetailsFeature()
        }
        
        XCTAssertFalse(store.state.displayingLoadingModal)
        
        await store.send(.displayLoadingModal(true)) {
            $0.displayingLoadingModal = true
        }
    }
    
    @MainActor
    func test_errorOccured() async {
        let store = TestStore(initialState: EpisodeDetailsFeature.State(
            episodeNumberString: String(RMEpisode.sampleEpisode.id)
        )) {
            EpisodeDetailsFeature()
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
    func test_onAppear_shouldProvideEpisodeDetails() async {
        let store = TestStore(initialState: EpisodeDetailsFeature.State(
            episodeNumberString: String(RMEpisode.sampleEpisode.id)
        )) {
            EpisodeDetailsFeature()
        }
        
        store.exhaustivity = .off
        
        await store.send(.onAppear)
        
        await store.receive(\.gotEpisodeDetailsResponse) {
            $0.episode = .sampleEpisode
        }
    }
    
    @MainActor
    func test_onAppear_shouldProvideEpisodeDetails_whichShouldBeSavedToCache() async {
        let store = TestStore(initialState: EpisodeDetailsFeature.State(
            episodeNumberString: String(RMEpisode.sampleEpisode.id)
        )) {
            EpisodeDetailsFeature()
        }
        
        XCTAssertTrue(store.state.cachedEpisodesDetails.isEmpty)
        
        await store.send(.onAppear)
        
        await store.receive(\.gotEpisodeDetailsResponse) {
            $0.episode = .sampleEpisode
            $0.cachedEpisodesDetails = [.sampleEpisode]
        }
        
        await store.receive(\.saveEpisodeDetailsToCache)
    }
    
    @MainActor
    func test_onAppear_shouldProvideEpisodeDetailsFromCache() async {
        var store = TestStore(initialState: EpisodeDetailsFeature.State(
            episodeNumberString: String(RMEpisode.sampleEpisode.id)
        )) {
            EpisodeDetailsFeature()
        }
        
        store.exhaustivity = .off
        
        await store.send(.onAppear)
        
        store = TestStore(initialState: EpisodeDetailsFeature.State(
            episodeNumberString: String(RMEpisode.sampleEpisode.id)
        )) {
            EpisodeDetailsFeature()
        }
        
        XCTAssertNil(store.state.episode)
        
        await store.send(.onAppear)
        
        await store.receive(\.gotEpisodeDetailsFromCache) {
            $0.episode = .sampleEpisode
        }
    }
}
