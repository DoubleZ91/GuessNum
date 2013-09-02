//
//  GameHistory.h
//  GuessNum
//
//  Created by DoubleZ on 13-8-28.
//  Copyright (c) 2013年 DoubleZ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GameHistory : NSObject<NSCoding>

@property (nonatomic, assign) NSInteger guessNum;
@property (nonatomic, assign) NSInteger countGuess;

@end
