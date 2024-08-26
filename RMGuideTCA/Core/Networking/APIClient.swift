import Foundation

class APIClient<RequestInputType: Encodable,
                RequestResponseType: Decodable>: APIClientProtocol {
    func request(_ endpoint: APIEndpoint,
                 requestInput: RequestInputType,
                 additionalPathContent: String? = nil) async throws -> Result<RequestResponseType, Error> {
        var pathToAppend = endpoint.path
        
        if let additionalPathContent = additionalPathContent {
            pathToAppend += additionalPathContent
        }
        
        let url = endpoint.baseURL.appendingPathComponent(pathToAppend)
        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method.rawValue
        request.allHTTPHeaderFields = endpoint.headers
        
        if endpoint.method != .get {
            do {
                let encoder = JSONEncoder()
                let encodedBody = try encoder.encode(requestInput)
                request.httpBody = encodedBody
            } catch(let encodingError) {
                return .failure(APIError.encodingError(encodingError.localizedDescription))
            }
        }
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode) else {
            return .failure(APIError.invalidResponse)
        }
        
        let decoder = JSONDecoder()
        
        do {
            let decodedData = try decoder.decode(RequestResponseType.self, from: data)
            return .success(decodedData)
        } catch(let decodingError) {
            return .failure(APIError.decodingError(decodingError.localizedDescription))
        }
    }
}

protocol APIClientProtocol {
    associatedtype RequestInputType: Encodable
    associatedtype RequestResponseType: Decodable
    
    func request(_ endpoint: APIEndpoint,
                 requestInput: RequestInputType,
                 additionalPathContent: String?) async throws -> Result<RequestResponseType, Error>
}
