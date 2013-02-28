//
//  TopicListTableViewController.h
//  MyCC98
//
//  Created by Yan Chen on 1/27/13.
//  Copyright (c) 2013 YANN. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CCBoardEntity.h"

@interface TopicListTableViewController : UITableViewController

@property (nonatomic, strong) CCBoardEntity *boardInfo;
@property (nonatomic, strong) NSMutableArray *items;
@property (nonatomic) NSInteger currPageNum;
@property (nonatomic) NSInteger totalPageNum;

- (IBAction)newpostButtonClicked:(id)sender;

@end
