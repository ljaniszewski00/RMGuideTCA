import ComposableArchitecture
import XCTest
@testable import RMGuideTCA

final class CharactersListFeatureTests: XCTestCase {

    override func setUpWithError() throws {
        
    }

    override func tearDownWithError() throws {
        
    }
    
    func testBasics() async {
        let store = await TestStore(initialState: CharactersListFeature.State()) {
            CharactersListFeature()
        }
        
        let newSearchText: String = "New search text"
        await store.send(.searchTextChanged(newSearchText)) {
            $0.searchText = newSearchText
        }
    }
}
