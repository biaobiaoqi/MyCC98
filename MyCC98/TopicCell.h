//
//  TopicCell.h
//  MyCC98
//
//  Created by Yan Chen on 1/21/13.
//  Copyright (c) 2013 Zhejiang University. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TopicCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel *title;
@property (nonatomic, weak) IBOutlet UILabel *author;
@property (nonatomic, weak) IBOutlet UILabel *lastReply;
@property (nonatomic, weak) IBOutlet UILabel *numberStat;

@end
