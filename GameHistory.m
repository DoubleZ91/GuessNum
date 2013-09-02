//
//  GameHistory.m
//  GuessNum
//
//  Created by DoubleZ on 13-8-28.
//  Copyright (c) 2013年 DoubleZ. All rights reserved.
//

#import "GameHistory.h"

@implementation GameHistory

- (id) initWithCoder:(NSCoder*)coder
{
    _guessNum = [coder decodeIntegerForKey:@"guessNum"];
    _countGuess = [coder decodeIntegerForKey:@"countGuess"];
    return self;
}
- (void) encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeInteger:_guessNum forKey:@"guessNum"];
    [aCoder encodeInteger:_countGuess forKey:@"countGuess"];
}
- (NSString*) description
{
    return [NSString stringWithFormat:@"GuessNum : %d , CountGuess : %d ", _guessNum, _countGuess];
}
@end
