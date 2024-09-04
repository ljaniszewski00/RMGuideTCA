import ComposableArchitecture
import SwiftUI

struct EpisodeDetailsView: View {
    @Perception.Bindable var store: StoreOf<EpisodeDetailsFeature>
    
    var body: some View {
        Text(store.episodeNumberString)
    }
}

#Preview {
    EpisodeDetailsView(
        store: Store(
            initialState: EpisodeDetailsFeature.State(episode: .sampleEpisode, episodeNumberString: "1"),
            reducer: {
                EpisodeDetailsFeature()
            }
        )
    )
}
