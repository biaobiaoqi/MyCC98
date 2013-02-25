//
//  CC98Parser.m
//  MyCC98
//
//  Created by Yan Chen on 1/27/13.
//  Copyright (c) 2013 YANN. All rights reserved.
//

#import "CC98Parser.h"
#import "TFHpple.h"
#import "CCBoardEntity.h"
#import "CCTopicEntity.h"
#import "CCPostEntity.h"
#import "NSString+CCStringUtil.h"

#define P_BOARD_OUTER_WRAAPER_REGEX @"var customboards_disp = new Array[\\s\\S]*var customboards_order=customboards\\.split"
#define P_BOARD_SINGLE_BOARD_WRAPPER_REGEX @"</a>-->[\\s\\S]*?(?=</td></tr></table></TD>)"
#define P_BOARD_NAME_REGEX @"(?<=<font color=#000066>).*?(?=</font>)"
#define P_BOARD_ID_REGEX @"(?<=<a href=\"list.asp\\?boardid=)[0-9]+(?=\">)"

#define POST_LIST_POST_TYPE_REGEX @"(?<=alt=).*?(?=></TD>)"
#define POST_LIST_POST_NAME_REGEX @"(?<=最后跟贴：\">).*?(?=</a>)"
#define POST_LIST_POST_ID_REGEX @"(?<=&ID=)\\d{1,10}?(?=&page=)"
#define POST_LIST_POST_BOARD_ID_REGEX @"(?<=dispbbs.asp\\?boardID=)\\d{1,10}?(?=&ID=)"
#define POST_LIST_POST_PAGE_NUMBER_REGEX @"(?<=<font color=#FF0000>).{1,6}?(?=</font></a>.?</b>\\])"
#define POST_LIST_POST_AUTHOR_NAME_REGEX @"(?<=target=\"_blank\">).{1,15}(?=</a>)|(?<=<td width=80 nowrap class=tablebody2>).{1,15}?(?=</td>)"
#define POST_LIST_REPLY_NUM_REGEX @"(?<=<td width=\\* nowrap class=tablebody1>).*?(?=</td>)"
#define POST_LIST_LAST_REPLY_TIME_REGEX @"(?<=#bottom\">).*?(?=</a>)"
#define POST_LIST_LAST_REPLY_AUTHOR_REGEX @"(?<=usr\":\").*?(?=\")"
#define POST_LIST_POST_ENTITY_REGEX @"(?<=<tr style=\"vertical-align: middle;\">).*?(?=;</script>)"

#define USER_PROFILE_AVATAR_REGEX @"(?<=&nbsp;\\<img src=).*?(?= )"

@implementation CC98Parser

#pragma mark - Singleton methods
/**
 * Singleton methods
 */
+(CC98Parser*)sharedInstance
{
    static CC98Parser *sharedInstance = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        sharedInstance = [[self alloc] init];
    });
    
    return sharedInstance;
}


-(NSMutableArray*)parseAllBoardList:(NSData*)html
{
    NSMutableArray *boardlist = [[NSMutableArray alloc] init];
    
    TFHpple *parser = [TFHpple hppleWithHTMLData:html];
    
    NSArray *boardNameArray = [parser searchWithXPathQuery:@"//html/body/table[position()=5]/tr[position()>1]/td[position()=1]/a"];
    
    //NSLog(@"===============%d", PostAuthorArray.count);
    for (int i=0; i<boardNameArray.count; ++i) {
        TFHppleElement *element = [boardNameArray objectAtIndex:i];
        //NSLog(@"%@", [element description]);
        CCBoardEntity *entity = [CCBoardEntity alloc];
        NSString *href = [[element attributes] objectForKey:@"href"];
        
        //NSLog(@"%@", content);
        entity.boardId = [href stringByReplacingOccurrencesOfString:@".*boardid=(\\d+)" withString:@"$1"  options:NSRegularExpressionSearch range:NSMakeRange(0, [href length])];
        entity.boardName = [[element firstChild] content];
        //NSLog(@"~~~~~~~~~~~~~%@", entity.boardId);
        //NSLog(@"~~~~~~~~~~~~~%@", entity.boardName);
        [boardlist addObject:entity];
    }
    return boardlist;
}

-(NSMutableArray*)parsePersonalBoardList:(NSData*)htmlData
{
    NSString *html = [[NSString alloc] initWithData:htmlData encoding:NSUTF8StringEncoding];
    //NSLog(@"%@", html);
    
    NSMutableArray *boardlist = [[NSMutableArray alloc] init];
    
    NSRegularExpression *boardInfoRegex = [[NSRegularExpression alloc]
                                           initWithPattern:P_BOARD_OUTER_WRAAPER_REGEX
                                           options:NSRegularExpressionCaseInsensitive
                                           error:nil];
    NSRange boardInfoRange = [boardInfoRegex rangeOfFirstMatchInString:html options:0 range:NSMakeRange(0, html.length)];
    if (boardInfoRange.location == NSNotFound) {
        return boardlist;
    }
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
        
        CCBoardEntity *entity = [CCBoardEntity alloc];
        entity.boardId = boardId;
        entity.boardName = boardName;
        //NSLog(@"%@", lastReplyTimeInDate);
        [boardlist addObject:entity];
        
        //NSLog(@"%@ %@ %@ %@", boardName, boardId, boardIntro, boardMaster);
        
    }
    return boardlist;

}

