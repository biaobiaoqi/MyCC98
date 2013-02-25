//
//  PostListTableViewController.h
//  MyCC98
//
//  Created by Yan Chen on 1/28/13.
//  Copyright (c) 2013 YANN. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "CCTopicEntity.h"

@interface PostListTableViewController : UITableViewController <UIWebViewDelegate, UIActionSheetDelegate>

//@property (nonatomic, strong) CCTopicEntity *topicInfo;
@property (nonatomic, strong) NSString *topicId;
@property (nonatomic, strong) NSString *boardId;
@property (nonatomic, strong) NSString *topicName;
@property (nonatomic, strong) NSMutableArray *items;
@property (nonatomic) NSInteger currPageNum;
@property (nonatomic) NSInteger totalPageNum;

@end
