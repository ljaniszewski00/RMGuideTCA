import ComposableArchitecture
import Foundation

@Reducer
struct EpisodeDetailsFeature {
    
    @Dependency(\.getRMEpisodeDetailsAPIClient) var getRMEpisodeDetailsAPIClient
    
    @ObservableState
    struct State: Equatable {
        var episode: RMEpisode?
        let episodeNumberString: String
        
        var displayingLoadingModal: Bool = false
        var displayingErrorModal: Bool = false
        var errorText: String = ""
        
        @Shared(.inMemory(AppStorageKey.episodeDetails.rawValue)) var episodeDetails: RMEpisode?
    }
    
    enum Action: Equatable {
        case displayErrorModal(Bool)
        case displayLoadingModal(Bool)
        case errorOccured(String)
        case gotEpisodeDetailsResponse(RMEpisode)
        case onAppear
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case let .displayErrorModal(toBeDisplayed):
                state.displayingErrorModal = toBeDisplayed
                return .none
            case let .displayLoadingModal(toBeDisplayed):
                state.displayingLoadingModal = toBeDisplayed
                return .none
            case let .errorOccured(error):
                state.errorText = error
                state.displayingErrorModal = true
                return .none
            case let .gotEpisodeDetailsResponse(episodeDetails):
                state.episode = episodeDetails
                return .none
            case .onAppear:
                return .run { [episodeNumberString = state.episodeNumberString] send in
                    do {
                        let getEpisodeDetailsResult = await getEpisodeDetails(
                            episodeNumberString: episodeNumberString
                        )
                        
                        switch getEpisodeDetailsResult {
                        case .success(let episodeDetails):
                            print()
                            print(episodeDetails)
                            print()
                            await send(.gotEpisodeDetailsResponse(episodeDetails))
                        case .failure(let error):
                            await send(.errorOccured(error.localizedDescription))
                        }
                    } catch {
                        
                    }
                }
            }
        }
    }
    
    private func getEpisodeDetails(episodeNumberString: String) async -> Result<RMEpisode, Error> {
        do {
            return try await getRMEpisodeDetailsAPIClient
                .request(RickAndMortyEndpoints.episode,
                         requestInput: EmptyRequestInput(),
                         additionalPathContent: episodeNumberString)
        } catch(let error) {
            return .failure(error)
        }
    }
}
