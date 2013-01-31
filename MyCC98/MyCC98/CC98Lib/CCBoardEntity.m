//
//  CCBoardEntity.m
//  MyCC98
//
//  Created by Yan Chen on 1/26/13.
//  Copyright (c) 2013 YANN. All rights reserved.
//

#import "CCBoardEntity.h"

@implementation CCBoardEntity

+ (id)boardWithId:(NSString *)i name:(NSString *)n
{
    CCBoardEntity *board = [[CCBoardEntity alloc] init];
    board.boardId = i;
    board.boardName = n;
    return board;
}

@end
