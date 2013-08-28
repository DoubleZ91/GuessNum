//
//  ViewController.h
//  GuessNum
//
//  Created by DoubleZ on 13-8-26.
//  Copyright (c) 2013年 DoubleZ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import"GameLogic.h"
#import"GameHistory.h"
#import "HistoryManager.h"
@interface ViewController : UIViewController
{

    NSInteger viewOffset;   //视图偏移量
    
    bool bViewOffset;   //是否需要向上偏移，用于当键盘挡住文本框
    
    GameLogic *gameLogic;
    HistoryManager *historyMgr;
}

@property(nonatomic, retain) IBOutlet UITextField* inputGuessNumTF;
@property(nonatomic, retain) IBOutlet UITextField* inputBeGuessNumTF;
@property(nonatomic, retain) IBOutlet UILabel* showBullCowLabel;
@property(nonatomic, retain) IBOutlet UILabel* showPCBullCowLabel;

- (void) keyboardWillShow: (NSNotification *)notification  ;
- (void) keyboardWillHide: (NSNotification *)notification  ;
- (void) applicationWillEnterBackground: (NSNotification*) notification;
//界面相应
- (IBAction) pressBeGuessBtnOK: (id)sender;
- (IBAction) pressGuessBtnOK: (id)sender;
- (IBAction) didEndOnExit :(id)sender;
- (IBAction) backgroundBtnDown:(id)sender;
- (IBAction) editingDidBegin:(id)sender;
@end
