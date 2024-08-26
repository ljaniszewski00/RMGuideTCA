enum APIClients {
    static let getRMCharactersAPIClient: APIClient<EmptyRequestInput, RMCharacterResponse> = {
        registerAPIClient(EmptyRequestInput.self, RMCharacterResponse.self)
    }()
}
