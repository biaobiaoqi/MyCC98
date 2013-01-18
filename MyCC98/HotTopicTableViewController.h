//
//  HotTopicTableViewController.h
//  MyCC98
//
//  Created by Yan Chen on 1/18/13.
//  Copyright (c) 2013 Zhejiang University. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ECSlidingViewController.h"

@interface HotTopicTableViewController : UITableViewController

@property (nonatomic, strong) NSMutableArray *items;

- (IBAction)revealMenu:(id)sender;

@end
