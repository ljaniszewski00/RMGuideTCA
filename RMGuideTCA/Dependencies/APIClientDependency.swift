import Foundation
import ComposableArchitecture

private enum GetRMCharactersAPIClientDependencyKey: DependencyKey {
    static let liveValue = APIClients.getRMCharactersAPIClient
}

private enum GetRMEpisodeDetailsAPIClientDependencyKey: DependencyKey {
    static let liveValue = APIClients.getRMEpisodeDetailsAPIClient
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
