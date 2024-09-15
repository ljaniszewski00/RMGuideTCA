enum APIClients {
    static var getRMCharactersAPIClient: APIClient<EmptyRequestInput, RMCharacterResponse> = {
        registerAPIClient(EmptyRequestInput.self, RMCharacterResponse.self)
    }()
    
    static var mockGetRMCharactersAPIClient: APIClient<EmptyRequestInput, RMCharacterResponse> = {
        CharactersMockAPIClient<EmptyRequestInput, RMCharacterResponse>()
    }()
    
    static let getRMEpisodeDetailsAPIClient: APIClient<EmptyRequestInput, RMEpisode> = {
        registerAPIClient(EmptyRequestInput.self, RMEpisode.self)
    }()
    
    static let mockRMEpisodeDetailsAPIClient: APIClient<EmptyRequestInput, RMEpisode> = {
        registerAPIClient(EmptyRequestInput.self, RMEpisode.self)
    }()
}
