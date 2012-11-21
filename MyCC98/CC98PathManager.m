//
//  CC98PathManager.m
//  MyCC98
//
//  Created by Yan Chen on 11/21/12.
//  Copyright (c) 2012 VINCENT. All rights reserved.
//

#import "CC98PathManager.h"

@implementation CC98PathManager

-(NSString*)getQueryPath
{
    return @"/queryresult.asp";
}

-(NSString*)getQueryRefererPath
{
    return @"/query.asp?boardid=0";
}

-(NSString*)getUploadPicturePath
{
    return @"/saveannounce_upfile.asp?boardid=10";
}

-(NSString*)getTodayBoardListPath
{
    return @"/boardstat.asp?boardid=0";
}

-(NSString*)getSearchPath:(NSString*)keyword
                  boardid:(NSString*)boardid
                    sType:(NSString*)sType
                     page:(int)page
{
    return [[NSString alloc] initWithString:[NSString stringWithFormat:
                                             @"/queryresult.asp?page=%i&stype=%@&pSearch=1&nSearch=&keyword=%@&SearchDate=1000&boardid=%@&sertype=1",
                                             page, sType, keyword, boardid]];
}

-(NSString*)getOutboxPath:(NSString*)pageNum
{
    return [[NSString alloc] initWithString:[NSString stringWithFormat:@"/usersms.asp?action=issend&page=%@", pageNum]];
}

-(NSString*)getInboxUPath:(NSString*)pageNum
{
    return [[NSString alloc] initWithString:[NSString stringWithFormat:@"/usersms.asp?action=inbox&page=%@", pageNum]];
}

-(NSString*)getMessagePagePath:(int)pmId
{
    return [[NSString alloc] initWithString:[NSString stringWithFormat:@"/messanger.asp?action=read&id=%i", pmId]];
}

-(NSString*)getPersonalBoardPath
{
    return @"/";
}

-(NSString*)getBoardPath:(NSString*)boardId
                 pageNum:(int)pageNum
{
    return [[NSString alloc] initWithString:[NSString stringWithFormat:@"/list.asp?boardid=%@&page=%i", boardId, pageNum]];
}

-(NSString*)getBoardPath:(NSString*)boardId
{
    return [self getBoardPath:boardId pageNum:1];
}

-(NSString*)getPostPath:(NSString*)boardId
                 postId:(NSString*)postId
                pageNum:(int)pageNum
{
    return [[NSString alloc] initWithString:[NSString stringWithFormat:@"/dispbbs.asp?boardID=%@&ID=%@&star=%i", boardId, postId, pageNum]];
}

-(NSString*)getHotTopicPath
{
    return @"hottopic.asp";
}

-(NSString*)getUserProfilePath:(NSString*)userName
{
    return [[NSString alloc] initWithString:[NSString stringWithFormat:@"/dispuser.asp?name=%@",[userName stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
}

-(NSString*)getNewPostUrl:(int)pageNum
{
    
}

@end
