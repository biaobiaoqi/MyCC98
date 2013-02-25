//
//  CCPostEntity.h
//  MyCC98
//
//  Created by Yan Chen on 1/31/13.
//  Copyright (c) 2013 YANN. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CCPostEntity : NSObject

@property (nonatomic, strong) NSString *postId;
@property (nonatomic, strong) NSString *postTitle;
@property (nonatomic, strong) NSString *postAuthor;
@property (nonatomic, strong) NSString *postContent;
@property (nonatomic, strong) NSString *replyId;
@property (nonatomic) NSInteger bm;
@property (nonatomic, strong) NSDate *postTime;

@end
