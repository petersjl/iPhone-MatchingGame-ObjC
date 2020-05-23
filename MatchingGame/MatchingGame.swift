//
//  MatchingGame.swift
//  MatchingGame
//
//  Created by CSSE Department on 4/14/20.
//  Copyright © 2020 CSSE Department. All rights reserved.
//

import Foundation
class MatchingGame : CustomStringConvertible{
    
    let allCardBacks = Array("🎆🎇🌈🌅🌇🌉🌃🌄⛺⛲🚢🌌🌋🗽")
    let allEmojiCharacters = Array("🚁🐴🐇🐢🐱🐌🐒🐞🐫🐠🐬🐩🐶🐰🐼⛄🌸⛅🐸🐳❄❤🐝🌺🌼🌽🍌🍎🍡🏡🌻🍉🍒🍦👠🐧👛🐛🐘🐨😃🐻🐹🐲🐊🐙")
    
    enum cardState : String{
        case hidden = "Hidden", showing = "Showing", removed = "Removed"
    }
    
    enum gameStates : String{
        case firstTurn, secondTurn, turnComplete, gameWon
        
        func simpleDescription() -> String{
            switch self{
            case .firstTurn:
                return "Waiting for first selection"
            case .secondTurn:
                return "waiting for second selection"
            case .turnComplete:
                return "Turn complete"
            case .gameWon:
                return "The game is over"
            }
        }
    }
    
    var cards : [Character]
    var cardBack : Character
    var cardStates : [cardState]
    var gameState : gameStates
    var firstCard : Int?
    var secondCard : Int?
    
    init(){
    // Randomly select emojiSymbols
        var emojiSymbolsUsed = [Character]()
        while emojiSymbolsUsed.count < 10 {
          let index = Int(arc4random_uniform(UInt32(allEmojiCharacters.count)))
          let symbol = allEmojiCharacters[index]
          if !emojiSymbolsUsed.contains(symbol) {
            emojiSymbolsUsed.append(symbol)
          }
        }
        cards = emojiSymbolsUsed + emojiSymbolsUsed
        cards.shuffle()

        // Randomly select a card back for this round
        let index = Int(arc4random_uniform(UInt32(allCardBacks.count)))
        cardBack = allCardBacks[index]
        gameState = .firstTurn
        cardStates = [cardState](repeating: .hidden, count: 20)
        firstCard = nil
        secondCard = nil
    }
    
    func pressedCard(atIndex : Int) -> Bool{
        if gameState == gameStates.gameWon || gameState == gameStates.turnComplete {
            return false
        }
        if cardStates[atIndex] == .removed || cardStates[atIndex] == .showing {
            return false
        }
        if gameState == .firstTurn {
            firstCard = atIndex
            cardStates[atIndex] = .showing
            gameState = .secondTurn
            return true
        }
        if gameState == .secondTurn {
            secondCard = atIndex
            cardStates[atIndex] = .showing
            gameState = .turnComplete
            return true
        }
        return false
    }
    
    func startNewTurn() -> Bool{
        if firstCard == nil || secondCard == nil {
            print("Incomplete turn")
            return false
        }
        if cards[firstCard!] == cards[secondCard!] {
            cardStates[firstCard!] = .removed
            cardStates[secondCard!] = .removed
            gameState = .firstTurn
            firstCard = nil
            secondCard = nil
            return checkWin()
        }else{
            cardStates[firstCard!] = .hidden
            cardStates[secondCard!] = .hidden
            gameState = .firstTurn
            firstCard = nil
            secondCard = nil
            return false
        }
    }
    
    func checkWin() -> Bool {
        for state in cardStates{
            if state != .removed {
                return false
            }
        }
        gameState = .gameWon
        return true
    }
    
    var description: String {
        get{
            var str = ""
            for index in 0..<cards.count{
                str += String(cards[index])
                if (index + 1) % 4 == 0 {
                    str += "\n"
                }
            }
            return str
        }
    }
    
    

}

// Helper method to randomize the order of an Array. See usage later.  Copied from:
// http://stackoverflow.com/questions/24026510/how-do-i-shuffle-an-array-in-swift
extension Array {
    mutating func shuffle() {
        for i in 0..<(count - 1) {
            let j = Int(arc4random_uniform(UInt32(count - i))) + i
            self.swapAt(i, j)
        }
    }
}
