import Foundation

class Deck : NSObject {
    static let allSpades = Value.allValues.map { Card(c: Color.Spade, v: $0) }
    static let allDiamonds = Value.allValues.map { Card(c: Color.Diamond, v: $0) }
    static let allHearts = Value.allValues.map { Card(c: Color.Heart, v: $0) }
    static let allClubs = Value.allValues.map { Card(c: Color.Club, v: $0) }
    static let allCards = allSpades + allDiamonds + allHearts + allClubs
}