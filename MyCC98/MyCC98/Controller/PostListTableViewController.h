//
//  PostListTableViewController.h
//  MyCC98
//
//  Created by Yan Chen on 1/28/13.
//  Copyright (c) 2013 YANN. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CCTopicEntity.h"

@interface PostListTableViewController : UITableViewController <UIWebViewDelegate>

@property (nonatomic, strong) CCTopicEntity *topicInfo;
@property (nonatomic, strong) NSMutableArray *items;
@property (nonatomic) NSInteger currPageNum;

@end
