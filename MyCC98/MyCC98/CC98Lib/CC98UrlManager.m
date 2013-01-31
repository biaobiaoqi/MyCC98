//
//  CC98UrlManager.m
//  MyCC98
//
//  Created by Yan Chen on 1/27/13.
//  Copyright (c) 2013 YANN. All rights reserved.
//

#import "CC98UrlManager.h"

@implementation CC98UrlManager

#pragma mark - Singleton methods
/**
 * Singleton methods
 */
+(CC98UrlManager*)sharedInstance
{
    static CC98UrlManager *sharedInstance = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        sharedInstance = [self alloc];
    });
    
    return sharedInstance;
}

-(NSString*) getIndexPath
{
    return @"/";
}

-(NSString*) getLoginPath
{
    return @"/sign.asp";
}

-(NSString*) getHotTopicPath
{
    return @"/hottopic.asp";
}

-(NSString*) getUserProfilePath:(NSString*)userName
{
    return [[NSString alloc] initWithString:[NSString stringWithFormat:@"/dispuser.asp?name=%@",[userName stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
}

-(NSString*) getBoardPathWithBoardId:(NSString*)boardId pageNum:(NSInteger)pageNum
{
    return [[NSString alloc] initWithString:[NSString stringWithFormat:@"/list.asp?boardid=%@&page=%d",boardId, pageNum]];
}

-(NSString*) getTopicPathWithBoardId:(NSString*)boardId topicId:(NSString*)topicId pageNum:(NSInteger)pageNum
{
    return [[NSString alloc] initWithString:[NSString stringWithFormat:@"/dispbbs.asp?BoardID=%@&ID=%@&star=%d",boardId, topicId, pageNum]];
}

-(NSString*) getBoardStatPath
{
    return @"/boardstat.asp";
}

@end
