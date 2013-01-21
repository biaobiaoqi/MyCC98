//
//  BoardCell.m
//  MyCC98
//
//  Created by Yan Chen on 1/21/13.
//  Copyright (c) 2013 Zhejiang University. All rights reserved.
//

#import "BoardCell.h"

@implementation BoardCell
@synthesize title;
@synthesize intro;
@synthesize postNum;
@synthesize lastReply;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
