//
//  CC98Parser.m
//  MyCC98
//
//  Created by Yan Chen on 1/18/13.
//  Copyright (c) 2013 Zhejiang University. All rights reserved.
//

#import "CC98Parser.h"
#import "BoardEntity.h"
#import "HotTopicEntity.h"
#import "CC98Regex.h"
#import "TopicEntity.h"
#import "TFHpple.h"
#import "PostEntity.h"

@implementation CC98Parser

-(NSMutableArray*)parseCustomBoardList:(NSString*)html
{
    //NSLog(@"%@", html);
    NSMutableArray *boardlist = [[NSMutableArray alloc] init];
    
    NSRegularExpression *boardInfoRegex = [[NSRegularExpression alloc]
                                           initWithPattern:P_BOARD_OUTER_WRAAPER_REGEX
                                           options:NSRegularExpressionCaseInsensitive
                                           error:nil];
    NSRange boardInfoRange = [boardInfoRegex rangeOfFirstMatchInString:html options:0 range:NSMakeRange(0, html.length)];
    NSString *boardInfo = [html substringWithRange:boardInfoRange];
    //NSLog(@"%@", boardInfo);
    NSRegularExpression *boardRegex = [[NSRegularExpression alloc]
                                       initWithPattern:P_BOARD_SINGLE_BOARD_WRAPPER_REGEX
                                       options:NSRegularExpressionCaseInsensitive
                                       error:nil];
    NSArray *boardArray = [boardRegex matchesInString:boardInfo options:0 range:NSMakeRange(0, boardInfo.length)];
    for (NSTextCheckingResult *boardResult in boardArray) {
        NSString *board = [boardInfo substringWithRange:boardResult.range];
        //NSLog(@"\n\n=====================%@", board);
        NSRegularExpression *boardNameRegex = [[NSRegularExpression alloc]
                                               initWithPattern:P_BOARD_NAME_REGEX
                                               options:NSRegularExpressionCaseInsensitive
                                               error:nil];
        NSRange boardNameRange = [boardNameRegex rangeOfFirstMatchInString:board options:0 range:NSMakeRange(0, board.length)];
        NSString *boardName = [board substringWithRange:boardNameRange];
        
        NSRegularExpression *boardIdRegex = [[NSRegularExpression alloc]
                                             initWithPattern:P_BOARD_ID_REGEX
                                             options:NSRegularExpressionCaseInsensitive
                                             error:nil];
        NSRange boardIdRange = [boardIdRegex rangeOfFirstMatchInString:board options:0 range:NSMakeRange(0, board.length)];
        NSString *boardId = [board substringWithRange:boardIdRange];
        
        NSRegularExpression *boardIntroRegex = [[NSRegularExpression alloc]
                                             initWithPattern:P_BOARD_INTRO_REGEX
                                             options:NSRegularExpressionCaseInsensitive
                                             error:nil];
        NSRange boardIntroRange = [boardIntroRegex rangeOfFirstMatchInString:board options:0 range:NSMakeRange(0, board.length)];
        NSString *boardIntro = [board substringWithRange:boardIntroRange];
        
        NSRegularExpression *boardMasterRegex = [[NSRegularExpression alloc]
                                                initWithPattern:P_BOARD_BOARD_MASTER_REGEX
                                                options:NSRegularExpressionCaseInsensitive
                                                error:nil];
        NSRange boardMasterRange = [boardMasterRegex rangeOfFirstMatchInString:board options:0 range:NSMakeRange(0, board.length)];
        NSString *boardMaster;
        if (boardMasterRange.location == NSNotFound) {
            boardMaster = @"暂无";
        }
        else {
            boardMaster = [board substringWithRange:boardMasterRange];
        }
        
        NSRegularExpression *postNumberRegex = [[NSRegularExpression alloc]
                                                initWithPattern:P_BOARD_POST_NUMBER_TODAY
                                                options:NSRegularExpressionCaseInsensitive
                                                error:nil];
        NSRange postNumberRange = [postNumberRegex rangeOfFirstMatchInString:board options:0 range:NSMakeRange(0, board.length)];
        NSString *postNumber = [board substringWithRange:postNumberRange];
        
        NSRegularExpression *lastReplyAuthorRegex = [[NSRegularExpression alloc]
                                                initWithPattern:P_BOARD_LAST_REPLY_AUTHOR_REGEX
                                                options:NSRegularExpressionCaseInsensitive
                                                error:nil];
        NSRange lastReplyAuthorRange = [lastReplyAuthorRegex rangeOfFirstMatchInString:board options:0 range:NSMakeRange(0, board.length)];
        NSString *lastReplyAuthor = [board substringWithRange:lastReplyAuthorRange];
        
        NSRegularExpression *lastReplyTimeRegex = [[NSRegularExpression alloc]
                                                     initWithPattern:P_BOARD_LAST_REPLY_TIME_REGEX
                                                     options:NSRegularExpressionCaseInsensitive
                                                     error:nil];
        NSRange lastReplyTimeRange = [lastReplyTimeRegex rangeOfFirstMatchInString:board options:0 range:NSMakeRange(0, board.length)];
        NSString *lastReplyTime = [board substringWithRange:lastReplyTimeRange];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setTimeZone:[NSTimeZone timeZoneWithName:@"Asia/Shanghai"]];
        [formatter setAMSymbol:@"AM"];
        [formatter setPMSymbol:@"PM"];
        [formatter setDateFormat:@"M/d/yyyy h:mm:ss aaa"];
        NSDate *lastReplyTimeInDate = [formatter dateFromString:lastReplyTime];
        
        BoardEntity *entity = [BoardEntity alloc];
        [entity setBoardName:boardName];
        [entity setBoardId:boardId];
        [entity setBoardInto:boardIntro];
        [entity setBoardMaster:boardMaster];
        [entity setPostNumberToday:[postNumber intValue]];
        [entity setLastReplyAuthor:lastReplyAuthor];
        [entity setLastReplyTime:lastReplyTimeInDate];
        //NSLog(@"%@", lastReplyTimeInDate);
        [boardlist addObject:entity];
        
        //NSLog(@"%@ %@ %@ %@", boardName, boardId, boardIntro, boardMaster);
        
    }
    return boardlist;
}

