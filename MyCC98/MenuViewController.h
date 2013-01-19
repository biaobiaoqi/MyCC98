//
//  MenuViewController.h
//  MyCC98
//
//  Created by Yan Chen on 1/18/13.
//  Copyright (c) 2013 Zhejiang University. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ECSlidingViewController.h"
#import "CustomBoardNavigationController.h"

@interface MenuViewController : UIViewController <UITableViewDataSource, UITabBarControllerDelegate>
{
    UINavigationController *customBoard;
    UINavigationController *hotTopic;
    IBOutlet UIImageView *avatarImage;
    IBOutlet UITableView *menuTable;
    IBOutlet UIButton *profile;
}

-(IBAction)logout:(id)sender;

@property (nonatomic, strong) NSArray *menuItems;


@end
