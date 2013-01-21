//
//  TopicEntity.h
//  MyCC98
//
//  Created by Yan Chen on 1/21/13.
//  Copyright (c) 2013 Zhejiang University. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TopicEntity : NSObject
{
    NSString *topicName;
    NSString *topicId;
    NSString *boardId;
    NSString *topicType;
    NSInteger topicPageNum;
    NSString *topicAuthor;
    NSString *replyNum;
    NSDate *lastReplyTime;
    NSString *lastReplyAuthor;
}

@property (nonatomic, strong) NSString *topicName;
@property (nonatomic, strong) NSString *topicId;
@property (nonatomic, strong) NSString *boardId;
@property (nonatomic, strong) NSString *topicType;
@property (nonatomic) NSInteger topicPageNum;
@property (nonatomic, strong) NSString *topicAuthor;
@property (nonatomic, strong) NSString *replyNum;
@property (nonatomic, strong) NSDate *lastReplyTime;
@property (nonatomic, strong) NSString *lastReplyAuthor;

@end
