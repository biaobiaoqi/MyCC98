//
//  CC98UrlManager.h
//  MyCC98
//
//  Created by Yan Chen on 1/27/13.
//  Copyright (c) 2013 YANN. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CC98UrlManager : NSObject

+(CC98UrlManager*)sharedInstance;

-(NSString*) getIndexPath;
-(NSString*) getLoginPath;
-(NSString*) getHotTopicPath;
-(NSString*) getUserProfilePath:(NSString*)userName;
-(NSString*) getBoardPathWithBoardId:(NSString*)boardId pageNum:(NSInteger)pageNum;
-(NSString*) getTopicPathWithBoardId:(NSString*)boardId topicId:(NSString*)topicId pageNum:(NSInteger)pageNum;
-(NSString*) getBoardStatPath;

@end
