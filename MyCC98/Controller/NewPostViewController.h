//
//  NewPostViewController.h
//  MyCC98
//
//  Created by Yan Chen on 2/23/13.
//  Copyright (c) 2013 YANN. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewPostViewController : UIViewController

@property (nonatomic, strong) NSString *preContent;
@property (nonatomic, retain) IBOutlet UITextView *textview;

- (IBAction)submitButtonClicked:(id)sender;
- (IBAction)cancelButtonClicked:(id)sender;

@end
