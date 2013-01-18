//
//  LoginViewController.m
//  MyCC98
//
//  Created by Yan Chen on 1/17/13.
//  Copyright (c) 2013 Zhejiang University. All rights reserved.
//

#import "LoginViewController.h"
#import "CC98API.h"
#import <CommonCrypto/CommonDigest.h>

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
    //[self performSegueWithIdentifier:@"login" sender:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSString *) md5:(NSString *) input
{
    const char *cStr = [input UTF8String];
    unsigned char result[16];
    CC_MD5( cStr, strlen(cStr), result ); // This is the md5 call
    return [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0],result[1],result[2],result[3],
            result[4],result[5],result[6],result[7],
            result[8],result[9],result[10],result[11],
            result[12],result[13],result[14],result[15]];
}

-(IBAction)login:(id)sender
{
    NSString* uid = [username text];
    NSString* pw = [password text];
    NSString* pw32 = [self md5:pw];
    NSDictionary* loginData;
    loginData = [NSDictionary dictionaryWithObjectsAndKeys:
                 @"i", @"a",
                 uid, @"u",
                 pw32, @"p",
                 @"2", @"userhidden",
                 nil];
    
    [[CC98API sharedInstance] postPath:[[CC98UrlManager alloc] getLoginPath] parameters:loginData success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *webcontent = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        if ([webcontent rangeOfString:@"1003"].location != NSNotFound) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"用户名密码错误"  message:nil
                                                           delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
        }
        else if ([webcontent rangeOfString:@"9898"].location != NSNotFound) {
            //NSLog(@"Login Success");
            [self performSegueWithIdentifier:@"login" sender:self];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@", error);
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
