import ComposableArchitecture
import SwiftUI

struct CharactersListView: View {
    @Perception.Bindable var store: StoreOf<CharactersListFeature>
    
    var body: some View {
        WithPerceptionTracking {
            if store.showCharactersList {
                
            } else {
                Views.StartView(store: store)
            }
        }
    }
}

#Preview {
    CharactersListView(
        store: Store(
            initialState: CharactersListFeature.State(),
            reducer: {
                CharactersListFeature()
            }
        )
    )
}

private extension Views {
    struct Constants {
        static let startViewVStackSpacing: CGFloat = 15
        static let guideAppText: String = "Guide App"
        static let guideAppLabelBottomPadding: CGFloat = 20
        static let instructionDescription: String = "Click the button below to display full Rick and Morty characters list."
        static let buttonLabel: String = "Show characters list"
        static let HStackPadding: CGFloat = 10
        static let HStackHorizontalPadding: CGFloat = 10
        
        static let exitButtonImageName: String = "rectangle.portrait.and.arrow.right"
        static let nonFavoriteImageName: String = "heart"
        static let favoriteImageName: String = "heart.fill"
        static let favoriteButtonImageColorOpacity: CGFloat = 0.8
        static let navigationTitleFullList: String = "Characters"
        
        static let characterListCellOuterHStackSpacing: CGFloat = 10
        static let characterListCellInnerHStackSpacing: CGFloat = 15
        static let characterListCellOuterHStackPadding: CGFloat = 5
        
        static let gridItemMinimumSize: CGFloat = 50
        static let navigationLinkOpacity: CGFloat = 0.0
        static let gridListRowInsetValue: CGFloat = 0
        static let characterListCellImageSize: CGFloat = 80
        static let characterListCellImageRadius: CGFloat = 10
        static let characterGridCellVStackSpacing: CGFloat = 0
        static let characterGridCellImageSize: CGFloat = 120
        static let imagePlaceholderName: String = "person.crop.circle.fill"
        static let favoriteImageWidth: CGFloat = 20
        static let favoriteImageHeight: CGFloat = 17
        static let favoriteImageBackgroundPadding: CGFloat = 10
        static let favoriteImageXOffset: CGFloat = 15
        static let characterNameBackgroundPadding: CGFloat = 10
        static let characterNameHorizontalPadding: CGFloat = 5
        static let characterNameYOffset: CGFloat = -15
    }
    
    struct StartView: View {
        let store: StoreOf<CharactersListFeature>
        
        var body: some View {
            VStack(spacing: Views.Constants.startViewVStackSpacing) {
                Spacer()
                
                Image(.rickAndMortyLogo)
                    .resizable()
                    .scaledToFit()
                
                Text(Views.Constants.guideAppText)
                    .font(.largeTitle)
                    .fontWeight(.semibold)
                    .padding(.vertical)
                    .padding(.bottom, Views.Constants.guideAppLabelBottomPadding)
                
                Text(Views.Constants.instructionDescription)
                    .font(.headline)
                    .foregroundStyle(.gray)
                
                Spacer()
                
                Button {
                    store.send(.showCharactersListButtonTapped)
                } label: {
                    HStack {
                        Text(Views.Constants.buttonLabel)
                            .font(.headline)
                    }
                    .padding()
                    .padding(.horizontal)
                    .background(
                        .ultraThinMaterial,
                        in: Capsule()
                    )
                }
                
                Spacer()
            }
            .padding()
        }
    }
}
