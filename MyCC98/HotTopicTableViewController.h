//
//  HotTopicTableViewController.h
//  MyCC98
//
//  Created by Yan Chen on 1/18/13.
//  Copyright (c) 2013 Zhejiang University. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ECSlidingViewController.h"
#import "EGORefreshTableHeaderView.h"

@interface HotTopicTableViewController : UITableViewController <EGORefreshTableHeaderDelegate>
{
    EGORefreshTableHeaderView *_refreshHeaderView;
	
	//  Reloading var should really be your tableviews datasource
	//  Putting it here for demo purposes
	BOOL _reloading;
}
@property (nonatomic, strong) NSMutableArray *items;

- (IBAction)revealMenu:(id)sender;
- (void)reloadTableViewDataSource;
- (void)doneLoadingTableViewData;

@end
