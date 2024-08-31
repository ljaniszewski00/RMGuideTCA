import ComposableArchitecture
import SwiftUI

struct CharactersListView: View {
    @Perception.Bindable var store: StoreOf<CharactersListFeature>
    
    var body: some View {
        NavigationStack(path: $store.scope(state: \.path, action: \.path)) {
            WithPerceptionTracking {
                if store.displayingCharactersList {
                    Views.CharactersView(store: store)
                } else {
                    Views.StartView(store: store)
                }
            }
        } destination: { store in
            switch store.case {
            case .characterDetails(let store):
                CharacterDetailsView(store: store)
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
                    store.send(.displayCharactersListButtonTapped)
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
    
    struct CharactersView: View {
        @Perception.Bindable var store: StoreOf<CharactersListFeature>
        
        var body: some View {
            WithPerceptionTracking {
                VStack {
                    List {
                        switch store.displayingMode {
                        case .list:
                            Views.CharactersList(store: store)
                        case .grid:
                            Views.CharactersGrid(store: store)
                        }
                    }
                    .listStyle(.plain)
    //                .refreshable {
    //                    await charactersListViewModel.onRefresh()
    //                }
                }
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button {
                            store.send(.changeDisplayModeButtonTapped)
                        } label: {
                            let imageName: String = store.displayingMode == .grid ?
                            CharactersListDisplayMode.list.displayModeIconName : CharactersListDisplayMode.grid.displayModeIconName
                            
                            Image(systemName: imageName)
                                .foregroundStyle(.gray)
                        }
                    }
                    
                    ToolbarItem(placement: .topBarTrailing) {
                        Button {
                            store.send(.displayFavoriteCharactersButtonTapped)
                        } label: {
                            let imageName: String = store.displayingOnlyFavoriteCharacters ?
                            Views.Constants.favoriteImageName : Views.Constants.nonFavoriteImageName
                            
                            Image(systemName: imageName)
                                .foregroundStyle(
                                    .red.opacity(Views.Constants.favoriteButtonImageColorOpacity)
                                )
                        }
                    }
                    
                    ToolbarItem(placement: .topBarLeading) {
                        Button {
                            store.send(.exitCharactersListButtonTapped)
                        } label: {
                            Image(systemName: Views.Constants.exitButtonImageName)
                                .foregroundStyle(.gray)
                        }
                    }
                }
                .searchable(text: $store.searchText.sending(\.searchTextChanged))
                .modifier(LoadingIndicatorModal(isPresented: $store.displayingLoadingModal.sending(\.displayLoadingModal)))
                .modifier(ErrorModal(isPresented: $store.displayingErrorModal.sending(\.displayErrorModal),
                                     errorDescription: store.errorText))
                .navigationTitle(Views.Constants.navigationTitleFullList)
                .navigationBarTitleDisplayMode(.inline)
            }
        }
    }
    
    struct CharactersList: View {
        let store: StoreOf<CharactersListFeature>
        
        var body: some View {
            WithPerceptionTracking {
                ForEach(store.charactersToDisplay, id: \.id) { character in
                    CharacterListCell(store: store, character: character)
                }
            }
        }
    }
    
    struct CharacterListCell: View {
        let store: StoreOf<CharactersListFeature>
        let character: RMCharacter
        
        var isFavorite: Bool {
            store.favoriteCharactersIds.contains(character.id)
        }
        
        var body: some View {
            WithPerceptionTracking {
                NavigationLink (
                    state: CharactersListFeature.Path.State.characterDetails(
                        CharacterDetailsFeature.State(
                            character: character
                        )
                    )
                ) {
                    HStack(spacing: Views.Constants.characterListCellOuterHStackSpacing) {
                        AsyncImage(url: URL(string: character.image)) { image in
                            image
                                .listCharacterImageModifier()
                        } placeholder: {
                            Image(systemName: Views.Constants.imagePlaceholderName)
                                .listCharacterImageModifier()
                        }
                        
                        HStack(spacing: Views.Constants.characterListCellInnerHStackSpacing) {
                            Text(character.name)
                                .font(.title3)
                                .fontWeight(.semibold)
                                .multilineTextAlignment(.leading)
                            
                            Image(systemName: isFavorite ? Views.Constants.favoriteImageName : Views.Constants.nonFavoriteImageName)
                                .resizable()
                                .frame(width: Views.Constants.favoriteImageWidth,
                                       height: Views.Constants.favoriteImageHeight)
                                .foregroundStyle(
                                    .red.opacity(Views.Constants.favoriteButtonImageColorOpacity)
                                )
                                .onTapGesture {
                                    store.send(.favoriteButtonTapped(character.id))
                                }
                        }
                        .padding([.top, .leading],
                                 Views.Constants.characterListCellOuterHStackPadding)
                    }
                }
            }
        }
    }
    
    struct CharactersGrid: View {
        let store: StoreOf<CharactersListFeature>
        
        @State var selectedCharacter: RMCharacter?
        
        private let columns: [GridItem] = [
            GridItem(.flexible(minimum: Views.Constants.gridItemMinimumSize)),
            GridItem(.flexible(minimum: Views.Constants.gridItemMinimumSize))
        ]
        
        var body: some View {
            WithPerceptionTracking {
                LazyVGrid(columns: columns) {
                    ForEach(store.charactersToDisplay, id: \.id) { character in
                        Views.CharacterGridCell(store: store, character: character)
                            .background {
                                NavigationLink(
                                    destination: CharacterDetailsView(
                                        store:
                                            Store(
                                                initialState: CharacterDetailsFeature.State(character: character),
                                                reducer: {
                                                    CharacterDetailsFeature()
                                                }
                                            )),
                                    tag: character,
                                    selection: $selectedCharacter,
                                    label: {
                                        EmptyView()
                                })
                                .opacity(Views.Constants.navigationLinkOpacity)
                            }
                            .onTapGesture {
                                selectedCharacter = character
                            }
                    }
                }
                .padding(.top)
                .listRowInsets(.init(
                    top: Views.Constants.gridListRowInsetValue,
                    leading: Views.Constants.gridListRowInsetValue,
                    bottom: Views.Constants.gridListRowInsetValue,
                    trailing: Views.Constants.gridListRowInsetValue
                ))
                .listRowSeparator(.hidden)
                .listRowBackground(Color.clear)
                .listSectionSeparator(.hidden)
            }
        }
    }
    
    struct CharacterGridCell: View {
        let store: StoreOf<CharactersListFeature>
        let character: RMCharacter
        
        var isFavorite: Bool {
            store.favoriteCharactersIds.contains(character.id)
        }
        
        var body: some View {
            VStack(spacing: Views.Constants.characterGridCellVStackSpacing) {
                ZStack(alignment: .topTrailing) {
                    AsyncImage(url: URL(string: character.image)) { image in
                        image
                            .gridCharacterImageModifier()
                    } placeholder: {
                        Image(systemName: Views.Constants.imagePlaceholderName)
                            .gridCharacterImageModifier()
                    }
                    
                    Image(systemName: isFavorite ? Views.Constants.favoriteImageName : Views.Constants.nonFavoriteImageName)
                        .resizable()
                        .frame(width: Views.Constants.favoriteImageWidth,
                               height: Views.Constants.favoriteImageHeight)
                        .foregroundStyle(
                            .red.opacity(Views.Constants.favoriteButtonImageColorOpacity)
                        )
                        .padding(Views.Constants.favoriteImageBackgroundPadding)
                        .background(
                            .ultraThinMaterial,
                            in: Circle()
                        )
                        .onTapGesture {
                            store.send(.favoriteButtonTapped(character.id))
                        }
                        .offset(x: Views.Constants.favoriteImageXOffset)
                }
                
                Text(character.name)
                    .font(.headline)
                    .multilineTextAlignment(.center)
                    .padding(Views.Constants.characterNameBackgroundPadding)
                    .padding(.horizontal, Views.Constants.characterNameHorizontalPadding)
                    .background(
                        .ultraThinMaterial,
                        in: Capsule()
                    )
                    .offset(y: Views.Constants.characterNameYOffset)
            }
        }
    }
}

private extension Image {
    func listCharacterImageModifier() -> some View {
        self.resizable()
            .frame(width: Views.Constants.characterListCellImageSize,
                   height: Views.Constants.characterListCellImageSize)
            .clipShape(RoundedRectangle(cornerRadius: Views.Constants.characterListCellImageRadius))
    }
    
    func gridCharacterImageModifier() -> some View {
        self.resizable()
            .frame(width: Views.Constants.characterGridCellImageSize,
                   height: Views.Constants.characterGridCellImageSize)
            .clipShape(Circle())
    }
}
