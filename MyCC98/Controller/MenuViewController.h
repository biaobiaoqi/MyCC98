//
//  MenuViewController.h
//  MyCC98
//
//  Created by Yan Chen on 1/26/13.
//  Copyright (c) 2013 YANN. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MenuViewController : UIViewController
{
    UINavigationController *boardList;
    UINavigationController *settings;
    IBOutlet UIImageView *avatarImage;
    IBOutlet UITableView *menuTable;
    IBOutlet UIButton *profile;
}

@property (nonatomic, strong) NSArray *sectionItems1;
@property (nonatomic, strong) NSArray *sectionItems2;
@property (nonatomic, strong) NSArray *sections;

- (IBAction)profileButtonClicked:(id)sender;

@end
