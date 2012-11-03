//
//  BoardListNavigationController.m
//  MyCC98
//
//  Created by Yan Chen on 11/3/12.
//  Copyright (c) 2012 VINCENT. All rights reserved.
//

#import "BoardListNavigationController.h"

@interface BoardListNavigationController ()

@end

@implementation BoardListNavigationController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (![self.slidingViewController.underLeftViewController isKindOfClass:[MenuViewController class]]) {
        self.slidingViewController.underLeftViewController  = [self.storyboard instantiateViewControllerWithIdentifier:@"Menu"];
    }
    
    [self.view addGestureRecognizer:self.slidingViewController.panGesture];
}

@end
