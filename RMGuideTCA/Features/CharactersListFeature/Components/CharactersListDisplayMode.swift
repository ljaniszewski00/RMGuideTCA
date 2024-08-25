enum CharactersListDisplayMode {
    case list
    case grid
}

extension CharactersListDisplayMode {
    var displayModeIconName: String {
        switch self {
        case .list:
            return "list.bullet.circle"
        case .grid:
            return "square.grid.3x3.square"
        }
    }
}
