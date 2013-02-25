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

@interface NewPostViewController : UIViewController

@property (nonatomic, strong) CCPostEntity *postEntity;
@property (nonatomic, strong) CCTopicEntity *topicEntity;
@property (nonatomic, retain) IBOutlet UITextView *textview;
@property (nonatomic) NSInteger postMode;

- (IBAction)submitButtonClicked:(id)sender;
- (IBAction)cancelButtonClicked:(id)sender;

@end
