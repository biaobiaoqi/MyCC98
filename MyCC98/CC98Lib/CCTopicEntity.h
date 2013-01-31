//
//  CCTopicEntity.h
//  MyCC98
//
//  Created by Yan Chen on 1/27/13.
//  Copyright (c) 2013 YANN. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CCTopicEntity : NSObject

@property (nonatomic, strong) NSString *topicName;
@property (nonatomic, strong) NSString *topicId;
@property (nonatomic, strong) NSString *boardId;
@property (nonatomic, strong) NSString *topicAuthor;
@property (nonatomic, strong) NSString *replyNum;
@property (nonatomic, strong) NSString *lastReplyAuthor;

@end
