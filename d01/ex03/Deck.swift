import Foundation

class Deck : NSObject {
    static let allSpades = Value.allValues.map { Card(c: Color.Spade, v: $0) }
    static let allDiamonds = Value.allValues.map { Card(c: Color.Diamond, v: $0) }
    static let allHearts = Value.allValues.map { Card(c: Color.Heart, v: $0) }
    static let allClubs = Value.allValues.map { Card(c: Color.Club, v: $0) }
    static let allCards = allSpades + allDiamonds + allHearts + allClubs
}

extension Array {
    mutating func shuffle() {
        let arraySize = UInt32(self.count)
        for i in 0 ..< self.count {
            let tmpVal = self[i]
            let swapIndex = Int(arc4random_uniform(arraySize))
            self[i] = self[swapIndex]
            self[swapIndex] = tmpVal
        }
    }
}