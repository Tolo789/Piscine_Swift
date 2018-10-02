import Foundation

class Deck : NSObject {
    static let allSpades = generateAllCardsOf(type: Color.Spade)
    static let allDiamonds = generateAllCardsOf(type: Color.Diamond)
    static let allHearts = generateAllCardsOf(type: Color.Heart)
    static let allClubs = generateAllCardsOf(type: Color.Club)
    static let allCards = allSpades + allDiamonds + allHearts + allClubs

    static func generateAllCardsOf(type: Color) -> [Card] {
        var tmpList = [Card]()
        for value in Value.allValues {
            tmpList.append(Card(c: type, v: value))
        }

        return tmpList
    }
}

extension Array {
    mutating func shuffle() {
        let arraySize = UInt32(self.count)
        for i in 0 ..< self.count {
            swapAt(i, Int(arc4random_uniform(arraySize)))
        }
    }
}