//
//  GameLogic.m
//  GuessNum
//
//  Created by DoubleZ on 13-8-28.
//  Copyright (c) 2013年 DoubleZ. All rights reserved.
//

#import "GameLogic.h"

@implementation GameLogic

//@synthesize guessNum;
//@synthesize guessNumPC;
//@synthesize beGuessNum;
//@synthesize playGuessNum;
//@synthesize _countGuess;
//@synthesize winer;
//@synthesize pcBulls ,pcCows;
//@synthesize playerBulls,playerCows;
- (GameLogic*) init
{
    self = [super init];
    if (self) {
        self.countGuess = 0;
    }
    return self;
}
//-------分割数字成4大小数组
- (void) splitFourDigits: (NSInteger)fourDigit desArray: (NSInteger*)digits
{
    int count = 3;
    int exp = 1;
    while (count > -1) {
        digits[count] = (fourDigit/exp) %10;
        exp*=10;
        count --;
    }
}
//-------检查是否是四位不相同
- (bool) checkDiffDigits:(NSInteger)fourDigit
{
    int digits[4] = {0};
    //分割数字
    [self splitFourDigits:fourDigit desArray:digits];
    //检查四位数是否为不相同
    for (int i = 0; i < 4; i++) {
        for (int j = i+1; j < 4; j++) {
            if(digits[i] == digits[j])
                return NO;
        }
    }
    return YES;
}
//------检查是否是四位数
- (bool) checkIsFourDigits:(NSInteger)num
{
    if ( num < 1000 && num > 10000) {
        return NO;
    }
    return YES;
}
//------生成四位数
- (NSInteger) generateFourDigit
{
    srand(time(0));
    bool bSuccess = NO;
    NSInteger fourdigit;
    while(!bSuccess)
    {
        fourdigit = rand()%9000 + 1000;
        bSuccess = [self checkDiffDigits:fourdigit ];
    }
    NSLog(@"The diff four digits: %d",fourdigit);
    return fourdigit;
}
//------计算bulls和cows
- (void) bullsAndCows:(NSInteger)firstNum desInteger:(NSInteger)secondNum numOfBulls:(NSInteger*)bulls numOfCows:(NSInteger*)cows
{
    int digitNumOne[4];
    int digitNumTwo[4];
    
    [self splitFourDigits:firstNum desArray:digitNumOne];
    [self splitFourDigits:secondNum desArray:digitNumTwo];
    
    for (int i = 0; i < 4; ++i) {
        if (digitNumOne[i] == digitNumTwo[i]) {
            ++*bulls;
        }
    }
    for (int i = 0; i < 4; ++i)
        for(int j = 0; j < 4; ++j)
        {
            if(digitNumOne[i] == digitNumTwo[j])
            {
                ++*cows;
                break;
            }
        }
    *cows = *cows - *bulls;
}
//----pc猜数
- (NSInteger) gatherTheNum
{
    NSInteger gatherNum = [self generateFourDigit];
    return gatherNum;
}
//gameRun
- (void) gameRun
{
    _pcCows = _pcBulls = _playerCows = _playerBulls = 0;
    //计数加一
    ++_countGuess;

    //pc猜数
    
    _guessNumPC = [self gatherTheNum];
    
    [self bullsAndCows:_beGuessNum desInteger:_guessNumPC numOfBulls:&_pcBulls numOfCows:&_pcCows];
    NSLog(@"PC bulls %d and cows %d ",_pcBulls,_pcCows);
    
    if (_pcBulls == 4) {
        _winer = 1;
    }
    
    //玩家猜数
    NSLog(@"GuessNum:%d",_playGuessNum);
    [self bullsAndCows:_guessNum desInteger:_playGuessNum numOfBulls:&_playerBulls numOfCows:&_playerCows];
    NSLog(@"Player bulls %d and cows %d ",_playerBulls,_playerCows);
       if (_playerBulls == 4) {
        if (_winer == 1) {
            _winer = 3;
        }
        else
            _winer = 2;
    }
}
- (void)gameRestart
{
    _winer = 0;
    _countGuess = 0;
    [self gameInit];
}
- (void)gameInit
{
    //生成供给玩家猜测的数字
    _guessNum = [self generateFourDigit];
    NSLog(@"PC input guess number:%d",_guessNum);
}
@end
