// First card
let card1: Card = Card(c : Color.Spade, v : Value.Ace)
print("Base card -> \(card1)")
print("Compare with self: \(card1 == card1)")
print("isEqual to self: \(card1.isEqual(to: card1))")

// Second card
let card2 = Card(c : Color.Diamond, v: Value.Two)
print("-")
print("\(card2) isEqual to base: \(card1.isEqual(to: card2))")
print("\(card2) == to base: \(card1 == card2)")

// Bonus test (1)
let card3 = Card(c : Color.Spade, v : Value.Ace)
print("-")
print("\(card3) isEqual to base: \(card1.isEqual(to: card3))")
print("\(card3) == to base: \(card1 == card3)")

// Bonus test (2)
let card4 = Card(c : Color.Spade, v : Value.King)
print("-")
print("\(card4) isEqual to base: \(card1.isEqual(to: card4))")
print("\(card4) == to base: \(card1 == card4)")

// Bonus test (3)
let card5 = Card(c : Color.Heart, v : Value.Ace)
print("-")
print("\(card5) isEqual to base: \(card1.isEqual(to: card5))")
print("\(card5) == to base: \(card1 == card5)")

// Bonus test (4)
let troll1 = Value.Ace
print("-")
print("\(troll1) isEqual to base: \(card1.isEqual(to: troll1))")

// Bonus test (4)
let troll2: Card? = nil
print("-")
print("nil isEqual to base: \(card1.isEqual(to: nil))")
