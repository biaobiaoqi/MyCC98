//
//  CC98UrlManager.m
//  MyCC98
//
//  Created by Yan Chen on 1/18/13.
//  Copyright (c) 2013 Zhejiang University. All rights reserved.
//

#import "CC98UrlManager.h"

@implementation CC98UrlManager

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

@end
