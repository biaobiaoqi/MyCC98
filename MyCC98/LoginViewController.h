//
//  LoginViewController.h
//  MyCC98
//
//  Created by Yan Chen on 1/17/13.
//  Copyright (c) 2013 Zhejiang University. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginViewController : UIViewController <UITextFieldDelegate>
{
    IBOutlet UITextField *username;
    IBOutlet UITextField *password;
}

-(IBAction)login:(id)sender;
-(void)loginAction:(NSDictionary*)loginData;

@end
