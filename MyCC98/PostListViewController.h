//
//  PostListViewController.h
//  MyCC98
//
//  Created by Yan Chen on 1/22/13.
//  Copyright (c) 2013 Zhejiang University. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGORefreshTableHeaderView.h"
#import "TopicEntity.h"

@interface PostListViewController : UIViewController <EGORefreshTableHeaderDelegate, UITableViewDataSource, UITableViewDelegate>
{
    EGORefreshTableHeaderView *_refreshHeaderView;
	BOOL _reloading;
    NSInteger currPageNum;
    NSInteger totalPageNum;
    TopicEntity *topicInfo;
}

@property (nonatomic, strong) TopicEntity *topicInfo;
@property (nonatomic, strong) NSMutableArray *items;
@property (nonatomic, retain) IBOutlet UITableView *tableView;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *nextPage2;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *prevPage2;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *pageLabel2;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *pageLabel1;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *nextPage1;
@property (nonatomic, retain) IBOutlet UIToolbar *toolbar1;
@property (nonatomic, retain) IBOutlet UIToolbar *toolbar2;

- (void)loadTableViewDataSource;
- (void)reloadTableViewDataSource;
- (void)doneLoadingTableViewData;

-(void)prevPageButtonPressed;
-(void)nextPageButtonPressed;

@end
