//
//  MemoryGame.swift
//  Memorize (iOS)
//
//  Created by Olivia Zhang on 2022-05-08.
//

import Foundation

// Swift detects when structs change, but not when classes change

// someone needs to declare the type for CardContent
// CardConent is a "dont care" type
struct MemoryGame<CardContent> where CardContent: Equatable {
    private(set) var cards: Array<Card>
    
    private var indexOfTheOneAndOnlyFaceUpCard: Int? {
        get { cards.indices.filter ({ cards[$0].isFaceUp }).oneAndOnly }
        set { cards.indices.forEach { cards[$0].isFaceUp = ($0 == newValue) } }
    }
    
    mutating func choose(_ card: Card) {
        if let chosenIndex = cards.firstIndex(where: {$0.id == card.id}),
            !cards[chosenIndex].isFaceUp,
            !cards[chosenIndex].isMatched
        {
            if let potentialMatchIndex = indexOfTheOneAndOnlyFaceUpCard {
                if cards[chosenIndex].content == cards[potentialMatchIndex].content {
                    cards[chosenIndex].isMatched = true
                    cards[potentialMatchIndex].isMatched = true
                }
                cards[chosenIndex].isFaceUp = true
            } else {
                // if in this case, clicked then there was no "one and only face up card". so now we
                // make this card
                indexOfTheOneAndOnlyFaceUpCard = chosenIndex
            }
        }
        print("\(cards)")
    }
    
    mutating func shuffle () {
        cards.shuffle()
    }
    
    func index (of card: Card) -> Int? {
        for index in 0..<cards.count {
            if cards[index].id == card.id {
                return index
            }
        }
        return nil
    }
    
    init(numberOfPairsOfCards: Int, createCardContent: (Int) -> CardContent) {
        cards = [] // type inference, creates an empty array
        // add numberOfPairsOfCards x 2 cards to cards array
        for pairIndex in 0..<numberOfPairsOfCards {
            let content = createCardContent(pairIndex)
            cards.append(Card(content: content, id: pairIndex*2))
            cards.append(Card(content: content, id: pairIndex*2 + 1))
        }
        cards.shuffle()
    }
     
    struct Card: Identifiable {
        var isFaceUp = false {
            didSet {
                if isFaceUp {
                    startUsingBonusTime()
                } else {
                    stopUsingBonusTime()
                }
            }
        }
        var isMatched = false {
            didSet {
                stopUsingBonusTime()
            }
        }
        let content: CardContent // "CardContent" is a don't care type
        let id: Int // let because the id never changes!
        
        // MARK: - Bonus Time

        // extra time gives the user bonus points if the user matches the card before
        // a certain amount of time passes when the card is face up

        var bonusTimeLimit: TimeInterval = 6 // can be zero (no bonus time left)

        // keep track of how long the card has been face up
        private var faceUpTime: TimeInterval {
            if let lastFaceUpDate = self.lastFaceUpDate {
                return pastFaceUpTime + Date().timeIntervalSince(lastFaceUpDate)
            } else {
                return pastFaceUpTime
            }
        }
        // the last time this card was face up (and still is face up)
        var lastFaceUpDate: Date?

        // the accumulated time this card has been face up in the past
        var pastFaceUpTime: TimeInterval = 0

        // how much time is left before the bonus opportunity runs out
        var bonusTimeRemaining: TimeInterval {
            max(0, bonusTimeLimit - faceUpTime)
        }

        // percentage of the bonus time remaining
        var bonusRemaining: Double {
            (bonusTimeLimit > 0 && bonusTimeRemaining > 0) ? bonusTimeRemaining/bonusTimeLimit : 0
        }
        
        // bool if the card was matched during the bonus time period
        var hasEarnedBonus: Bool {
            isMatched && bonusTimeRemaining > 0
        }

        // bool for if card is currenlty face up, unmatched and haven't used up all the bonus time
        var isConsumingBonusTime: Bool {
            isFaceUp && !isMatched && bonusTimeRemaining > 0
        }

        // called when the card transitions to face up state
        private mutating func startUsingBonusTime() {
            if isConsumingBonusTime, lastFaceUpDate == nil {
                lastFaceUpDate = Date()
            }
        }

        // called when the card goes back face down (or gets matched)
        private mutating func stopUsingBonusTime() {
            pastFaceUpTime = faceUpTime
            self.lastFaceUpDate = nil
        }
    }
}

extension Array { // Array's call their "don't care"s: Element
    var oneAndOnly: Element? { // optional, if there's more than one or it's nil, return nil
        if count == 1 {
            return first
        } else {
            return nil
        }
    }
}
