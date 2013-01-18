//
//  BoardEntity.h
//  MyCC98
//
//  Created by Yan Chen on 1/18/13.
//  Copyright (c) 2013 Zhejiang University. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BoardEntity : NSObject
{
    NSString* boardName;
    NSString* boardId;
    NSString* boardIntro;
    NSString* lastReplyTopicName;
    NSString* lastReplyTopicId;
    NSString* lastReplyAuthor;
    NSDate* lastReplyTime;
    NSInteger postNumberToday;
    NSString* boardMaster;
}

-(NSString*) getBoardName;
-(void) setBoardName:(NSString*)str;

-(NSString*) getBoardId;
-(void) setBoardId:(NSString*)str;

-(NSString*) getBoardIntro;
-(void) setBoardInto:(NSString*)str;

-(NSString*) getLastReplyTopicName;
-(void) setLastReplyTopicName:(NSString*)str;

-(NSString*) getLastReplyTopicId;
-(void) setLastReplyTopicId:(NSString*)str;

-(NSString*) getLastReplyAuthor;
-(void) setLastReplyAuthor:(NSString*)str;

-(NSDate*) getLastReplyTime;
-(void) setLastReplyTime:(NSDate*)date;

-(NSInteger) getPostNumberToday;
-(void) setPostNumberToday:(NSInteger)num;

-(NSString*) getBoardMaster;
-(void) setBoardMaster:(NSString*)str;

@end
