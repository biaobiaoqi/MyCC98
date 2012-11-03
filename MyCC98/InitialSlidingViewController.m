//
//  InitialSlidingViewController.m
//  MyCC98
//
//  Created by Yan Chen on 11/3/12.
//  Copyright (c) 2012 VINCENT. All rights reserved.
//

#import "InitialSlidingViewController.h"

@implementation InitialSlidingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIStoryboard *storyboard;
    
    //if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
    storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    //}
    
    self.topViewController = [storyboard instantiateViewControllerWithIdentifier:@"CustomBoard"];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
