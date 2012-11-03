//
//  CustomBoardTableViewController.h
//  MyCC98
//
//  Created by Yan Chen on 11/3/12.
//  Copyright (c) 2012 VINCENT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ECSlidingViewController.h"

@interface CustomBoardTableViewController : UITableViewController <UITableViewDataSource, UITabBarControllerDelegate>
- (IBAction)revealMenu:(id)sender;

@end
