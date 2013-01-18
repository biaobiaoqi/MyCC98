//
//  BoardEntity.m
//  MyCC98
//
//  Created by Yan Chen on 1/18/13.
//  Copyright (c) 2013 Zhejiang University. All rights reserved.
//

#import "BoardEntity.h"

@implementation BoardEntity

-(NSString*) getBoardName
{
    return boardName;
}
-(void) setBoardName:(NSString*)str
{
    boardName = str;
}

-(NSString*) getBoardId
{
    return boardId;
}
-(void) setBoardId:(NSString*)str
{
    boardId = str;
}

-(NSString*) getBoardIntro
{
    return boardIntro;
}
-(void) setBoardInto:(NSString*)str
{
    boardIntro = str;
}

-(NSString*) getLastReplyTopicName
{
    return lastReplyTopicName;
}
-(void) setLastReplyTopicName:(NSString*)str
{
    lastReplyTopicName = str;
}

-(NSString*) getLastReplyTopicId
{
    return lastReplyTopicId;
}
-(void) setLastReplyTopicId:(NSString*)str
{
    lastReplyTopicId = str;
}

-(NSString*) getLastReplyAuthor
{
    return lastReplyAuthor;
}
-(void) setLastReplyAuthor:(NSString*)str
{
    lastReplyAuthor = str;
}

-(NSDate*) getLastReplyTime
{
    return lastReplyTime;
}
-(void) setLastReplyTime:(NSDate*)date
{
    lastReplyTime = date;
}

-(NSInteger) getPostNumberToday
{
    return postNumberToday;
}
-(void) setPostNumberToday:(NSInteger)num
{
    postNumberToday = num;
}

-(NSString*) getBoardMaster
{
    return boardMaster;
}
-(void) setBoardMaster:(NSString*)str
{
    boardMaster = str;
}

@end
