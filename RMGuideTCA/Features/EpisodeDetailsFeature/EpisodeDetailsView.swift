import SwiftUI

struct EpisodeDetailsView: View {
    let episodeNumberString: String
    
    var body: some View {
        Text(episodeNumberString)
    }
}

#Preview {
    EpisodeDetailsView(episodeNumberString: "6")
}
