//
//  PostCell.h
//  MyCC98
//
//  Created by Yan Chen on 1/28/13.
//  Copyright (c) 2013 YANN. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PostListViewController.h"
#import "CCPostEntity.h"
#import "MWPhotoBrowser.h"

@interface PostCell : UITableViewCell <MWPhotoBrowserDelegate>

@property (nonatomic) CGFloat cellHeight;
@property (nonatomic, retain) PostListViewController* controller;
@property (nonatomic, retain) NSMutableArray *photos;

-(void)setUBBCode:(CCPostEntity*)ubb rowNum:(NSInteger)rowNum;
- (void) imageTapped:(UITapGestureRecognizer *)gr;

@end
