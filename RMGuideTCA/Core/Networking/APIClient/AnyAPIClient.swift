class AnyAPIClient<RequestInputType: Encodable,
                   RequestResponseType: Decodable>: APIClientProtocol {

    required init<Client: APIClientProtocol>(_ client: Client)
    where Client.RequestInputType == RequestInputType,
    Client.RequestResponseType == RequestResponseType {
        _request = client.request
    }

    // MARK: - APIClientProtocol

    func request(_ endpoint: APIEndpoint,
                 requestInput: RequestInputType,
                 additionalPathContent: String? = nil) async throws -> Result<RequestResponseType, Error> {
        try await _request(endpoint, requestInput, additionalPathContent)
    }

    private let _request: (APIEndpoint,
                           RequestInputType,
                           String?) async throws -> Result<RequestResponseType, Error>

}
