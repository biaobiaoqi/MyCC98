//
//  SettingsTableViewController.h
//  MyCC98
//
//  Created by Yan Chen on 1/27/13.
//  Copyright (c) 2013 YANN. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingsTableViewController : UITableViewController
{
    NSString *rvpnCode;
    BOOL isRVPN;
}

- (void) switchRVPN:(id)sender;

@end
