//
//  GameHistory.m
//  GuessNum
//
//  Created by DoubleZ on 13-8-28.
//  Copyright (c) 2013年 DoubleZ. All rights reserved.
//

#import "GameHistory.h"

@implementation GameHistory
@synthesize guessNum;
@synthesize countGuess;

- (id) initWithCoder:(NSCoder*)coder
{
    guessNum = [coder decodeIntegerForKey:@"guessNum"];
    countGuess = [coder decodeIntegerForKey:@"countGuess"];
    return self;
}
- (void) encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeInteger:guessNum forKey:@"guessNum"];
    [aCoder encodeInteger:countGuess forKey:@"countGuess"];
}
- (NSString*) description
{
    return [NSString stringWithFormat:@"GuessNum : %d , CountGuess : %d ", guessNum, countGuess];
}
@end
