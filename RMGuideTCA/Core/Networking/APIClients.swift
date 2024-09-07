enum APIClients {
    static let getRMCharactersAPIClient: APIClient<EmptyRequestInput, RMCharacterResponse> = {
        registerAPIClient(EmptyRequestInput.self, RMCharacterResponse.self)
    }()
    
    static let getRMEpisodeDetailsAPIClient: APIClient<EmptyRequestInput, RMEpisode> = {
        registerAPIClient(EmptyRequestInput.self, RMEpisode.self)
    }()
}
