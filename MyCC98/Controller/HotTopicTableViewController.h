//
//  HotTopicTableViewController.h
//  MyCC98
//
//  Created by Yan Chen on 2/25/13.
//  Copyright (c) 2013 YANN. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HotTopicTableViewController : UITableViewController

@property (nonatomic, strong) NSMutableArray *items;

- (IBAction)revealMenu:(id)sender;

@end
