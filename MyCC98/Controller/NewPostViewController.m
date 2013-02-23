//
//  NewPostViewController.m
//  MyCC98
//
//  Created by Yan Chen on 2/23/13.
//  Copyright (c) 2013 YANN. All rights reserved.
//

#import "NewPostViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface NewPostViewController ()

@end

@implementation NewPostViewController
@synthesize textview;

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
    
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithTitle:@"隐藏键盘" style:UIBarButtonItemStylePlain target:self.textview action:@selector(resignFirstResponder)];
    UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 32)];
    toolbar.items = [NSArray arrayWithObject:barButton];
    
    self.textview.inputAccessoryView = toolbar;
    
    [self.textview setText:self.preContent];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)submitButtonClicked:(id)sender
{
    NSLog(@"%@", [self.textview text]);
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)cancelButtonClicked:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
