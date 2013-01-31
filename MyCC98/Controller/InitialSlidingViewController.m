//
//  InitialSlidingViewController.m
//  MyCC98
//
//  Created by Yan Chen on 1/26/13.
//  Copyright (c) 2013 YANN. All rights reserved.
//

#import "InitialSlidingViewController.h"

@interface InitialSlidingViewController ()

@end

@implementation InitialSlidingViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    UIStoryboard *storyboard;
    
    storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    
    self.topViewController = [storyboard instantiateViewControllerWithIdentifier:@"BoardList"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
