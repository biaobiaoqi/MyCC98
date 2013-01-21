//
//  PostListTableViewController.h
//  MyCC98
//
//  Created by Yan Chen on 1/19/13.
//  Copyright (c) 2013 Zhejiang University. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BoardEntity.h"
#import "EGORefreshTableHeaderView.h"

@interface PostListTableViewController : UITableViewController <EGORefreshTableHeaderDelegate>
{
    BoardEntity *boardInfo;
    EGORefreshTableHeaderView *_refreshHeaderView;
	BOOL _reloading;
    NSInteger pageNum;
}

@property (nonatomic, strong) BoardEntity *boardInfo;
@property (nonatomic, strong) NSMutableArray *items;

- (void)reloadTableViewDataSource;
- (void)doneLoadingTableViewData;

@end
