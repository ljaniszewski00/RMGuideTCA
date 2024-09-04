import ComposableArchitecture
import SwiftUI

struct CharacterDetailsView: View {
    @Perception.Bindable var store: StoreOf<CharacterDetailsFeature>
    
    var body: some View {
        WithPerceptionTracking {
            ScrollView {
                VStack(alignment: .leading) {
                    HStack(alignment: .bottom,
                           spacing: Views.Constants.mainVStackSpacing) {
                        AsyncImage(url: URL(string: store.character.image)) { image in
                            image
                                .resizable()
                        } placeholder: {
                            Image(systemName: Views.Constants.imagePlaceholderName)
                                .resizable()
                        }
                        .frame(width: Views.Constants.imageFrameSize,
                               height: Views.Constants.imageFrameSize)
                        .clipShape(Capsule())
                        
                        Text(store.character.name)
                            .font(.largeTitle)
                            .fontWeight(.semibold)
                    }
                    .padding(.bottom)
                    
                    HStack(spacing: Views.Constants.characterPropertiesHStackSpacing) {
                        VStack(alignment: .leading,
                               spacing: Views.Constants.characterPropertiesColumnVStackSpacing) {
                            VStack(alignment: .leading,
                                   spacing: Views.Constants.characterPropertiesNameValueSpacing) {
                                Text(Views.Constants.characterPropertyNameStatus)
                                    .characterPropertyNameTextModifier()
                                Text(store.character.status.rawValue)
                                    .font(.body)
                            }
                            
                            VStack(alignment: .leading,
                                   spacing: Views.Constants.characterPropertiesNameValueSpacing) {
                                Text(Views.Constants.characterPropertyNameOrigin)
                                    .characterPropertyNameTextModifier()
                                Text(store.character.origin.name)
                                    .font(.body)
                            }
                        }
                        
                        VStack(alignment: .leading,
                               spacing: Views.Constants.characterPropertiesColumnVStackSpacing) {
                            VStack(alignment: .leading,
                                   spacing: Views.Constants.characterPropertiesNameValueSpacing) {
                                Text(Views.Constants.characterPropertyNameGender)
                                    .characterPropertyNameTextModifier()
                                Text(store.character.gender.rawValue)
                                    .font(.body)
                            }
                            
                            VStack(alignment: .leading,
                                   spacing: Views.Constants.characterPropertiesNameValueSpacing) {
                                Text(Views.Constants.characterPropertyNameLocation)
                                    .characterPropertyNameTextModifier()
                                Text(store.character.location.name)
                                    .font(.body)
                            }
                        }
                        
                        Spacer()
                    }
                    
                    Divider()
                        .padding(.vertical, Views.Constants.dividerVerticalPadding)
                    
                    VStack(alignment: .leading) {
                        Text(Views.Constants.episodesLabel)
                            .font(.title2)
                            .fontWeight(.semibold)
                        
                        Views.EpisodesGrid(store: store,
                                           episodes: store.character.episode)
                    }
                }
                .padding()
            }
            .navigationTitle(store.character.name.components(separatedBy: " ").first ?? "")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    let isFavorite: Bool = store.isCharacterFavorite
                    Button {
                        store.send(.favoriteButtonTapped)
                    } label: {
                        Image(systemName: isFavorite ? Views.Constants.favoriteImageName : Views.Constants.nonFavoriteImageName)
                            .foregroundStyle(
                                .red.opacity(Views.Constants.favoriteButtonImageColorOpacity)
                            )
                    }
                }
            }
        }
    }
}

#Preview {
    CharacterDetailsView(
        store: Store(
            initialState: CharacterDetailsFeature.State(character: .sampleCharacter),
            reducer: {
                CharacterDetailsFeature()
            }
        )
    )
}

private extension Views {
    struct Constants {
        static let mainVStackSpacing: CGFloat = 10
        static let imagePlaceholderName: String = "person.crop.circle.fill"
        static let imageFrameSize: CGFloat = 200
        static let characterPropertiesHStackSpacing: CGFloat = 40
        static let characterPropertiesColumnVStackSpacing: CGFloat = 15
        static let characterPropertiesNameValueSpacing: CGFloat = 7
        static let characterPropertyNameStatus: String = "Status"
        static let characterPropertyNameOrigin: String = "Origin"
        static let characterPropertyNameGender: String = "Gender"
        static let characterPropertyNameLocation: String = "Location"
        static let dividerVerticalPadding: CGFloat = 20
        static let gridItemMinimumSize: CGFloat = 50
        static let gridItemBackgroundPadding: CGFloat = 15
        static let episodesLabel: String = "Episodes"
        static let episodePrefix: String = "Episode"
        static let nonFavoriteImageName: String = "heart"
        static let favoriteImageName: String = "heart.fill"
        static let favoriteButtonImageColorOpacity: CGFloat = 0.8
        static let characterPropertyTextColorOpacity: CGFloat = 0.8
    }
    
    struct EpisodesGrid: View {
        @Perception.Bindable var store: StoreOf<CharacterDetailsFeature>
        let episodes: [String]
        
        private let columns = [
            GridItem(.adaptive(minimum: Views.Constants.gridItemMinimumSize))
        ]
        
        var body: some View {
            WithPerceptionTracking {
                LazyVGrid(columns: columns) {
                    ForEach(episodes, id: \.self) { episodeURLString in
                        if let episodeNumber = getEpisodeNumber(from: episodeURLString) {
                            Button {
                                store.send(.episodeButtonTapped(episodeNumber))
                            } label: {
                                Text(episodeNumber)
                                    .font(.caption)
                                    .fontWeight(.semibold)
                                    .padding(Views.Constants.gridItemBackgroundPadding)
                                    .background(
                                        .ultraThinMaterial,
                                        in: Circle()
                                    )
                            }
                        }
                    }
                }
                .halfSheet(showSheet: $store.displayingEpisodeDetailsView.sending(\.displayEpisodeDetails)) {
                    EpisodeDetailsView(
                        store: Store(
                            initialState: EpisodeDetailsFeature.State(episodeNumberString: store.selectedEpisodeNumber ?? ""),
                            reducer: {
                                EpisodeDetailsFeature()
                            }
                        )
                    )
                }
            }
        }
        
        private func getEpisodeNumber(from episodeURLString: String) -> String? {
            episodeURLString.components(separatedBy: "/").last
        }
    }
}

private extension Text {
    func characterPropertyNameTextModifier() -> some View {
        self.font(.callout)
            .fontWeight(.semibold)
            .foregroundStyle(.red.opacity(Views.Constants.characterPropertyTextColorOpacity))
    }
}
