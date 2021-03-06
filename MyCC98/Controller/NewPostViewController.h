//
//  NewPostViewController.h
//  MyCC98
//
//  Created by Yan Chen on 2/23/13.
//  Copyright (c) 2013 YANN. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CCPostEntity.h"
#import "CCTopicEntity.h"

@interface NewPostViewController : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIActionSheetDelegate>

@property (nonatomic, strong) CCPostEntity *postEntity;
//@property (nonatomic, strong) CCTopicEntity *topicEntity;
@property (nonatomic, strong) NSString *topicId;
@property (nonatomic, strong) NSString *boardId;
@property (nonatomic, retain) IBOutlet UITextView *textview;
@property (nonatomic, retain) IBOutlet UITextField *titleField;
@property (nonatomic) NSInteger postMode; //0:reply 1:quote 2:newpost

- (IBAction)submitButtonClicked:(id)sender;
- (IBAction)cancelButtonClicked:(id)sender;
- (IBAction)uploadButtonClicked:(id)sender;

- (void)keyboardWasShown:(NSNotification*)notification;
- (void)keyboardWillBeHidden:(NSNotification*)notification;
- (BOOL)textFieldShouldReturn:(UITextField *)textField;

@end
