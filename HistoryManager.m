//
//  HistoryManager.m
//  GuessNum
//
//  Created by DoubleZ on 13-8-28.
//  Copyright (c) 2013年 DoubleZ. All rights reserved.
//

#import "HistoryManager.h"

static HistoryManager *historyMgr;
NSInteger sortByGuessCount(id obj1 , id obj2, void *context)
{
    GameHistory *historyObj1 = (GameHistory*) obj1;
    GameHistory *historyObj2 = (GameHistory*) obj2;
    if (historyObj1.countGuess < historyObj2.countGuess) {
        return NSOrderedAscending;
    }
    else if (historyObj1.countGuess == historyObj2.countGuess)
    {
        return NSOrderedSame;
    }
    else
        return NSOrderedDescending;
}

@implementation HistoryManager

@synthesize historyMArray;

+ (HistoryManager *) getSingletonPtr
{
    if (historyMgr == nil) {
        historyMgr = [HistoryManager alloc];
    }
    return historyMgr;
}
//第一中方法 by NSData
/*
//读取文件历史记录
- (bool) readHistoryFromFile
{
    NSArray *docPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docPath = [docPaths objectAtIndex:0];
    NSFileManager *fileManager = [NSFileManager  defaultManager];
    NSArray *fileArray = [fileManager subpathsAtPath:docPath];
    
    NSString *fileName = @"history.txt";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@" SELF = %@",fileName];
    NSArray *resultArray = [fileArray filteredArrayUsingPredicate:predicate];
    if (resultArray.count == 0) {
        NSLog(@"文件不存在\n");
        historyMArray = [[NSMutableArray alloc] initWithCapacity:10];
    }
    else{
        NSLog(@"文件存在\n");
        NSString *filePath = [docPath stringByAppendingPathComponent:fileName];
        historyMArray = [[NSMutableArray alloc] initWithCapacity:10];
        
        NSData *reader = [NSData dataWithContentsOfFile:filePath];
        NSInteger count;
        [reader getBytes:&count length:sizeof(NSInteger)];
        for (int i = 0; i < count; ++i) {
            struct History tmpHistory;
            [reader getBytes:&tmpHistory range:NSMakeRange(sizeof(NSInteger) + i*sizeof(struct History),sizeof(struct History))];
            [historyMArray insertObject:[ NSValue value:&tmpHistory withObjCType:@encode(struct History)]  atIndex:0] ;
            NSLog(@"%d : %d ,%d",i,tmpHistory.guessNum,tmpHistory.countGuess);
        }
        
    }
    return YES;
}
//写入文件历史记录
- (bool) writeHistoryToFile
{
    NSArray *docPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docPath = [docPaths objectAtIndex:0];
    NSString *fileName = @"history.txt";
    NSString *filePath = [docPath stringByAppendingPathComponent:fileName];
    
    NSInteger i = historyMArray.count;
    //创建数据缓冲区
    NSMutableData *writer = [[NSMutableData alloc] init];
    [writer appendBytes:&i length:sizeof(NSInteger)];
    while (i > 0) {
        struct History tmpHistory;
        [[historyMArray objectAtIndex:(i-1)] getValue:&tmpHistory];
        [writer appendBytes:&tmpHistory length:sizeof(tmpHistory)];
        --i;
    }
    [writer writeToFile:filePath atomically:YES];
    return YES;
}
//更新胜利情况，最多只能有10个记录
- (void) updateWinHistoryArray:(struct History*) currentHistory
{
    if (historyMArray.count == 10) {
        NSLog(@"历史记录>10，删除并更新历史记录");
        [historyMArray removeLastObject];
        [historyMArray addObject:[NSValue value:currentHistory withObjCType:@encode(struct History)]];
    }
    else{
        NSLog(@"更新了胜利历史记录情况！");
        [historyMArray addObject:[NSValue value:currentHistory withObjCType:@encode(struct History)]];
    }
}
*/

//第二种方法 by NSKeyedArchiver and NSKeyedUnarchiver.
- (bool) readHistoryFromFile
{
    NSLog(@"Read History From File. \n");
    NSArray *docPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docPath = [docPaths objectAtIndex:0];
    NSFileManager *fileManager = [NSFileManager  defaultManager];
    NSArray *fileArray = [fileManager subpathsAtPath:docPath];
    
    NSString *fileName = @"historyTest.txt";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@" SELF = %@",fileName];
    NSArray *resultArray = [fileArray filteredArrayUsingPredicate:predicate];
    if (resultArray.count == 0) {
        NSLog(@"文件不存在\n");
        historyMArray = [[NSMutableArray alloc] initWithCapacity:10];
    }
    else{
        NSString *filePath = [ docPath stringByAppendingPathComponent:fileName];
        historyMArray = [NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
        [historyMArray sortedArrayUsingFunction:sortByGuessCount context:nil];
    }
    NSLog(@"%@",historyMArray);
    return YES;
}
- (bool) writeHistoryToFile
{
    NSLog(@"Write History To File");
    NSArray *docPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docPath = [docPaths objectAtIndex:0];
    NSString *fileName = @"historyTest.txt";
    NSString *filePath = [ docPath stringByAppendingPathComponent:fileName];
    [NSKeyedArchiver archiveRootObject:historyMArray toFile:filePath];
    NSLog(@"%@",historyMArray);
    return YES;
}
- (void) updateWinHistoryArray:(GameHistory*) currentHistory
{
    if (historyMArray.count == 10) {
        [historyMArray removeLastObject];
    }
    [historyMArray addObject:currentHistory];
    historyMArray =[[NSMutableArray alloc ]initWithArray: [historyMArray sortedArrayUsingFunction:sortByGuessCount context:nil]];
}


@end
