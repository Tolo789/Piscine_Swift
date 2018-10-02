print("--- All Cards ------------------------")
var cards = Deck.allCards
for card in cards {
    print (card)
}
print("--- Shuffled Cards ------------------------")
cards.shuffle()
for card in cards {
    print (card)
}