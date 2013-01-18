//
//  CC98Parser.m
//  MyCC98
//
//  Created by Yan Chen on 1/18/13.
//  Copyright (c) 2013 Zhejiang University. All rights reserved.
//

#import "CC98Parser.h"
#import "BoardEntity.h"
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
        
        BoardEntity *entity = [BoardEntity alloc];
        [entity setBoardName:boardName];
        [entity setBoardId:boardId];
        [entity setBoardInto:boardIntro];
        [entity setBoardMaster:boardMaster];
        [boardlist addObject:entity];
        
        //NSLog(@"%@ %@ %@ %@", boardName, boardId, boardIntro, boardMaster);
        
    }
    /*
    NSArray *boardInfoArray = [boardInfoRegex matchesInString:html options:0 range:NSMakeRange(0, html.length)];
    NSTextCheckingResult *boardInfoCheckingResult = boardInfoArray[0];
    NSString *boardInfo = [html substringWithRange:boardInfoCheckingResult.range];*/
    //NSLog(@"%@", boardInfo);
    
    
    return boardlist;
}

@end
