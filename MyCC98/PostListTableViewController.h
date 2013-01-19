//
//  PostListTableViewController.h
//  MyCC98
//
//  Created by Yan Chen on 1/19/13.
//  Copyright (c) 2013 Zhejiang University. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BoardEntity.h"

@interface PostListTableViewController : UITableViewController
{
    BoardEntity *boardInfo;
}

@property (nonatomic, strong) BoardEntity *boardInfo;

@end
