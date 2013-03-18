//
//  ShowImageViewController.m
//  MyCC98
//
//  Created by Yan Chen on 2/28/13.
//  Copyright (c) 2013 YANN. All rights reserved.
//

#import "ShowImageViewController.h"
#import "GAI.h"

@interface ShowImageViewController ()

@end

@implementation ShowImageViewController
@synthesize initialScale;
@synthesize image;
@synthesize imageview;
@synthesize scrollview;

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
    
    [[[GAI sharedInstance] defaultTracker] sendView:@"ShowImage Screen"];
	// Do any additional setup after loading the view.
    [imageview setImage:image];
    //imageview.contentMode = UIViewContentModeScaleAspectFill;
    imageview.contentMode = UIViewContentModeScaleAspectFit;
    
    //imageview.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageTapped:)];
    [scrollview addGestureRecognizer:tap];
    
    /*UIPinchGestureRecognizer *pinchGesture = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(scaleImage:)];
    [imageview addGestureRecognizer:pinchGesture];*/
}

- (void) imageTapped:(UITapGestureRecognizer *)gr
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
