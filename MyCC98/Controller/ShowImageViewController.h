//
//  ShowImageViewController.h
//  MyCC98
//
//  Created by Yan Chen on 2/28/13.
//  Copyright (c) 2013 YANN. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShowImageViewController : UIViewController

@property (nonatomic) CGFloat initialScale;
@property (nonatomic, weak) IBOutlet UIImageView *imageview;
@property (nonatomic, weak) IBOutlet UIScrollView *scrollview;
@property (nonatomic, retain) UIImage *image;

- (void) imageTapped:(UITapGestureRecognizer *)gr;

@end
