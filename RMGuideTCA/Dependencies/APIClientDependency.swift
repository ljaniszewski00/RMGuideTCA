import Foundation
import ComposableArchitecture

private enum GetRMCharactersAPIClientDependencyKey: DependencyKey {
    static var liveValue = APIClients.getRMCharactersAPIClient
    static var testValue = APIClients.mockGetRMCharactersAPIClient
}

private enum GetRMEpisodeDetailsAPIClientDependencyKey: DependencyKey {
    static var liveValue = APIClients.getRMEpisodeDetailsAPIClient
    static var testValue = APIClients.mockRMEpisodeDetailsAPIClient
}

extension DependencyValues {
    var getRMCharactersAPIClient: APIClient<EmptyRequestInput, RMCharacterResponse> {
        get { self[GetRMCharactersAPIClientDependencyKey.self] }
        set { self[GetRMCharactersAPIClientDependencyKey.self] = newValue }
    }
    
    var getRMEpisodeDetailsAPIClient: APIClient<EmptyRequestInput, RMEpisode> {
        get { self[GetRMEpisodeDetailsAPIClientDependencyKey.self] }
        set { self[GetRMEpisodeDetailsAPIClientDependencyKey.self] = newValue }
    }
}
