//
//  PostCell.m
//  MyCC98
//
//  Created by Yan Chen on 1/22/13.
//  Copyright (c) 2013 Zhejiang University. All rights reserved.
//

#import "PostCell.h"

@implementation PostCell
@synthesize content;
@synthesize author;

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
