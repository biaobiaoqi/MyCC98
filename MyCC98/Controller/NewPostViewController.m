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
#import "UIImage+CCImageScale.h"
#import "AFNetworking.h"
#import "MBProgressHUD.h"
#import "GAI.h"

@interface NewPostViewController ()

@end

@implementation NewPostViewController
@synthesize textview;
@synthesize titleField;
@synthesize postEntity;
//@synthesize topicEntity;
@synthesize topicId;
@synthesize boardId;
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
    
    [[[GAI sharedInstance] defaultTracker] sendView:@"NewPost Screen"];
    
	// Do any additional setup after loading the view.
    [[self.textview layer] setBorderColor:[[UIColor blackColor] CGColor]];
    [[self.textview layer] setBorderWidth:1];
    //titleField.frame = CGRectMake(0, 0, 320, 100);
    //self.textview.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 80);
    
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithTitle:@"DONE" style:UIBarButtonItemStyleDone target:self.textview action:@selector(resignFirstResponder)];
    UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 40)];
    toolbar.barStyle = UIBarStyleDefault;
    UIBarButtonItem* flexSpace = [[UIBarButtonItem alloc]
                                  initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    [toolbar setItems:[NSArray arrayWithObjects:flexSpace,barButton,Nil] animated:NO];
    
    self.textview.inputAccessoryView = toolbar;
    //self.titleField.inputAccessoryView = toolbar;
    
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
    NSLog(@"title: %@", [self.titleField text]);
    NSDictionary* postData;
    if (postMode == 0 || postMode == 1) {
        postData = [NSDictionary dictionaryWithObjectsAndKeys:
                    @"", @"upfilerename",
                    postEntity.replyId, @"followup",
                    topicId, @"rootID",
                    @"1", @"star",
                    @"bbs1", @"TotalUseTable",
                    uid, @"username",
                    pw16, @"passwd",
                    postEntity.replyId, @"ReplyId",
                    [self.titleField text], @"subject",
                    @"face7.gif", @"Expression",
                    [NSString stringWithFormat:@"%@", [self.textview text]], @"Content",
                    @"yes", @"signflag",
                    nil];
    } else if (postMode == 2) {
        postData = [NSDictionary dictionaryWithObjectsAndKeys:
                    @"", @"upfilerename",
                    uid, @"username",
                    pw16, @"passwd",
                    [self.titleField text], @"subject",
                    @"face7.gif", @"Expression",
                    [NSString stringWithFormat:@"%@", [self.textview text]], @"Content",
                    @"yes", @"signflag",
                    nil];
    }
    //\n[right][color=gray]From iPhone via [url=dispbbs.asp?boardID=598&ID=4111850&page=1]MyCC98[/url][/color][/right]
    if (postMode == 0) {
        [[CC98API sharedInstance] replyTopicWithBoardId:boardId topicId:topicId data:postData success:^(AFHTTPRequestOperation *operation, id responseObject) {
            //NSLog(@"success");
            NSString *html = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
            NSLog(@"html: %@", html);
            [self dismissViewControllerAnimated:YES completion:nil];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"%@", error);
            [self dismissViewControllerAnimated:YES completion:nil];
        }];
    } else if (postMode == 1) {
        [[CC98API sharedInstance] replyPostWithBoardId:boardId replyId:postEntity.replyId topicId:topicId bm:[NSString stringWithFormat:@"%d", postEntity.bm] data:postData success:^(AFHTTPRequestOperation *operation, id responseObject) {
            //NSLog(@"success");
            NSString *html = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
            NSLog(@"html: %@", html);
            [self dismissViewControllerAnimated:YES completion:nil];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"%@", error);
            [self dismissViewControllerAnimated:YES completion:nil];
        }];
    } else if (postMode == 2) {
        [[CC98API sharedInstance] newPostWithBoardId:boardId data:postData success:^(AFHTTPRequestOperation *operation, id responseObject) {
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

- (IBAction)uploadButtonClicked:(id)sender
{
    UIActionSheet *actionsheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照", @"从相册选取", nil];
    [actionsheet showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    //NSLog(@"%d", buttonIndex);
    switch (buttonIndex) {
        case 0:
        {
            UIImagePickerController *picker = [[UIImagePickerController alloc] init];
            picker.delegate = self;
            if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
                picker.sourceType = UIImagePickerControllerSourceTypeCamera;
            } else {
                picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            }
            [self presentViewController:picker animated:YES completion:nil];
        }
            break;
        case 1:
        {
            UIImagePickerController *picker = [[UIImagePickerController alloc] init];
            picker.delegate = self;
            picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            [self presentViewController:picker animated:YES completion:nil];
        }
            break;
        default:
            break;
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    NSData *imageToUpload = UIImageJPEGRepresentation([UIImage imageWithImage:image scaledToMaxWidth:400 maxHeight:400], 90);
    NSMutableURLRequest *request = [[CC98API sharedInstance] multipartFormRequestWithMethod:@"POST" path:[NSString stringWithFormat:@"/saveannouce_upfile.asp?boardid=%@", boardId] parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        [formData appendPartWithFormData:[@"upload" dataUsingEncoding:NSUTF8StringEncoding] name:@"act"];
        [formData appendPartWithFormData:[@"C:\\fakepath\\zju1.jpg" dataUsingEncoding:NSUTF8StringEncoding] name:@"fname"];
        [formData appendPartWithFileData:imageToUpload name:@"file1" fileName:@"zju1.jpg" mimeType:@"image/jpeg"];
        [formData appendPartWithFormData:[@"ä¸Šä¼ " dataUsingEncoding:NSUTF8StringEncoding] name:@"Submit"];
    }];
    [request setValue:[NSString stringWithFormat:@"http://www.cc98.org/saveannounce_upload.asp?boardid=%@", boardId] forHTTPHeaderField:@"Referer"];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"正在上传...";
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *html = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        
        NSRegularExpression *imageUrlRegex = [[NSRegularExpression alloc]
                                               initWithPattern:@"(?<=\\[upload=jpg,1\\]).*?(?=\\[/upload\\])"
                                               options:NSRegularExpressionCaseInsensitive
                                               error:nil];
        NSRange imageUrlRange = [imageUrlRegex rangeOfFirstMatchInString:html options:0 range:NSMakeRange(0, html.length)];
        NSString *imageUrl = [html substringWithRange:imageUrlRange];
        //NSLog(@"response: [%@]",imageUrl);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        textview.text = [NSString stringWithFormat:@"%@[upload=jpg]%@[/upload]\n", textview.text, imageUrl];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        NSLog(@"error: %@", error);
    }];
    
    [operation start];
}

- (void)keyboardWasShown:(NSNotification*)notification {
    NSDictionary* info = [notification userInfo];
    CGSize keyboardSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    self.textview.frame = CGRectMake(0, 53, self.view.frame.size.width, self.view.frame.size.height - keyboardSize.height - 53);
}

- (void)keyboardWillBeHidden:(NSNotification*)notification {
    self.textview.frame = CGRectMake(0, 53, self.view.frame.size.width, self.view.frame.size.height - 80 - 53);
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return NO;
}

@end
