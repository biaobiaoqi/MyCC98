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
-(NSMutableArray*)parseTopicList:(NSData*)htmlData;
-(NSMutableArray*)parsePostList:(NSData*)htmlData;


@end