-(NSMutableArray*)parseHottopicList:(NSString*)html
{
    //NSLog(@"%@", html);
    NSMutableArray *hottopiclist = [[NSMutableArray alloc] init];
    
    NSRegularExpression *topicListRegex = [[NSRegularExpression alloc]
                                           initWithPattern:HOT_TOPIC_WRAPPER
                                           options:NSRegularExpressionCaseInsensitive
                                           error:nil];
    NSArray *topicListArray = [topicListRegex matchesInString:html options:0 range:NSMakeRange(0, html.length)];
    for (NSTextCheckingResult *topicListResult in topicListArray) {
        NSString *topic = [html substringWithRange:topicListResult.range];
        //NSLog(@"%@", topic);
        
        NSRegularExpression *topicNameRegex = [[NSRegularExpression alloc]
                                               initWithPattern:HOT_TOPIC_NAME_REGEX
                                               options:NSRegularExpressionCaseInsensitive
                                               error:nil];
        NSRange topicNameRange = [topicNameRegex rangeOfFirstMatchInString:topic options:0 range:NSMakeRange(0, topic.length)];
        NSString *topicName = [topic substringWithRange:topicNameRange];
        //NSLog(@"%@", topicName);
        
        NSRegularExpression *topicIdRegex = [[NSRegularExpression alloc]
                                               initWithPattern:HOT_TOPIC_ID_REGEX
                                               options:NSRegularExpressionCaseInsensitive
                                               error:nil];
        NSRange topicIdRange = [topicIdRegex rangeOfFirstMatchInString:topic options:0 range:NSMakeRange(0, topic.length)];
        NSString *topicId = [topic substringWithRange:topicIdRange];
        //NSLog(@"%@", topicId);
        
        
        HotTopicEntity *entity = [HotTopicEntity alloc];
        [entity setTopicName:topicName];
        [entity setPostId:topicId];
        
        [hottopiclist addObject:entity];
    }
    //NSLog(@"%@", topicList);
    
    
    return hottopiclist;
}

-(NSString*)parseUserProfile:(NSString*)html
{
    NSRegularExpression *userAvatarRegex = [[NSRegularExpression alloc]
                                           initWithPattern:USER_PROFILE_AVATAR_REGEX
                                           options:NSRegularExpressionCaseInsensitive
                                           error:nil];
    NSRange userAvatarRange = [userAvatarRegex rangeOfFirstMatchInString:html options:0 range:NSMakeRange(0, html.length)];
    NSString *userAvatar = [html substringWithRange:userAvatarRange];
    return userAvatar;
}

