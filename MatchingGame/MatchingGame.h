//
//  MatchingGame.h
//  MatchingGame
//
//  Created by CSSE Department on 4/30/20.
//  Copyright © 2020 CSSE Department. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, cardState){
    CardStateHidden,
    CardStateShowing,
    CardStateRemoved
};

typedef NS_ENUM(NSInteger, gameStates){
    GameStateFirstTurn,
    GameStateSecondTurn,
    GameStateTurnComplete,
    GameStateGameWon
};

@interface MatchingGame : NSObject{
    cardState cardStates[100];
}

@property (nonatomic, strong) NSArray* cards;
@property (nonatomic, strong) NSString* cardBack;
@property (nonatomic) NSInteger firstCard;
@property (nonatomic) NSInteger secondCard;
@property (nonatomic) gameStates gameState;
@property (nonatomic) NSInteger numPairs;

- (bool) pressedCardAtIndex: (NSInteger) index;
- (bool) startNewTurn;
- (bool) checkWin;
- (cardState) getCardStateAtIndex: (NSInteger) index;
@end

NS_ASSUME_NONNULL_END
