//
//  HistoryManager.h
//  GuessNum
//
//  Created by DoubleZ on 13-8-28.
//  Copyright (c) 2013年 DoubleZ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GameHistory.h"
//struct  History{
//    NSInteger guessNum;
//    NSInteger countGuess;
//} ;
@interface HistoryManager : NSObject


@property (nonatomic, retain) NSMutableArray* historyMArray;

+ (HistoryManager*) getSingletonPtr;
/*
//通过NSData
//读取文件历史记录
- (bool) readHistoryFromFile;
//写入文件历史记录
- (bool) writeHistoryToFile;
//记录胜利情况，最多只能有10个记录
- (void) updateWinHistoryArray:(struct History*) currentHistory;
*/


//by NSKeyedArchiver and NSKeyedUnarchiver.
- (bool) readHistoryFromFile;
- (bool) writeHistoryToFile;
- (void) updateWinHistoryArray:(GameHistory*) currentHistory;
@end