-(NSMutableArray*)parseTopicList:(NSData*)htmlData
{
    //NSLog(@"I'm here!");
    NSString *html = [[NSString alloc] initWithData:htmlData encoding:NSUTF8StringEncoding];
    NSMutableArray *topiclist = [[NSMutableArray alloc] init];
    TFHpple *parser = [TFHpple hppleWithHTMLData:htmlData];
    
    NSArray *topicNameArray = [parser searchWithXPathQuery:@"//html/body/form[@name='batch']/table/form/tbody/tr[position()>2]/td[position()=2]/a/span"];
    NSArray *replyNumArray = [parser searchWithXPathQuery:@"//html/body/form[@name='batch']/table/form/tbody/tr[position()>2]/td[position()=4]"];
    
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
    //NSLog(@"======%d", postListArray.count);
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
        
        
        CCTopicEntity *entity = [CCTopicEntity alloc];
        entity.topicName = topicName;
        entity.topicId = topicId;
        entity.topicAuthor = topicAuthor;
        entity.lastReplyAuthor = lastReplyAuthor;
        entity.boardId = boardId;
        entity.replyNum = [replyNum stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        //NSLog(@"%d %@ %@ %@ %@ %d %@",i, topicName, topicId, topicAuthor, lastReplyAuthor, [topicPageNum intValue], boardId);
        [topiclist addObject:entity];
    }
    
    return topiclist;
}

-(NSInteger)parseTotalPageNumInTopicList:(NSData*)htmlData
{
    //NSLog(@"I'm here!");
    NSString *html = [[NSString alloc] initWithData:htmlData encoding:NSUTF8StringEncoding];
    
    NSRegularExpression *pageNumOutRegex = [[NSRegularExpression alloc]
                                            initWithPattern:@"页次：<b>\\d+</b>/<b>\\d+</b>页"
                                            options:NSRegularExpressionCaseInsensitive
                                            error:nil];
    NSArray *pageNumOutArray = [pageNumOutRegex matchesInString:html options:0 range:NSMakeRange(0, html.length)];
    if (pageNumOutArray.count == 0) {
        NSLog(@"搜索到0处pageNumOut");
        return 0;
    }
    NSTextCheckingResult *pageNumOutResult = [pageNumOutArray objectAtIndex:0];
    NSString *pageNumOut = [html substringWithRange:pageNumOutResult.range];
    //NSLog(@"%@", pageNumOut);
    
    NSRegularExpression *pageNumRegex = [[NSRegularExpression alloc]
                                            initWithPattern:@"(?<=<b>)\\d+?(?=</b>页)"
                                            options:NSRegularExpressionCaseInsensitive
                                            error:nil];
    NSArray *pageNumArray = [pageNumRegex matchesInString:pageNumOut options:0 range:NSMakeRange(0, pageNumOut.length)];
    if (pageNumArray.count == 0) {
        NSLog(@"搜索到0处pageNum");
        return 0;
    }
    NSTextCheckingResult *pageNumResult = [pageNumArray objectAtIndex:0];
    NSString *pageNum = [pageNumOut substringWithRange:pageNumResult.range];
    //NSLog(@"%@", pageNum);
    return [pageNum intValue];
}


