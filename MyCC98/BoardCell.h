//
//  BoardCell.h
//  MyCC98
//
//  Created by Yan Chen on 1/21/13.
//  Copyright (c) 2013 Zhejiang University. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BoardCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel *title;
@property (nonatomic, weak) IBOutlet UILabel *intro;
@property (nonatomic, weak) IBOutlet UILabel *postNum;
@property (nonatomic, weak) IBOutlet UILabel *lastReply;


@end
