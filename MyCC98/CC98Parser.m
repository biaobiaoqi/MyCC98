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

@end
