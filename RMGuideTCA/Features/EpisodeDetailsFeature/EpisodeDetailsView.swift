import ComposableArchitecture
import SwiftUI

struct EpisodeDetailsView: View {
    @Perception.Bindable var store: StoreOf<EpisodeDetailsFeature>
    
    var body: some View {
        WithPerceptionTracking {
            HStack {
                VStack(alignment: .leading) {
                    if let episode = store.episode {
                        let episodeLabel = Views.Constants.episodeLabelPrefix + " " + store.episodeNumberString
                        
                        Text(episodeLabel)
                            .font(.largeTitle)
                            .fontWeight(.semibold)
                        
                        Divider()
                            .padding(.bottom)
                        
                        VStack(alignment: .leading,
                               spacing: Views.Constants.episodePropertiesColumnVStackSpacing) {
                            VStack(alignment: .leading,
                                   spacing: Views.Constants.episodePropertiesNameValueSpacing) {
                                Text(Views.Constants.episodePropertyNameTitle)
                                    .episodePropertyNameTextModifier()
                                Text(episode.name)
                                    .font(.body)
                            }
                            
                            VStack(alignment: .leading,
                                   spacing: Views.Constants.episodePropertiesNameValueSpacing) {
                                Text(Views.Constants.episodePropertyNameAirDate)
                                    .episodePropertyNameTextModifier()
                                Text(episode.airDate)
                                    .font(.body)
                            }
                            
                            VStack(alignment: .leading,
                                   spacing: Views.Constants.episodePropertiesNameValueSpacing) {
                                Text(Views.Constants.episodePropertyNameEpisode)
                                    .episodePropertyNameTextModifier()
                                Text(episode.episode)
                                    .font(.body)
                            }
                            
                            VStack(alignment: .leading,
                                   spacing: Views.Constants.episodePropertiesNameValueSpacing) {
                                Text(Views.Constants.episodePropertyNameCharactersCount)
                                    .episodePropertyNameTextModifier()
                                Text(String(episode.characters.count))
                                    .font(.body)
                            }
                        }
                    }
                    
                    Spacer()
                }
                .padding()
                .padding(.top)
                
                Spacer()
            }
            .modifier(LoadingIndicatorModal(isPresented: $store.displayingLoadingModal.sending(\.displayLoadingModal)))
            .modifier(ErrorModal(isPresented: $store.displayingErrorModal.sending(\.displayErrorModal),
                                 errorDescription: store.errorText))
            .onAppear {
                store.send(.onAppear)
            }
        }
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

private extension Views {
    struct Constants {
        static let episodeLabelPrefix: String = "Episode"
        static let episodePropertiesColumnVStackSpacing: CGFloat = 15
        static let episodePropertiesNameValueSpacing: CGFloat = 7
        static let episodePropertyNameTitle: String = "Title"
        static let episodePropertyNameAirDate: String = "Air Date"
        static let episodePropertyNameEpisode: String = "Episode"
        static let episodePropertyNameCharactersCount: String = "Characters Count"
        static let episodePropertyTextColorOpacity: CGFloat = 0.8
    }
}

private extension Text {
    func episodePropertyNameTextModifier() -> some View {
        self.font(.callout)
            .fontWeight(.semibold)
            .foregroundStyle(.red.opacity(Views.Constants.episodePropertyTextColorOpacity))
    }
}
