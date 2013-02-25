//
//  NewPostViewController.m
//  MyCC98
//
//  Created by Yan Chen on 2/23/13.
//  Copyright (c) 2013 YANN. All rights reserved.
//

#import "NewPostViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "CC98API.h"
#import "NSDate+CCDateUtil.h"

@interface NewPostViewController ()

@end

@implementation NewPostViewController
@synthesize textview;
@synthesize postEntity;
@synthesize topicEntity;
@synthesize postMode;

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
    [[self.textview layer] setBorderColor:[[UIColor grayColor] CGColor]];
    [[self.textview layer] setBorderWidth:1];
    //self.textview.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 80);
    
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithTitle:@"DONE" style:UIBarButtonItemStyleDone target:self.textview action:@selector(resignFirstResponder)];
    UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 40)];
    toolbar.barStyle = UIBarStyleDefault;
    UIBarButtonItem* flexSpace = [[UIBarButtonItem alloc]
                                  initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    [toolbar setItems:[NSArray arrayWithObjects:flexSpace,barButton,Nil] animated:NO];
    
    self.textview.inputAccessoryView = toolbar;
    if (postMode == 1) {
        NSString *postTimeString = [postEntity.postTime convertToString];
        [self.textview setText:[NSString stringWithFormat:@"[quotex][b]以下是引用[i]%@在%@[/i]的发言：[/b]\n%@\n[/quotex]\n", self.postEntity.postAuthor,postTimeString, self.postEntity.postContent]];
        //NSLog(@"postId: %@", self.postEntity.postId);
    }
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)submitButtonClicked:(id)sender
{
    NSLog(@"%@", [self.textview text]);
    NSString *uid = [[NSUserDefaults standardUserDefaults] objectForKey:@"username"];
    NSString *pw16 = [[NSUserDefaults standardUserDefaults] objectForKey:@"pw16"];
    NSLog(@"username: %@", uid);
    NSLog(@"passwd: %@", pw16);
    NSDictionary* postData;
    postData = [NSDictionary dictionaryWithObjectsAndKeys:
                 @"", @"upfilerename",
                 postEntity.replyId, @"followup",
                 topicEntity.topicId, @"rootID",
                 @"1", @"star",
                 @"bbs1", @"TotalUseTable",
                 uid, @"username",
                 pw16, @"passwd",
                 postEntity.replyId, @"ReplyId",
                 @"", @"subject",
                 @"face7.gif", @"Expression",
                 [self.textview text], @"Content",
                 @"yes", @"signflag",
                 nil];
    if (postMode == 0) {
        [[CC98API sharedInstance] replyTopicWithBoardId:topicEntity.boardId topicId:topicEntity.topicId data:postData success:^(AFHTTPRequestOperation *operation, id responseObject) {
            //NSLog(@"success");
            NSString *html = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
            NSLog(@"html: %@", html);
            [self dismissViewControllerAnimated:YES completion:nil];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"%@", error);
            [self dismissViewControllerAnimated:YES completion:nil];
        }];
    } else if (postMode == 1) {
        [[CC98API sharedInstance] replyPostWithBoardId:topicEntity.boardId replyId:postEntity.replyId topicId:topicEntity.topicId bm:[NSString stringWithFormat:@"%d", postEntity.bm] data:postData success:^(AFHTTPRequestOperation *operation, id responseObject) {
            //NSLog(@"success");
            NSString *html = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
            NSLog(@"html: %@", html);
            [self dismissViewControllerAnimated:YES completion:nil];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"%@", error);
            [self dismissViewControllerAnimated:YES completion:nil];
        }];
    }
    
    
}

- (IBAction)cancelButtonClicked:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)keyboardWasShown:(NSNotification*)notification {
    NSDictionary* info = [notification userInfo];
    CGSize keyboardSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    self.textview.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - keyboardSize.height);
}

- (void)keyboardWillBeHidden:(NSNotification*)notification {
    self.textview.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 80);
}

@end
