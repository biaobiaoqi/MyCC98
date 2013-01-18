//
//  HotTopicEntity.h
//  MyCC98
//
//  Created by Yan Chen on 1/18/13.
//  Copyright (c) 2013 Zhejiang University. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HotTopicEntity : NSObject
{
    NSString *topicName;
    NSString *postId;
    NSString *boardId;
    NSString *boardName;
    NSString *postAuthor;
    NSString *postTime;
    NSInteger focusNumber;
    NSInteger replyNumber;
    NSInteger clickNumber;
}

-(NSString*)getTopicName;
-(void)setTopicName:(NSString*)str;

-(NSString*)getPostId;
-(void)setPostId:(NSString*)str;

-(NSString*)getBoardId;
-(void)setBoardId:(NSString*)str;

-(NSString*)getBoardName;
-(void)setBoardName:(NSString*)str;

-(NSString*)getPostAuthor;
-(void)setPostAuthor:(NSString*)str;

-(NSString*)getPostTime;
-(void)setPostTime:(NSString*)str;

-(NSInteger)getFocusNumber;
-(void)setFocusNumber:(NSInteger)num;

-(NSInteger)getReplyNumber;
-(void)setReplyNumber:(NSInteger)num;

-(NSInteger)getClickNumber;
-(void)setClickNumber:(NSInteger)num;


@end
