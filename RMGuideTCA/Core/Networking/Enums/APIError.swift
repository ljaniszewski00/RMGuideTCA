enum APIError: Error {
    case decodingError(String)
    case encodingError(String)
    case invalidData
    case invalidResponse
}