-(NSMutableArray*)parseTopicList:(NSString*)html
{
    NSMutableArray *postlist = [[NSMutableArray alloc] init];
    TFHpple *parser = [TFHpple hppleWithHTMLData:[html dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSArray *topicNameArray = [parser searchWithXPathQuery:@"//html/body/form[@action='master_batch.asp']/table/form/tbody/tr[position()>2]/td[position()=2]/a/span"];
    NSArray *replyNumArray = [parser searchWithXPathQuery:@"//html/body/form[@action='master_batch.asp']/table/form/tbody/tr[position()>2]/td[position()=4]"];
    
    NSMutableString *webcontent = [NSMutableString stringWithString:html];
    NSRegularExpression *trim = [[NSRegularExpression alloc]
                                 initWithPattern:@"[\\r\\n\\t]"
                                 options:NSRegularExpressionCaseInsensitive
                                 error:nil];
    [trim replaceMatchesInString:webcontent options:0 range:NSMakeRange(0, webcontent.length) withTemplate:@""];
        
    NSRegularExpression *postListRegex = [[NSRegularExpression alloc]
                                           initWithPattern:POST_LIST_POST_ENTITY_REGEX
                                           options:NSRegularExpressionCaseInsensitive
                                           error:nil];
    NSArray *postListArray = [postListRegex matchesInString:webcontent options:0 range:NSMakeRange(0, webcontent.length)];
    //NSLog(@"%@", webcontent);
    //NSLog(@"%d", postListArray.count);
    for (int i=0; i<postListArray.count; ++i) {
        NSTextCheckingResult *postListResult = [postListArray objectAtIndex:i];
        NSString *topic = [webcontent substringWithRange:postListResult.range];
        //NSLog(@"%@\n=====================", topic);
        
        /*NSRegularExpression *topicNameRegex = [[NSRegularExpression alloc]
                                               initWithPattern:POST_LIST_POST_NAME_REGEX
                                               options:NSRegularExpressionCaseInsensitive
                                               error:nil];
        NSRange topicNameRange = [topicNameRegex rangeOfFirstMatchInString:topic options:0 range:NSMakeRange(0, topic.length)];
        NSString *topicName = [topic substringWithRange:topicNameRange];
        NSLog(@"%@", topicName);*/
        
        NSString *topicName = [[[topicNameArray objectAtIndex:i] firstChild] content];
        NSString *replyNum = [[[replyNumArray objectAtIndex:i] firstChild] content];
        
        NSRegularExpression *topicIdRegex = [[NSRegularExpression alloc]
                                               initWithPattern:POST_LIST_POST_ID_REGEX
                                               options:NSRegularExpressionCaseInsensitive
                                               error:nil];
        NSRange topicIdRange = [topicIdRegex rangeOfFirstMatchInString:topic options:0 range:NSMakeRange(0, topic.length)];
        NSString *topicId = [topic substringWithRange:topicIdRange];
        
        NSRegularExpression *topicAuthorRegex = [[NSRegularExpression alloc]
                                             initWithPattern:POST_LIST_POST_AUTHOR_NAME_REGEX
                                             options:NSRegularExpressionCaseInsensitive
                                             error:nil];
        NSRange topicAuthorRange = [topicAuthorRegex rangeOfFirstMatchInString:topic options:0 range:NSMakeRange(0, topic.length)];
        NSString *topicAuthor = [topic substringWithRange:topicAuthorRange];
        
        NSRegularExpression *lastReplyAuthorRegex = [[NSRegularExpression alloc]
                                                 initWithPattern:POST_LIST_LAST_REPLY_AUTHOR_REGEX
                                                 options:NSRegularExpressionCaseInsensitive
                                                 error:nil];
        NSRange lastReplyAuthorRange = [lastReplyAuthorRegex rangeOfFirstMatchInString:topic options:0 range:NSMakeRange(0, topic.length)];
        NSString *lastReplyAuthor = [topic substringWithRange:lastReplyAuthorRange];
        
        NSRegularExpression *topicPageNumRegex = [[NSRegularExpression alloc]
                                                     initWithPattern:POST_LIST_POST_PAGE_NUMBER_REGEX
                                                     options:NSRegularExpressionCaseInsensitive
                                                     error:nil];
        NSRange topicPageNumRange = [topicPageNumRegex rangeOfFirstMatchInString:topic options:0 range:NSMakeRange(0, topic.length)];
        NSString *topicPageNum;
        if (topicPageNumRange.location == NSNotFound) {
            topicPageNum = @"1";
        }
        else
        {
            topicPageNum = [topic substringWithRange:topicPageNumRange];
        }
        
        NSRegularExpression *boardIdRegex = [[NSRegularExpression alloc]
                                                     initWithPattern:POST_LIST_POST_BOARD_ID_REGEX
                                                     options:NSRegularExpressionCaseInsensitive
                                                     error:nil];
        NSRange boardIdRange = [boardIdRegex rangeOfFirstMatchInString:topic options:0 range:NSMakeRange(0, topic.length)];
        NSString *boardId = [topic substringWithRange:boardIdRange];

            
        TopicEntity *entity = [TopicEntity alloc];
        entity.topicName = topicName;
        entity.topicId = topicId;
        entity.topicAuthor = topicAuthor;
        entity.lastReplyAuthor = lastReplyAuthor;
        entity.topicPageNum = [topicPageNum intValue];
        entity.boardId = boardId;
        entity.replyNum = [replyNum stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        //NSLog(@"%d %@ %@ %@ %@ %d %@",i, topicName, topicId, topicAuthor, lastReplyAuthor, [topicPageNum intValue], boardId);
        [postlist addObject:entity];
    }
    
    return postlist;
}

-(NSInteger)parsePostListTotalPageNum:(NSData*)html
{
    TFHpple *parser = [TFHpple hppleWithHTMLData:html];
    
    NSArray *topicNameArray = [parser searchWithXPathQuery:@"//html/body/form[position()=2]/table/tr/td[position()=2]/div/a[@title='尾页']"];
    if (topicNameArray.count == 1) {
        TFHppleElement *element = [topicNameArray objectAtIndex:0];
        NSString *lastPageLink = [[element attributes] objectForKey:@"href"];
        //NSLog(@"%@", lastPageLink);
        NSRegularExpression *lastPageRegex = [[NSRegularExpression alloc]
                                             initWithPattern:@"(?<=page=)\\d+(?=&action)"
                                             options:NSRegularExpressionCaseInsensitive
                                             error:nil];
        NSRange lastPageRange = [lastPageRegex rangeOfFirstMatchInString:lastPageLink options:0 range:NSMakeRange(0, lastPageLink.length)];
        NSString *lastPage = [lastPageLink substringWithRange:lastPageRange];
        //NSLog(@"%@========", lastPage);
        return [lastPage intValue];
    }
    else
    {
        return 0;
    }
    //NSLog(@"%d=======", topicNameArray.count);
}

-(NSMutableArray*)parsePostList:(NSData*)html
{
    NSMutableArray *postlist = [[NSMutableArray alloc] init];
    
    TFHpple *parser = [TFHpple hppleWithHTMLData:html];
    
    NSArray *PostContentArray = [parser searchWithXPathQuery:@"//html/body/table[@cellpadding='5']/tbody/tr[position()=1]/td[position()=2]/blockquote/table/tr/td/span"];
    NSArray *PostAuthorArray = [parser searchWithXPathQuery:@"//html/body/table[@cellpadding='5']/tbody/tr[position()=1]/td[position()=1]/table/tr[position()=1]/td[position()=1]/a"];
    
    //NSLog(@"===============%d", PostAuthorArray.count);
    for (int i=0; i<PostContentArray.count; ++i) {
        TFHppleElement *element = [PostContentArray objectAtIndex:i];
        //NSLog(@"%@", [element description]);
        PostEntity *entity = [PostEntity alloc];
        NSMutableString *content = [[NSMutableString alloc] init];
        NSArray *child = [element children];
        for (TFHppleElement *child1 in child) {
            if ([child1 content] == nil) {
                [content appendString:@"\n"];
            }
            else {
                [content appendString:[child1 content]];
            }
        }
        //NSLog(@"%@", content);
        entity.postContent = content;
        entity.postAuthor = [[[[[PostAuthorArray objectAtIndex:i] firstChild] firstChild] firstChild] content];
        //NSLog(@"~~~~~~~~~~~~~%@", entity.postAuthor);
        
        
        [postlist addObject:entity];
    }
    return postlist;
}

@end
