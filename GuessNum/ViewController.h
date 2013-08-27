//
//  ViewController.h
//  GuessNum
//
//  Created by DoubleZ on 13-8-26.
//  Copyright (c) 2013年 DoubleZ. All rights reserved.
//

#import <UIKit/UIKit.h>
struct  History{
    NSInteger guessNum;
    NSInteger countGuess;
} ;
@interface ViewController : UIViewController
{
    NSInteger guessNum;     //电脑生成让玩家猜测的数字
    NSInteger beGuessNum;   //玩家输入让电脑猜测的数字
    NSInteger playGuessNum; //玩家所猜测数字
    NSInteger countGuess;   //当前局猜测数字的次数
    NSInteger winer;        //用于标记胜利者，1电脑，2玩家，3同时
    NSInteger viewOffset;   //视图偏移量
    
    bool bViewOffset;   //是否需要向上偏移，用于当键盘挡住文本框
    
    NSMutableArray *historyMArray; // 存储最近的记录
}

@property(nonatomic, retain) IBOutlet UITextField* inputGuessNumTF;
@property(nonatomic, retain) IBOutlet UITextField* inputBeGuessNumTF;
@property(nonatomic, retain) IBOutlet UILabel* showBullCowLabel;
@property(nonatomic, retain) IBOutlet UILabel* showPCBullCowLabel;
@property(nonatomic, retain) IBOutlet UITextField* showPCGuessNumTF;

- (void) keyboardWillShow: (NSNotification *)notification  ;
- (void) keyboardWillHide: (NSNotification *)notification  ;
- (void) applicationWillEnterBackground: (NSNotification*) notification;
//界面相应
- (IBAction) pressBeGuessBtnOK: (id)sender;
- (IBAction) pressGuessBtnOK: (id)sender;
- (IBAction) didEndOnExit :(id)sender;
- (IBAction) backgroundBtnDown:(id)sender;
- (IBAction) editingDidBegin:(id)sender;
//程序运行
- (void)restart;
- (NSInteger)generateFourDigit;
- (void) splitFourDigits: (NSInteger)fourDigit desArray: (NSInteger*)digits;
- (bool) checkDiffDigits: (NSInteger)fourDigit ;
- (bool) checkIsFourDigits: (NSInteger)num;

- (void) bullsAndCows : (NSInteger)firstNum desInteger:(NSInteger) secondNum numOfBulls:(NSInteger*) bulls
numOfCows:(NSInteger*) cows;
//pc猜数
- (NSInteger) gatherTheNum;

//读取文件历史记录
- (bool) readHistoryFromFile;
//写入文件历史记录
- (bool) writeHistoryToFile;
//记录胜利情况，最多只能有10个记录
- (void) updateWinHistoryArray:(struct History*) currentHistory;
@end
