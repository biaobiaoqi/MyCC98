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
#import "CCHotTopicEntity.h"
#import "NSString+CCStringUtil.h"

#import "CCRegexParser.h"
#import "CC98Regex.h"

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


-(NSMutableArray*)parseAllBoardList:(NSData*)htmlData
{
    NSMutableArray *boardlist = [[NSMutableArray alloc] init];
    NSString *html = [[NSString alloc] initWithData:htmlData encoding:NSUTF8StringEncoding];
    html = [CCRegexParser removeBlankInString:html];
    NSArray *contentList = [CCRegexParser matchesInString:html Regex:TODAY_BOARD_ENTITY_REGEX];
    
    for (NSString *string in contentList) {
        CCBoardEntity *entity = [CCBoardEntity alloc];
        entity.boardId = [CCRegexParser firstMatchInString:string Regex:TODAY_BOARD_ID_REGEX];
        entity.boardName = [CCRegexParser firstMatchInString:string Regex:TODAY_BOARD_NAME_REGEX];
        [boardlist addObject:entity];
    }
    
    return boardlist;
}

-(NSMutableArray*)parsePersonalBoardList:(NSData*)htmlData
{
    NSMutableArray *boardlist = [[NSMutableArray alloc] init];
    NSString *html = [[NSString alloc] initWithData:htmlData encoding:NSUTF8StringEncoding];
    html = [CCRegexParser removeBlankInString:html];
    NSArray *board = [CCRegexParser matchesInString:html Regex:P_BOARD_SINGLE_BOARD_WRAPPER_REGEX];
    
    for (NSString *string in board) {
        CCBoardEntity *entity = [CCBoardEntity alloc];
        entity.boardId = [CCRegexParser firstMatchInString:string Regex:P_BOARD_ID_REGEX];
        entity.boardName = [[CCRegexParser firstMatchInString:string Regex:P_BOARD_NAME_REGEX] stringByDecodingHTMLEntities];
        [boardlist addObject:entity];
    }
    
    return boardlist;
}

