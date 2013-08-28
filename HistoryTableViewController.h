//
//  HistoryTableViewController.h
//  GuessNum
//
//  Created by DoubleZ on 13-8-28.
//  Copyright (c) 2013年 DoubleZ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HistoryManager.h"
#import "GameHistory.h"
@interface HistoryTableViewController : UITableViewController

@property (nonatomic, retain) HistoryManager *historyMgr;

@end
