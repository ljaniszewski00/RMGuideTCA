import Foundation
import ComposableArchitecture

private enum GetRMCharactersAPIClientDependencyKey: DependencyKey {
    static let liveValue = APIClients.getRMCharactersAPIClient
}

extension DependencyValues {
    var getRMCharactersAPIClient: APIClient<EmptyRequestInput, RMCharacterResponse> {
        get { self[GetRMCharactersAPIClientDependencyKey.self] }
        set { self[GetRMCharactersAPIClientDependencyKey.self] = newValue }
    }
}
