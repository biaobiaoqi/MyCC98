//
//  LoginViewController.h
//  MyCC98
//
//  Created by Yan Chen on 1/26/13.
//  Copyright (c) 2013 YANN. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginViewController : UIViewController
{
    IBOutlet UITextField *username;
    IBOutlet UITextField *password;
}

- (IBAction)login:(id)sender;
- (IBAction)cancelButtonClicked:(id)sender;

@end
