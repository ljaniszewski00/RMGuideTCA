import ComposableArchitecture
import Foundation

struct APIClient {
    var makeCharactersRequest: () async throws -> Result<[RMCharacter], Error>
    
    var makeEpisodeDetailsRequest: (
        _ additionalPathContent: String?
    ) async throws -> Result<RMEpisode, Error>
}

extension APIClient: DependencyKey {
    
    @MainActor
    static let liveValue = Self(makeCharactersRequest: {
        let endpoint = RickAndMortyEndpoints.character
        var pathToAppend = endpoint.path
        
        let url = endpoint.baseURL.appendingPathComponent(pathToAppend)
        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method.rawValue
        request.allHTTPHeaderFields = endpoint.headers
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode) else {
            return .failure(APIError.invalidResponse)
        }
        
        let decoder = JSONDecoder()
        
        do {
            let decodedData = try decoder.decode(RMCharacterResponse.self, from: data)
            return .success(decodedData.results)
        } catch(let decodingError) {
            return .failure(APIError.decodingError(decodingError.localizedDescription))
        }
    }, makeEpisodeDetailsRequest: { additionalPathContent in
        let endpoint = RickAndMortyEndpoints.episode
        var pathToAppend = endpoint.path
        
        if let additionalPathContent = additionalPathContent {
            pathToAppend += additionalPathContent
        }
        
        let url = endpoint.baseURL.appendingPathComponent(pathToAppend)
        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method.rawValue
        request.allHTTPHeaderFields = endpoint.headers
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode) else {
            return .failure(APIError.invalidResponse)
        }
        
        let decoder = JSONDecoder()
        
        do {
            let decodedData = try decoder.decode(RMEpisode.self, from: data)
            return .success(decodedData)
        } catch(let decodingError) {
            return .failure(APIError.decodingError(decodingError.localizedDescription))
        }
    })

    @MainActor
    static let testValue = Self(makeCharactersRequest: {
        .success([.sampleCharacter])
    }, makeEpisodeDetailsRequest: { _ in
        .success(.sampleEpisode)
    })
}
