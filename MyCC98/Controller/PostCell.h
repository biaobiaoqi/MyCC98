//
//  PostCell.h
//  MyCC98
//
//  Created by Yan Chen on 1/28/13.
//  Copyright (c) 2013 YANN. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PostListTableViewController.h"
#import "CCPostEntity.h"

@interface PostCell : UITableViewCell

@property (nonatomic) CGFloat cellHeight;

-(void)setUBBCode:(CCPostEntity*)ubb rowNum:(NSInteger)rowNum controller:(PostListTableViewController*)ctrl;

@end
