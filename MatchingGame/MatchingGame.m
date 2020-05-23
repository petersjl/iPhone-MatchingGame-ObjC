//
//  MatchingGame.m
//  MatchingGame
//
//  Created by CSSE Department on 4/30/20.
//  Copyright © 2020 CSSE Department. All rights reserved.
//

#import "MatchingGame.h"

@implementation MatchingGame

- (id) init{
    return [self initWithNumPairs: 10];
}

- (id) initWithNumPairs:(NSInteger) numPairs {
    self = [super init];
    if (self) {
        self.numPairs = numPairs;
        NSArray* allCardBacks = [@"🎆,🎇,🌈,🌅,🌇,🌉,🌃,🌄,⛺,⛲,🚢,🌌,🌋,🗽" componentsSeparatedByString:@","];
        NSArray* allEmojiCharacters = [@"🚁,🐴,🐇,🐢,🐱,🐌,🐒,🐞,🐫,🐠,🐬,🐩,🐶,🐰,🐼,⛄,🌸,⛅,🐸,🐳,❄,❤,🐝,🌺,🌼,🌽,🍌,🍎,🍡,🏡,🌻,🍉,🍒,🍦,👠,🐧,👛,🐛,🐘,🐨,😃,🐻,🐹,🐲,🐊,🐙" componentsSeparatedByString:@","];


        // Randomly select emojiSymbols
        NSMutableArray* emojiSymbolsUsed = [[NSMutableArray alloc] init];
        while (emojiSymbolsUsed.count < numPairs) {
            NSString* symbol = allEmojiCharacters[arc4random_uniform((UInt32) allEmojiCharacters.count)];
            if (![emojiSymbolsUsed containsObject:symbol]) {
                [emojiSymbolsUsed addObject:symbol];
            }
        }
        [emojiSymbolsUsed addObjectsFromArray:emojiSymbolsUsed];
        // Shuffle the NSMutableArray before converting it to an NSArray.
        for (int i = 0; i < emojiSymbolsUsed.count; ++i) {
            UInt32 j = arc4random_uniform((UInt32) emojiSymbolsUsed.count - i) + i;
            [emojiSymbolsUsed exchangeObjectAtIndex:i withObjectAtIndex:j];
        }
        self.cards = [NSArray arrayWithArray:emojiSymbolsUsed];

        // Randomly select a card back.
        self.cardBack = allCardBacks[arc4random_uniform((UInt32) allCardBacks.count)];

        // Reset cardStates to ensure default values.
        for (int i = 0; i < self.cards.count; ++i) {
            cardStates[i] = CardStateHidden;
        }
    }
    self.firstCard = -1;
    self.secondCard = -1;
    return self;
}

- (bool) pressedCardAtIndex:(NSInteger)index{
    if(self.gameState == GameStateGameWon || self.gameState == GameStateTurnComplete){
        return false;
    }
    if(cardStates[index] != CardStateHidden){
        return false;
    }
    if(self.gameState == GameStateFirstTurn){
        self.firstCard = index;
        cardStates[index] = CardStateShowing;
        self.gameState = GameStateSecondTurn;
        return true;
    }
    if(self.gameState == GameStateSecondTurn){
        self.secondCard = index;
        cardStates[index] = CardStateShowing;
        self.gameState = GameStateTurnComplete;
        return true;
    }
    return false;
}

- (bool) startNewTurn{
    if(self.firstCard == -1 || self.secondCard == -1){
        NSLog(@"Incomplete turn");
        return false;
    }
    if(self.cards[self.firstCard] == self.cards[self.secondCard]){
        cardStates[self.firstCard] = CardStateRemoved;
        cardStates[self.secondCard] = CardStateRemoved;
        self.gameState = GameStateFirstTurn;
        self.firstCard = -1;
        self.secondCard = -1;
        return [self checkWin];
    }else{
        cardStates[self.firstCard] = CardStateHidden;
        cardStates[self.secondCard] = CardStateHidden;
        self.gameState = GameStateFirstTurn;
        self.firstCard = -1;
        self.secondCard = -1;
        return false;
    }
}

- (bool) checkWin{
    for(int i = 0; i < self.cards.count; ++i){
        if(cardStates[i] != CardStateRemoved) return false;
    }
    self.gameState = GameStateGameWon;
    return true;
}

- (NSString*) description{
    NSString* str = @"";
    for(int i = 0; i < self.cards.count; ++i){
        str = [str stringByAppendingFormat:@"%@", self.cards[i]];
        if((i + 1) % 4 == 0){
            str = [str stringByAppendingString: @"\n"];
        }
    }
    return str;
}

- (cardState) getCardStateAtIndex:(NSInteger) index{
    return cardStates[index];
}

@end
