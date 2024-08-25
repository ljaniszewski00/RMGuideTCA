import Foundation

class RMEpisodeObject: NSObject {
    let id: Int
    let name: String
    let airDate: String
    let episode: String
    let characters: [String]
    let url: String
    let created: String
    
    init(id: Int,
         name: String,
         airDate: String,
         episode: String,
         characters: [String],
         url: String,
         created: String) {
        self.id = id
        self.name = name
        self.airDate = airDate
        self.episode = episode
        self.characters = characters
        self.url = url
        self.created = created
    }
}

extension RMEpisodeObject {
    func toModel() -> RMEpisode {
        RMEpisode(id: id,
                  name: name,
                  airDate: airDate,
                  episode: episode,
                  characters: characters,
                  url: url,
                  created: created)
    }
}

extension RMEpisodeObject: NSDiscardableContent {
    func beginContentAccess() -> Bool {
        return true
    }
    
    func endContentAccess() {}
    
    func discardContentIfPossible() {}
    
    func isContentDiscarded() -> Bool {
        return false
    }
}
