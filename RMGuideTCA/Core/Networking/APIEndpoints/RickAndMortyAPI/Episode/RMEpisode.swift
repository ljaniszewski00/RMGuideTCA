import Foundation

struct RMEpisode: Codable, Identifiable {
    let id: Int
    let name: String
    let airDate: String
    let episode: String
    let characters: [String]
    let url: String
    let created: String
    
    enum CodingKeys: String, CodingKey {
        case id, name, episode, characters, url, created
        case airDate = "air_date"
    }
}

extension RMEpisode: Equatable {
    static func ==(lhs: RMEpisode, rhs: RMEpisode) -> Bool {
        lhs.id == rhs.id
    }
}

extension RMEpisode {
    func toObject() -> RMEpisodeObject {
        RMEpisodeObject(id: id,
                        name: name,
                        airDate: airDate,
                        episode: episode,
                        characters: characters,
                        url: url,
                        created: created)
    }
    
    static let sampleEpisode: RMEpisode = RMEpisode(
        id: 0,
        name: "Pilot",
        airDate: "December 2, 2013",
        episode: "S01E01",
        characters: [
            "https://rickandmortyapi.com/api/character/1",
            "https://rickandmortyapi.com/api/character/2"
        ],
        url: "https://rickandmortyapi.com/api/episode/1",
        created: "2017-11-10T12:56:33.798Z"
    )
}
