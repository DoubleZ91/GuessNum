//
//  GameLogic.h
//  GuessNum
//
//  Created by DoubleZ on 13-8-28.
//  Copyright (c) 2013年 DoubleZ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GameLogic : NSObject
//{
//    NSInteger guessNum;     //电脑生成让玩家猜测的数字
//    NSInteger guessNumPC;   //电脑猜测数字
//    NSInteger beGuessNum;   //玩家输入让电脑猜测的数字
//    NSInteger playGuessNum; //玩家所猜测数字
//    NSInteger countGuess;   //当前局猜测数字的次数
//    NSInteger winer;        //用于标记胜利者，1电脑，2玩家，3同时
//    
//    NSInteger pcBulls, pcCows;
//    NSInteger playerBulls, playerCows;
//}

@property (nonatomic ,assign) NSInteger guessNum;
@property (nonatomic, assign) NSInteger guessNumPC;
@property (nonatomic, assign) NSInteger beGuessNum;
@property (nonatomic, assign) NSInteger playGuessNum;
@property (nonatomic, assign) NSInteger countGuess , winer;

@property (nonatomic, assign) NSInteger pcBulls, pcCows;
@property (nonatomic, assign) NSInteger playerBulls, playerCows;
//程序运行
//- (GameLogic*) init;
- (NSInteger)generateFourDigit;
- (void) splitFourDigits: (NSInteger)fourDigit desArray: (NSInteger*)digits;
- (bool) checkDiffDigits: (NSInteger)fourDigit ;
- (bool) checkIsFourDigits: (NSInteger)num;

- (void) bullsAndCows : (NSInteger)firstNum desInteger:(NSInteger) secondNum numOfBulls:(NSInteger*) bulls
             numOfCows:(NSInteger*) cows;
//pc猜数
- (NSInteger) gatherTheNum;
//游戏执行
- (void)gameRun;
- (void)gameRestart;
- (void)gameInit;
@end
