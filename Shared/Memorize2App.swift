//
//  MemorizeApp.swift
//  Shared
//
//  Created by Olivia Zhang on 2022-03-26.
//

import SwiftUI

@main

struct MemorizeApp: App {
    private let game = EmojiMemoryGame()
    
    var body: some Scene {
        WindowGroup {
            EmojiMemoryGameView(game: game)
        }
    }
}
