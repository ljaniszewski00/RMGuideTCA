import Foundation

class CharactersMockAPIClient<RequestInputType: Encodable,
                              RequestResponseType: Decodable>: APIClient<EmptyRequestInput, RMCharacterResponse> {
    func request(_ endpoint: APIEndpoint,
                 requestInput: RequestInputType,
                 additionalPathContent: String? = nil) async throws -> Result<RequestResponseType, Error> {
        let encoder = JSONEncoder()
        let encodedCharacters = try encoder.encode(RMCharacter.sampleCharacter)
        
        let decoder = JSONDecoder()
        
        do {
            let decodedData = try decoder.decode(
                RequestResponseType.self,
                from: encodedCharacters
            )
            return .success(decodedData)
        } catch(let decodingError) {
            return .failure(APIError.decodingError(decodingError.localizedDescription))
        }
    }
}
