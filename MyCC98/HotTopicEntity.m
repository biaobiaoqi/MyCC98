//
//  HotTopicEntity.m
//  MyCC98
//
//  Created by Yan Chen on 1/18/13.
//  Copyright (c) 2013 Zhejiang University. All rights reserved.
//

#import "HotTopicEntity.h"

@implementation HotTopicEntity

-(NSString*)getTopicName
{
    return topicName;
}
-(void)setTopicName:(NSString*)str
{
    topicName = str;
}

-(NSString*)getPostId
{
    return postId;
}
-(void)setPostId:(NSString*)str
{
    postId = str;
}

-(NSString*)getBoardId
{
    return boardId;
}
-(void)setBoardId:(NSString*)str
{
    boardId = str;
}

-(NSString*)getBoardName
{
    return boardName;
}
-(void)setBoardName:(NSString*)str
{
    boardName = str;
}

-(NSString*)getPostAuthor
{
    return postAuthor;
}
-(void)setPostAuthor:(NSString*)str
{
    postAuthor = str;
}

-(NSString*)getPostTime
{
    return postTime;
}
-(void)setPostTime:(NSString*)str
{
    postTime = str;
}

-(NSInteger)getFocusNumber
{
    return focusNumber;
}
-(void)setFocusNumber:(NSInteger)num
{
    focusNumber = num;
}

-(NSInteger)getReplyNumber
{
    return replyNumber;
}
-(void)setReplyNumber:(NSInteger)num
{
    replyNumber = num;
}

-(NSInteger)getClickNumber
{
    return clickNumber;
}
-(void)setClickNumber:(NSInteger)num
{
    clickNumber = num;
}

@end