-(NSMutableArray*)parseTopicList:(NSData*)htmlData boardId:(NSString*)boardId
{
    //NSLog(@"I'm here!");
    NSString *html = [[NSString alloc] initWithData:htmlData encoding:NSUTF8StringEncoding];
    NSMutableArray *topiclist = [[NSMutableArray alloc] init];
    TFHpple *parser = [TFHpple hppleWithHTMLData:htmlData];
    
    NSArray *topicNameArray = [parser searchWithXPathQuery:@"//html/body/form[@name='batch']/table/tbody/tr[position()>2]/td[position()=2]/a/span"];
    NSArray *replyNumArray = [parser searchWithXPathQuery:@"//html/body/form[@name='batch']/table/tbody/tr[position()>2]/td[position()=4]"];
    
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
    NSLog(@"======%d", postListArray.count);
    
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
        //NSLog(@"topicId:%@", topicId);
        
        NSString *topicAuthor;
        if ([boardId isEqual: @"182"]) {
            topicAuthor = @"匿名";
        } else {
            NSRegularExpression *topicAuthorRegex = [[NSRegularExpression alloc]
                                                 initWithPattern:POST_LIST_POST_AUTHOR_NAME_REGEX
                                                 options:NSRegularExpressionCaseInsensitive
                                                 error:nil];
            NSRange topicAuthorRange = [topicAuthorRegex rangeOfFirstMatchInString:topic options:0 range:NSMakeRange(0, topic.length)];
            topicAuthor = [topic substringWithRange:topicAuthorRange];
        }
        //NSLog(@"topicAuthor:%@", topicAuthor);
        
        NSRegularExpression *lastReplyAuthorRegex = [[NSRegularExpression alloc]
                                                     initWithPattern:POST_LIST_LAST_REPLY_AUTHOR_REGEX
                                                     options:NSRegularExpressionCaseInsensitive
                                                     error:nil];
        NSRange lastReplyAuthorRange = [lastReplyAuthorRegex rangeOfFirstMatchInString:topic options:0 range:NSMakeRange(0, topic.length)];
        NSString *lastReplyAuthor = [topic substringWithRange:lastReplyAuthorRange];
        //NSLog(@"1");
        
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
        //NSLog(@"1");
        
        NSRegularExpression *boardIdRegex = [[NSRegularExpression alloc]
                                             initWithPattern:POST_LIST_POST_BOARD_ID_REGEX
                                             options:NSRegularExpressionCaseInsensitive
                                             error:nil];
        NSRange boardIdRange = [boardIdRegex rangeOfFirstMatchInString:topic options:0 range:NSMakeRange(0, topic.length)];
        NSString *boardId = [topic substringWithRange:boardIdRange];
        //NSLog(@"1");
        
        
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


-(NSMutableArray*)parsePostList:(NSData*)htmlData boardId:(NSString*)boardId
{
    NSMutableArray *postlist = [[NSMutableArray alloc] init];
    
    TFHpple *parser = [TFHpple hppleWithHTMLData:htmlData];
    
    NSArray *PostContentArray = [parser searchWithXPathQuery:@"//html/body/table[@cellpadding='5']/tbody/tr[position()=1]/td[position()=2]/blockquote/table/tr/td/span"];
    NSArray *PostAuthorArray;
    NSArray *PostBmArray;
    if ([boardId isEqual: @"182"]) {
        PostAuthorArray = [parser searchWithXPathQuery:@"//html/body/table[@cellpadding='5']/tbody/tr[position()=1]/td[position()=1]/table/tr[position()=1]/td[position()=1]/span/b"];
        PostBmArray = [parser searchWithXPathQuery:@"//html/body/table[@cellpadding='5']/tbody/tr[position()=1]/td[position()=2]/table/tr[position()=1]/td[position()=1]/a[position()=2]"];
    } else {
        PostAuthorArray = [parser searchWithXPathQuery:@"//html/body/table[@cellpadding='5']/tbody/tr[position()=1]/td[position()=1]/table/tr[position()=1]/td[position()=1]/a/span/b"];
        PostBmArray = [parser searchWithXPathQuery:@"//html/body/table[@cellpadding='5']/tbody/tr[position()=1]/td[position()=2]/table/tr[position()=1]/td[position()=1]/a[position()=5]"];
    }
    
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
        
        entity.postAuthor = [[[PostAuthorArray objectAtIndex:i] firstChild] content];
        
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
    
    NSArray *postInfoList = [CCRegexParser matchesInString:html Regex:POST_CONTENT_INFO_REGEX];
    
    return ceil([[postInfoList objectAtIndex:2] intValue]/10.0);
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

-(NSMutableArray*)parseHottopicList:(NSData*)htmlData
{
    NSMutableArray *hottopiclist = [[NSMutableArray alloc] init];
    NSString *html = [[NSString alloc] initWithData:htmlData encoding:NSUTF8StringEncoding];
    html = [CCRegexParser removeBlankInString:html];
    NSArray *topicList = [CCRegexParser matchesInString:html Regex:HOT_TOPIC_WRAPPER];
    
    for (NSString *topic in topicList) {
        CCHotTopicEntity *entity = [CCHotTopicEntity alloc];
        entity.topicName = [CCRegexParser firstMatchInString:topic Regex:HOT_TOPIC_NAME_REGEX];
        entity.topicId = [CCRegexParser firstMatchInString:topic Regex:HOT_TOPIC_ID_REGEX];
        entity.boardId = [CCRegexParser firstMatchInString:topic Regex:HOT_TOPIC_BOARD_ID_REGEX];
        
        NSArray *bList = [CCRegexParser matchesInString:topic Regex:HOT_TOPIC_BOARD_NAME_WITH_AUTHOR_REGEX];
        entity.boardName = [bList objectAtIndex:0];
        if (bList.count < 2) {
            entity.postAuthor = @"匿名";
        } else {
            entity.postAuthor = [bList objectAtIndex:1];
        }
        
        [hottopiclist addObject:entity];
    }
    //NSLog(@"%@", topicList);
    
    
    return hottopiclist;
}

@end