-(NSMutableArray*)parsePostList:(NSData*)htmlData
{
    NSMutableArray *postlist = [[NSMutableArray alloc] init];
    
    TFHpple *parser = [TFHpple hppleWithHTMLData:htmlData];
    
    NSArray *PostContentArray = [parser searchWithXPathQuery:@"//html/body/table[@cellpadding='5']/tbody/tr[position()=1]/td[position()=2]/blockquote/table/tr/td/span"];
    NSArray *PostAuthorArray = [parser searchWithXPathQuery:@"//html/body/table[@cellpadding='5']/tbody/tr[position()=1]/td[position()=1]/table/tr[position()=1]/td[position()=1]/a"];
    NSArray *PostBmArray = [parser searchWithXPathQuery:@"//html/body/table[@cellpadding='5']/tbody/tr[position()=1]/td[position()=2]/table/tr[position()=1]/td[position()=1]/a[position()=5]"];
    NSArray *PostTimeArray = [parser searchWithXPathQuery:@"//html/body/table[@cellpadding='5']/tbody/tr[position()=2]/td[position()=1]/text()[position()=2]"];
    //NSLog(@"===============%d", PostAuthorArray.count);
    for (int i=0; i<PostContentArray.count; ++i) {
        TFHppleElement *element = [PostContentArray objectAtIndex:i];
        //NSLog(@"%@", [element description]);
        CCPostEntity *entity = [CCPostEntity alloc];
        NSMutableString *content = [[NSMutableString alloc] init];
        NSArray *child = [element children];
        for (TFHppleElement *child1 in child) {
            if ([child1 content] == nil) {
                [content appendString:@"<br>"];
            }
            else {
                [content appendString:[child1 content]];
            }
        }
        //NSLog(@"%@", content);
        entity.postContent = content;
        
        //pre proccess "<br>" flags
        entity.postContent = [entity.postContent stringByReplacingOccurrencesOfString:@"\n" withString:@"" options:NSRegularExpressionSearch range:NSMakeRange(0, [entity.postContent length])];
        entity.postContent = [entity.postContent stringByReplacingOccurrencesOfString:@"<br>" withString:@"\n" options:NSRegularExpressionSearch range:NSMakeRange(0, [entity.postContent length])];
        
        entity.postAuthor = [[[[[PostAuthorArray objectAtIndex:i] firstChild] firstChild] firstChild] content];
        
        NSString *postTimeString = [[PostTimeArray objectAtIndex:i] content];
        postTimeString = [postTimeString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        //NSLog(@"post time: %@", postTimeString);
        NSDate *postTime = [postTimeString convertToDate];
        
        NSString *referer = [[PostBmArray objectAtIndex:i]  objectForKey:@"href"];
        NSRegularExpression *bmRegex = [[NSRegularExpression alloc]
                                                initWithPattern:@"(?<=bm=)\\d+"
                                                options:NSRegularExpressionCaseInsensitive
                                                error:nil];
        NSArray *bmArray = [bmRegex matchesInString:referer options:0 range:NSMakeRange(0, referer.length)];
        if (bmArray.count == 0) {
            NSLog(@"搜索到0处bm");
            return 0;
        }
        NSTextCheckingResult *bmResult = [bmArray objectAtIndex:0];
        NSString *bm = [referer substringWithRange:bmResult.range];
        //NSLog(@"bm:%@", bm);
        entity.bm = [bm intValue];
        
        NSRegularExpression *replyIdRegex = [[NSRegularExpression alloc]
                                        initWithPattern:@"(?<=replyID=)\\d+"
                                        options:NSRegularExpressionCaseInsensitive
                                        error:nil];
        NSArray *replyIdArray = [replyIdRegex matchesInString:referer options:0 range:NSMakeRange(0, referer.length)];
        if (replyIdArray.count == 0) {
            NSLog(@"搜索到0处replyId");
            return 0;
        }
        NSTextCheckingResult *replyIdResult = [replyIdArray objectAtIndex:0];
        NSString *replyId = [referer substringWithRange:replyIdResult.range];
        //NSLog(@"replyId:%@", replyId);
        entity.replyId = replyId;
        entity.postTime = postTime;
        
        [postlist addObject:entity];
    }
    return postlist;
}

-(NSInteger)parseTotalPageNumInPostList:(NSData*)htmlData
{
    NSString *html = [[NSString alloc] initWithData:htmlData encoding:NSUTF8StringEncoding];
    //NSLog(@"%@", html);
    NSRegularExpression *pageNumOutRegex = [[NSRegularExpression alloc]
                                            initWithPattern:@"<table cellpadding=0 cellspacing=3 border=0 width=97% align=center><tr><td valign=middle nowrap>[\\s\\S]*?</table>"
                                            options:NSRegularExpressionCaseInsensitive
                                            error:nil];
    NSArray *pageNumOutArray = [pageNumOutRegex matchesInString:html options:0 range:NSMakeRange(0, html.length)];
    if (pageNumOutArray.count == 0) {
        NSLog(@"搜索到0处pageNumOut");
        return 0;
    }
    NSTextCheckingResult *pageNumOutResult = [pageNumOutArray objectAtIndex:0];
    NSString *pageNumOut = [html substringWithRange:pageNumOutResult.range];
    //NSLog(@"%@", pageNumOut);
    
    NSRegularExpression *pageNumRegex = [[NSRegularExpression alloc]
                                         initWithPattern:@"(?<=\\[)\\d+?(?=\\])"
                                         options:NSRegularExpressionCaseInsensitive
                                         error:nil];
    NSArray *pageNumArray = [pageNumRegex matchesInString:pageNumOut options:0 range:NSMakeRange(0, pageNumOut.length)];
    if (pageNumArray.count == 0) {
        NSLog(@"搜索到0处pageNum");
        return 0;
    }
    NSTextCheckingResult *pageNumResult = [pageNumArray objectAtIndex:pageNumArray.count-1];
    NSString *pageNum = [pageNumOut substringWithRange:pageNumResult.range];
    //NSLog(@"%@", pageNum);
    return [pageNum intValue];
}

-(NSString*)parseUserAvatarUrl:(NSData*)htmlData
{
    NSString *html = [[NSString alloc] initWithData:htmlData encoding:NSUTF8StringEncoding];
    NSRegularExpression *userAvatarRegex = [[NSRegularExpression alloc]
                                            initWithPattern:USER_PROFILE_AVATAR_REGEX
                                            options:NSRegularExpressionCaseInsensitive
                                            error:nil];
    NSRange userAvatarRange = [userAvatarRegex rangeOfFirstMatchInString:html options:0 range:NSMakeRange(0, html.length)];
    NSString *userAvatar = [html substringWithRange:userAvatarRange];
    return userAvatar;
}

@end
