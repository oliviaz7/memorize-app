//
//  EmojiMemoryGame.swift
//  Memorize (iOS)
//
//  Created by Olivia Zhang on 2022-05-08.
//

import SwiftUI

class EmojiMemoryGame: ObservableObject {
    // typealias allows us to provide a new name for existing data
    typealias Card = MemoryGame<String>.Card
    
    private static let emojis = ["🐱","🐼","🐛","🐣","🦫","🦤","🐲","🦧","🦈","🦓","🦜","🐴","🐭","🐤","🐝","🦢","🦋","🦉","🦑","🐋","🦭","🦖","🐢","🦛","⛄️"]

    // our cards are Strings
    private static func createMemoryGame() -> MemoryGame<String> {
        MemoryGame<String>(numberOfPairsOfCards: 12) { pairIndex in
            emojis[pairIndex]
        }
    }
    
    @Published private var model = createMemoryGame()
        
    var cards: Array<Card> {
        return model.cards
    }
    
    // MARK: - INTENTS
    
    func choose(_ card: Card) {
        model.choose(card)
    }
    
    func shuffle() {
        model.shuffle()
    }
    
    func restart() {
        model = EmojiMemoryGame.createMemoryGame()
    }
}
