//
//  CCBoardEntity.h
//  MyCC98
//
//  Created by Yan Chen on 1/26/13.
//  Copyright (c) 2013 YANN. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CCBoardEntity : NSObject

@property(nonatomic, retain) NSString *boardId;
@property(nonatomic, retain) NSString *boardName;

+ (id)boardWithId:(NSString *)i name:(NSString *)n;

@end
