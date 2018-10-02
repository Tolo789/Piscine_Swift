import Foundation

class Card : NSObject {
    var color : Color
    var value : Value

    init(c: Color, v: Value) {
        self.color = c
        self.value = v
    }

    override var description : String {
        get {
            return "(\(value.rawValue), \(color.rawValue))"
        }
    }

    override func isEqual(to object: Any?) -> Bool {
        if let otherObj = object as? Card {
            return color == otherObj.color && value == otherObj.value
        }
        return false
    }

    static func == (lhs: Card, rhs: Card) -> Bool {
        return lhs.isEqual(to: rhs)
    }
}