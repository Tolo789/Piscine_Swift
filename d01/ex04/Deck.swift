import Foundation

class Deck : NSObject {
    static let allSpades = Value.allValues.map { Card(c: Color.Spade, v: $0) }
    static let allDiamonds = Value.allValues.map { Card(c: Color.Diamond, v: $0) }
    static let allHearts = Value.allValues.map { Card(c: Color.Heart, v: $0) }
    static let allClubs = Value.allValues.map { Card(c: Color.Club, v: $0) }
    static let allCards = allSpades + allDiamonds + allHearts + allClubs

    var cards = allCards
    var discards = [Card]()
    var outs = [Card]()

    init(shuffleDeck: Bool) {
        if (shuffleDeck) {
            cards.shuffle()
        }
    }

    override var description : String {
        get {
            var str = ""
            for card in cards {
                str += card.description + "\n"
            }

            return str
        }
    }

    var fullDescription : String {
        get {
            var str = "- Cards:\n"
            for card in cards {
                str += card.description + "\n"
            }
            str += "- Outs:\n"
            for card in outs {
                str += card.description + "\n"
            }
            str += "- Discards:\n"
            for card in discards {
                str += card.description + "\n"
            }


            return str
        }

    }

    func draw() -> Card? {
        let drawnCard = cards.removeFirst()
        outs.append(drawnCard)

        return drawnCard
    }

    func fold(c: Card) {
        if let found = outs.enumerated().first(where: {$0.element == c}) {
            // do something with foo.offset and foo.element
            outs.remove(at: found.offset);
            discards.append(found.element)
        }
    }
}

extension Array {
    mutating func shuffle() {
        let arraySize = UInt32(self.count)
        for i in 0 ..< self.count {
            self.swapAt(i, Int(arc4random_uniform(arraySize)))
        }
    }
}