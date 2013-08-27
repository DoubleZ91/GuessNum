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

@synthesize inputBeGuessNumTF;
@synthesize inputGuessNumTF;
@synthesize showBullCowLabel;
@synthesize showPCBullCowLabel;
@synthesize showPCGuessNumTF;
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    countGuess = 0;
    viewOffset = 0;
    bViewOffset = NO;
    

    [self readHistoryFromFile];
    //生成供给玩家猜测的数字
    guessNum = [self generateFourDigit];
    NSLog(@"PC input guess number:%d",guessNum);
    showBullCowLabel.numberOfLines = 0;
    showBullCowLabel.text = [NSString stringWithFormat: @" Bulls : %d \n Cows : %d \n GuessCount : %d \n",  0,0,0];
    showPCBullCowLabel.numberOfLines = 0;
    showPCBullCowLabel.text = [NSString stringWithFormat: @" Bulls : %d \n Cows : %d \n GuessCount : %d \n",  0,0,0];
    //增加键盘显隐监听
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    //进入后台程序通知--数据保存
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillEnterBackground:) name:UIApplicationDidEnterBackgroundNotification object:nil];
}
//- (void)viewDidAppear:(BOOL)animated
//{
//    [super viewDidAppear:animated];
//    CGRect rect =self.view.frame;
//    rect.origin.y += viewOffset;
//    [self.view setFrame:rect];
//    rect = self.view.frame;
//    NSLog(@"%f %f %f %f",rect.origin.x,rect.origin.y,rect.size.height,rect.size.width );
//}
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
//程序进入后台
- (void) applicationWillEnterBackground:(NSNotification *)notification
{
    [self writeHistoryToFile];
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
        viewOffset = 0;
    }

}
//界面相应
- (IBAction) pressBeGuessBtnOK:(id)sender
{
    [inputBeGuessNumTF resignFirstResponder];
    beGuessNum = [inputBeGuessNumTF.text integerValue];
    if ([self checkIsFourDigits:beGuessNum] && [self checkDiffDigits:beGuessNum]) {
        NSLog(@"BeGuessNum:%d",beGuessNum);
    }
    else{
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"Failed" message:@"reset four digits!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil , nil ];
        [alertView show];
    }
    
}
- (IBAction) pressGuessBtnOK:(id)sender
{
    [inputGuessNumTF resignFirstResponder];
    playGuessNum = [inputGuessNumTF.text integerValue];
    if ([self checkIsFourDigits:playGuessNum] && [self checkDiffDigits:playGuessNum]) {
        //计数加一
        ++countGuess;
        
        NSInteger bulls = 0;
        NSInteger cows = 0;
        
        //pc猜数
        NSInteger guessNumPC = [self gatherTheNum];
        showPCGuessNumTF.text = [NSString stringWithFormat:@"%d",guessNumPC];
        [self bullsAndCows:beGuessNum desInteger:guessNumPC numOfBulls:&bulls numOfCows:&cows];
        NSLog(@"PC bulls %d and cows %d ",bulls,cows);
        //更新bulls和cows显示
        showPCBullCowLabel.text = [NSString stringWithFormat: @" Bulls : %d \n Cows : %d \n GuessCount : %d \n",  bulls,cows,countGuess];
        if (bulls == 4) {
            winer = 1;
        }
        
        //玩家猜数
        bulls = 0;
        cows = 0;
        NSLog(@"GuessNum:%d",playGuessNum);
        [self bullsAndCows:guessNum desInteger:playGuessNum numOfBulls:&bulls numOfCows:&cows];
        NSLog(@"Player bulls %d and cows %d ",bulls,cows);
        //更新bulls和cows显示
        showBullCowLabel.text = [NSString stringWithFormat: @" Bulls : %d \n Cows : %d \n GuessCount : %d \n",  bulls,cows,countGuess];
        if (bulls == 4) {
            if (winer == 1) {
                winer = 3;
            }
            else
                winer = 2;
        }
        if (winer != 0){
            NSString *winerStr;
            switch(winer)
            {
                case 1: winerStr = [NSString stringWithFormat:@"%@",@"PC  win." ];break;
                case 2:
                    {
                        winerStr = [NSString stringWithFormat:@"%@",@"player win"];
                        //记录下来胜利历史
                        struct History tmpHistory;
                        tmpHistory.guessNum = guessNum;
                        tmpHistory.countGuess = countGuess;
                        [self updateWinHistoryArray:&tmpHistory];
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
    [inputBeGuessNumTF resignFirstResponder];
    [inputGuessNumTF resignFirstResponder];
}
- (IBAction)didEndOnExit:(id)sender
{
    [sender resignFirstResponder];
    beGuessNum = [inputBeGuessNumTF.text integerValue];
    NSLog(@"BeGuessNum:%d",beGuessNum);
    if ([self checkIsFourDigits:guessNum] && [self checkDiffDigits:guessNum]) {
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
    inputBeGuessNumTF.text = nil;
    inputGuessNumTF.text = nil;
    showPCGuessNumTF.text = nil;
    showBullCowLabel.text = [NSString stringWithFormat: @" Bulls : %d \n Cows : %d \n GuessCount : %d \n",  0,0,0];
    showPCBullCowLabel.text = [NSString stringWithFormat: @" Bulls : %d \n Cows : %d \n GuessCount : %d \n",  0,0,0];
    winer = 0;
    //生成供给玩家猜测的数字
    guessNum = [self generateFourDigit];
    NSLog(@"PC input guess number:%d",guessNum);
    
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
            [historyMArray addObject:[ NSValue value:&tmpHistory withObjCType:@encode(struct History)]];
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
@end
