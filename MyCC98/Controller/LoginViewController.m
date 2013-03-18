//
//  LoginViewController.m
//  MyCC98
//
//  Created by Yan Chen on 1/26/13.
//  Copyright (c) 2013 YANN. All rights reserved.
//

#import "LoginViewController.h"
#import "NSString+CCStringUtil.h"
#import "CC98API.h"
#import "CC98Parser.h"
#import "MBProgressHUD.h"
#import "GAI.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [[[GAI sharedInstance] defaultTracker] sendView:@"Login Screen"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)cancelButtonClicked:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)login:(id)sender
{
    NSString* uid = [username text];
    NSString* pw = [password text];
    NSString* pw32 = [pw md5_32];
    NSString* pw16 = [pw md5_16];
    //NSLog(@"pw16: %@", pw16);
    NSDictionary* loginData;
    loginData = [NSDictionary dictionaryWithObjectsAndKeys:
                 @"i", @"a",
                 uid, @"u",
                 pw32, @"p",
                 @"2", @"userhidden",
                 nil];
    NSLog(@"%@",loginData);
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"正在登陆...";
    
    [[CC98API sharedInstance] loginWithData:loginData success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //NSLog(@"returned");
        NSString *webcontent = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSLog(@"%@", webcontent);
        if ([webcontent rangeOfString:@"1003"].location != NSNotFound) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"用户名密码错误"  message:nil
                                                           delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        } else if ([webcontent rangeOfString:@"1001"].location != NSNotFound) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"用户名不存在"  message:nil
                                                           delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        } else {
            NSLog(@"Login Success");
            [[NSUserDefaults standardUserDefaults] setObject:[loginData objectForKey:@"u"] forKey:@"username"];
            [[NSUserDefaults standardUserDefaults] setObject:[loginData objectForKey:@"p"] forKey:@"pw32"];
            [[NSUserDefaults standardUserDefaults] setObject:pw16 forKey:@"pw16"];
            //[self performSegueWithIdentifier:@"login" sender:self];
            [[CC98API sharedInstance] getAvatarUrlWithUserName:uid success:^(AFHTTPRequestOperation *operation, id responseObject) {
                NSString *avatarurl = [[CC98Parser sharedInstance] parseUserAvatarUrl:responseObject];
                [[NSUserDefaults standardUserDefaults] setObject:avatarurl forKey:@"avatarurl"];
                //NSLog(@"user avatar %@", avatarurl);
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                [self dismissViewControllerAnimated:YES completion:nil];
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                NSLog(@"error: %@", error);
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                [self dismissViewControllerAnimated:YES completion:nil];
            }];
            
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@", error);
        if (error.code == -1001) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"连接超时"  message:nil
                                                           delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
        }
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}

#pragma TextField delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    // Any additional checks to ensure you have the correct textField here.
    [textField resignFirstResponder];
    return YES;
}

@end
