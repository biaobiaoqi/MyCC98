//
//  PostListTableViewController.h
//  MyCC98
//
//  Created by Yan Chen on 1/28/13.
//  Copyright (c) 2013 YANN. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "CCTopicEntity.h"

@interface PostListViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UIWebViewDelegate, UIActionSheetDelegate>

//@property (nonatomic, strong) CCTopicEntity *topicInfo;
@property (nonatomic, retain) IBOutlet UITableView *tableView;
@property (nonatomic, retain) IBOutlet UIButton *refreshButton;
@property (nonatomic, strong) NSString *topicId;
@property (nonatomic, strong) NSString *boardId;
@property (nonatomic, strong) NSString *topicName;
@property (nonatomic, strong) NSMutableArray *items;
@property (nonatomic) NSInteger currPageNum;
@property (nonatomic) NSInteger totalPageNum;
@property (nonatomic) NSInteger lastUpdateNum;

- (IBAction)refreshButtonClicked:(id)sender;

@end
