//
//  TopicListViewController.h
//  MyCC98
//
//  Created by Yan Chen on 1/22/13.
//  Copyright (c) 2013 Zhejiang University. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BoardEntity.h"
#import "EGORefreshTableHeaderView.h"

@interface TopicListViewController : UIViewController <EGORefreshTableHeaderDelegate, UITableViewDataSource, UITableViewDelegate>
{
    BoardEntity *boardInfo;
    EGORefreshTableHeaderView *_refreshHeaderView;
	BOOL _reloading;
    NSInteger currPageNum;
    NSInteger totalPageNum;
}

@property (nonatomic, strong) BoardEntity *boardInfo;
@property (nonatomic, strong) NSMutableArray *items;
@property (nonatomic, retain) IBOutlet UITableView *tableView;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *nextPage2;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *prevPage2;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *pageLabel2;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *pageLabel1;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *nextPage1;
@property (nonatomic, retain) IBOutlet UIToolbar *toolbar1;
@property (nonatomic, retain) IBOutlet UIToolbar *toolbar2;

- (void)reloadTableViewDataSource;
- (void)doneLoadingTableViewData;

-(void)prevPageButtonPressed;
-(void)nextPageButtonPressed;

@end
