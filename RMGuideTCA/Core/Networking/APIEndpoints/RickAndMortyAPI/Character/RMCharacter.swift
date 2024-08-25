struct RMCharacter: Codable, Identifiable {
    let id: Int
    let name: String
    let status: RMCharacterStatus
    let species: String
    let type: String
    let gender: RMCharacterGender
    let origin: RMCharacterOrigin
    let location: RMCharacterLocation
    let image: String
    let episode: [String]
    let url: String
    let created: String
}

extension RMCharacter: Equatable, Hashable {
    static func == (lhs: RMCharacter, rhs: RMCharacter) -> Bool {
        lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

extension RMCharacter {
    static let sampleCharacter: RMCharacter = RMCharacter(
        id: 0,
        name: "John Doe",
        status: .dead,
        species: "Species",
        type: "Type",
        gender: .unknown,
        origin: RMCharacterOrigin(
            name: "originName",
            url: "originURL"
        ),
        location: RMCharacterLocation(
            name: "locationName",
            url: "locationURL"),
        image: "",
        episode: ["1", "2", "3"],
        url: "",
        created: "2017-11-04T18:48:46.250Z"
    )
}
