//
//  CCHotTopicEntity.h
//  MyCC98
//
//  Created by Yan Chen on 2/25/13.
//  Copyright (c) 2013 YANN. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CCHotTopicEntity : NSObject

@property (nonatomic, strong) NSString *topicName;
@property (nonatomic, strong) NSString *topicId;
@property (nonatomic, strong) NSString *boardId;
@property (nonatomic, strong) NSString *boardName;
@property (nonatomic, strong) NSString *postAuthor;
@property (nonatomic, strong) NSDate *postTime;
@property (nonatomic) NSInteger focusNumber;
@property (nonatomic) NSInteger replyNumber;
@property (nonatomic) NSInteger clickNumber;

@end
