//
//  ViewController.m
//  GuessNum
//
//  Created by DoubleZ on 13-8-26.
//  Copyright (c) 2013年 DoubleZ. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    viewOffset = 0;
    bViewOffset = NO;
    
    gameLogic = [[GameLogic alloc] init];
    historyMgr = [HistoryManager getSingletonPtr];
    [historyMgr readHistoryFromFile]; 
    [gameLogic gameInit];
    
    [self.view setBackgroundColor:[UIColor colorWithRed:234 / 255.f green:234 / 255.f blue:234 / 255.f alpha:1.f]];
    _showPCBullCowLabel.numberOfLines = 0;
    _showPCBullCowLabel.text = [NSString stringWithFormat: @"PC猜测数字:%d \n Bulls : %d \n Cows : %d \n GuessCount : %d \n", 0,0,0,0];
    _showBullCowLabel.numberOfLines = 0;
    _showBullCowLabel.text = [NSString stringWithFormat: @" Bulls : %d \n Cows : %d \n GuessCount : %d \n",  0,0,0];
    //增加键盘显隐监听
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    //进入后台程序通知--数据保存
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillEnterBackground:) name:UIApplicationDidEnterBackgroundNotification object:nil];
    
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.

}

//键盘显隐相关
- (void) keyboardWillShow:(NSNotification *)notification  	
{
    if(bViewOffset)
    {
        CGRect keyboardFrames = [[[notification userInfo] valueForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
        viewOffset = - keyboardFrames.size.height;
        CGRect rect =self.view.frame;
        rect.origin.y += viewOffset;
        
        CGContextRef context =  UIGraphicsGetCurrentContext();
        [UIView beginAnimations:nil context:context];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
        [UIView setAnimationDuration:0.25];
    
        [self.view setFrame:rect];
        
        [UIView commitAnimations];
        rect = self.view.frame;
        NSLog(@"%f %f %f %f",rect.origin.x,rect.origin.y,rect.size.height,rect.size.width );

    }
}

- (void) keyboardWillHide:(NSNotification *)notification  
{
    if(bViewOffset)
    {
        viewOffset = -viewOffset;
        CGRect rect =self.view.frame;
        rect.origin.y += viewOffset;
        [self.view setFrame:rect];
        rect = self.view.frame;
        NSLog(@"%f %f %f %f",rect.origin.x,rect.origin.y,rect.size.height,rect.size.width );
        viewOffset = NO;
    }

}
//程序进入后台
- (void) applicationWillEnterBackground:(NSNotification *)notification
{
    [historyMgr writeHistoryToFile];
}
//界面相应
- (IBAction) pressBeGuessBtnOK:(id)sender
{
    [_inputBeGuessNumTF resignFirstResponder];
    gameLogic.beGuessNum = [_inputBeGuessNumTF.text integerValue];
    if ([gameLogic checkIsFourDigits:gameLogic.beGuessNum] && [gameLogic checkDiffDigits:gameLogic.beGuessNum]) {
        NSLog(@"BeGuessNum:%d",gameLogic.beGuessNum);
    }
    else{
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"Failed" message:@"reset four digits!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil , nil ];
        [alertView show];
    }
    
}
- (IBAction) pressGuessBtnOK:(id)sender
{
    [_inputGuessNumTF resignFirstResponder];
    gameLogic.playGuessNum = [_inputGuessNumTF.text integerValue];
    if ([gameLogic checkIsFourDigits:gameLogic.playGuessNum] && [gameLogic checkDiffDigits:gameLogic.playGuessNum]) {

        [gameLogic gameRun];
        //更新bulls和cows显示
        _showPCBullCowLabel.text = [NSString stringWithFormat: @"PC猜测数字:%d \n Bulls : %d \n Cows : %d \n GuessCount : %d \n", gameLogic.guessNumPC, gameLogic.pcBulls,gameLogic.pcCows,gameLogic.countGuess];
        //更新bulls和cows显示
        _showBullCowLabel.text = [NSString stringWithFormat: @" Bulls : %d \n Cows : %d \n GuessCount : %d \n",  gameLogic.playerBulls,gameLogic.playerCows,gameLogic.countGuess];
        
        if (gameLogic.winer != 0){
            NSString *winerStr;
            switch(gameLogic.winer)
            {
                case 1: winerStr = [NSString stringWithFormat:@"%@",@"PC  win." ];break;
                case 2:
                    {
                        winerStr = [NSString stringWithFormat:@"%@",@"player win"];
                        //记录下来胜利历史
                        /*
                        //第一种存储
                         struct History tmpHistory;
                        tmpHistory._guessNum = gameLogic._guessNum;
                        tmpHistory._countGuess = gameLogic._countGuess;
                        [historyMgr updateWinHistoryArray:&tmpHistory];
                        */
                        //第二种存储 by NSKeyedArchiver
                        GameHistory *currentHistory = [GameHistory alloc];
                        currentHistory.guessNum = gameLogic.guessNum;
                        currentHistory.countGuess = gameLogic.countGuess;
                        [historyMgr updateWinHistoryArray:currentHistory];
                         break;
                    }
                case 3: winerStr = [NSString stringWithFormat:@"%@",@"PC and Player both win."];break;
            }
            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"Win!!!" message:winerStr delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil , nil];
            [alertView show];
            
            //胜利之后，重新开始游戏，重置数据
            [self restart];
        }
    }
    else{
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"Failed" message:@"reset four digits!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil , nil ];
        [alertView show];
    }
    bViewOffset = NO;
}
- (IBAction)backgroundBtnDown:(id)sender
{
    [_inputBeGuessNumTF resignFirstResponder];
    [_inputGuessNumTF resignFirstResponder];
}
- (IBAction)didEndOnExit:(id)sender
{
    [sender resignFirstResponder];
    gameLogic.beGuessNum = [_inputBeGuessNumTF.text integerValue];
    NSLog(@"BeGuessNum:%d",gameLogic.beGuessNum);
    if ([gameLogic checkIsFourDigits:gameLogic.beGuessNum] && [gameLogic checkDiffDigits:gameLogic.beGuessNum]) {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"Success" message:@"Right four digits!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil , nil ];
        [alertView show];
    }
    else{
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"Failed" message:@"reset four digits!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil , nil ];
        [alertView show];
    }
    bViewOffset = NO;
}
- (IBAction) editingDidBegin:(id)sender
{
    bViewOffset = YES;
}


//---restart
- (void) restart
{
    _inputBeGuessNumTF.text = nil;
    _inputGuessNumTF.text = nil;
    _showBullCowLabel.text = [NSString stringWithFormat: @" Bulls : %d \n Cows : %d \n GuessCount : %d \n",0,0,0];
    _showPCBullCowLabel.text = [NSString stringWithFormat: @"PC猜测数字:%d \n Bulls : %d \n Cows : %d \n GuessCount : %d \n",0,0,0,0];
    
    //游戏数据重置
    [gameLogic gameRestart];
}

@end
