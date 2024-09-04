import ComposableArchitecture
import Foundation

@Reducer
struct EpisodeDetailsFeature {
    
    @ObservableState
    struct State: Equatable {
        var episode: RMEpisode?
        let episodeNumberString: String
    }
    
    enum Action: Equatable {
        
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
                
            }
            return .none
        }
    }
}
