print("--- Shuffled Deck ------------------------")
var deck = Deck(shuffleDeck: true)
print(deck)
print("--- Normal Deck ------------------------")
deck = Deck(shuffleDeck: false)
print(deck.fullDescription)
print("-- Draw first card --")
var card1 = deck.draw()
if let drawnCard = card1 {
    print("Drawn card: \(drawnCard)")
}
else {
    print("No more cards to draw..!")
}
print(deck.fullDescription)

print("-- Draw more cards then fold first one --")
card1 = deck.draw()
card1 = deck.draw()
card1 = deck.draw()
card1 = deck.draw()
if let drawnCard = card1 {
    deck.fold(c: drawnCard)
    deck.fold(c: drawnCard)
}
deck.fold(c: Card(c: Color.Heart, v: Value.King))
print(deck.fullDescription)
