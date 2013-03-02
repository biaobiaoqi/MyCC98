//
//  CC98Parser.h
//  MyCC98
//
//  Created by Yan Chen on 1/27/13.
//  Copyright (c) 2013 YANN. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CC98Parser : NSObject

+(CC98Parser*)sharedInstance;

-(NSMutableArray*)parseAllBoardList:(NSData*)html;
-(NSMutableArray*)parsePersonalBoardList:(NSData*)htmlData;
-(NSMutableArray*)parseTopicList:(NSData*)htmlData boardId:(NSString*)boardId;
-(NSInteger)parseTotalPageNumInTopicList:(NSData*)htmlData;
-(NSMutableArray*)parsePostList:(NSData*)htmlData boardId:(NSString*)boardId;
-(NSInteger)parseTotalPageNumInPostList:(NSData*)htmlData;
-(NSString*)parseUserAvatarUrl:(NSData*)htmlData;
-(NSMutableArray*)parseHottopicList:(NSData*)htmlData;

@end
