import Foundation

extension Array: RawRepresentable where Element: Codable {
    public init?(rawValue: String) {
        guard let data = rawValue.data(using: .utf8),
              let result = try? JSONDecoder().decode([Element].self, from: data) else {
            return nil
        }
        
        self = result
    }

    public var rawValue: String {
        guard let data = try? JSONEncoder().encode(self),
              let result = String(data: data, encoding: .utf8) else {
            return "[]"
        }
        
        return result
    }
    
    public mutating func appendWithoutDuplicating<S>(
        contentsOf newElements: S,
        where condition: @escaping (Element, Element) -> Bool
    ) where S : Sequence, Element == S.Element {
        newElements.forEach { (item) in
            if !(self.contains(where: { (selfItem) -> Bool in
                return !condition(selfItem, item)
            })) {
                self.append(item)
            }
        }
    }
    
    public mutating func appendWithoutDuplicating(
        _ newElement: Element
    ) {
        self.append(newElement)
        let orderedSet: NSMutableOrderedSet = []
        orderedSet.addObjects(from: self)
        
        var modifiedArray = [Element]()
        
        for i in 0...(orderedSet.count - 1) {
            modifiedArray.append(orderedSet[i] as! Element)
        }
        
        self = modifiedArray
    }
}
