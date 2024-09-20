import ComposableArchitecture
import Foundation

@Reducer
struct EpisodeDetailsFeature {
    
    @Dependency(\.apiClient) var apiClient
    
    @ObservableState
    struct State: Equatable {
        var episode: RMEpisode?
        let episodeNumberString: String
        
        var displayingLoadingModal: Bool = false
        var displayingErrorModal: Bool = false
        var errorText: String = ""
        
        @Presents var destination: Destination.State?
        var path = StackState<Path.State>()
        
        @Shared(.inMemory(AppStorageKey.episodeDetails.rawValue)) var cachedEpisodesDetails: [RMEpisode] = []
    }
    
    enum Action {
        case destination(PresentationAction<Destination.Action>)
        case displayErrorModal(Bool)
        case displayLoadingModal(Bool)
        case errorOccured(String)
        case gotEpisodeDetailsFromCache(RMEpisode)
        case gotEpisodeDetailsResponse(RMEpisode)
        case onAppear
        case path(StackActionOf<Path>)
        case saveEpisodeDetailsToCache(RMEpisode)
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
            case let .gotEpisodeDetailsFromCache(episodeDetails):
                state.episode = episodeDetails
                return .none
            case let .gotEpisodeDetailsResponse(episodeDetails):
                state.episode = episodeDetails
                return .none
            case .onAppear:
                return .run { [
                    cachedEpisodesDetails = state.cachedEpisodesDetails,
                    episodeNumberString = state.episodeNumberString
                ] send in
                    if let cachedEpisodeDetails = getEpisodeDetailsFromCache(
                        cachedEpisodesDetails: cachedEpisodesDetails,
                        episodeNumberString: episodeNumberString
                    ) {
                        await send(.gotEpisodeDetailsFromCache(cachedEpisodeDetails))
                    } else {
                        do {
                            let getEpisodeDetailsResult = await getEpisodeDetails(
                                episodeNumberString: episodeNumberString
                            )
                            
                            switch getEpisodeDetailsResult {
                            case .success(let episodeDetails):
                                await send(.gotEpisodeDetailsResponse(episodeDetails))
                                await send(.saveEpisodeDetailsToCache(episodeDetails))
                            case .failure(let error):
                                await send(.errorOccured(error.localizedDescription))
                            }
                        }
                    }
                }
            case let .saveEpisodeDetailsToCache(episodeDetails):
                guard !state.cachedEpisodesDetails.contains(episodeDetails) else {
                    return .none
                }
                
                state.cachedEpisodesDetails.append(episodeDetails)
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
    
    private func getEpisodeDetails(episodeNumberString: String) async -> Result<RMEpisode, Error> {
        do {
            return try await apiClient
                .makeEpisodeDetailsRequest(episodeNumberString)
        } catch(let error) {
            return .failure(error)
        }
    }
    
    private func getEpisodeDetailsFromCache(cachedEpisodesDetails: [RMEpisode], episodeNumberString: String) -> RMEpisode? {
        guard !cachedEpisodesDetails.isEmpty,
              let episodeId = Int(episodeNumberString) else {
            return nil
        }
        
        return cachedEpisodesDetails.first(where: {
            $0.id == episodeId
        })
    }
}

extension EpisodeDetailsFeature {
    @Reducer(state: .equatable)
    enum Destination {
        case episodeDetails(EpisodeDetailsFeature)
    }
    
    @Reducer(state: .equatable)
    enum Path {
        case episodeDetails(EpisodeDetailsFeature)
    }
}
