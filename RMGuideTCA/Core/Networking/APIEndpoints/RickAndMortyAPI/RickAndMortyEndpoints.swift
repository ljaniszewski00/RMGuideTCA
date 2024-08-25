import Foundation

enum RickAndMortyEndpoints {
    case character
    case episode
}

extension RickAndMortyEndpoints: APIEndpoint {
    var baseURL: URL {
        URL(string: "https://rickandmortyapi.com/api/")!
    }
    
    var path: String {
        switch self {
        case .character:
            return "character/"
        case .episode:
            return "episode/"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .character:
            return .get
        case .episode:
            return .get
        }
    }
    
    var headers: [String : String] {
        [
            "Content-Type": "application/json"
        ]
    }
}
