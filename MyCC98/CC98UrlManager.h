//
//  CC98UrlManager.h
//  MyCC98
//
//  Created by Yan Chen on 1/18/13.
//  Copyright (c) 2013 Zhejiang University. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CC98UrlManager : NSObject

-(NSString*) getIndexPath;
-(NSString*) getLoginPath;
-(NSString*) getHotTopicPath;
-(NSString*) getUserProfilePath:(NSString*)userName;
-(NSString*) getBoardPathWithBoardId:(NSString*)boardId pageNum:(NSInteger)pageNum;
-(NSString*) getTopicPathWithBoardId:(NSString*)boardId topicId:(NSString*)topicId pageNum:(NSInteger)pageNum;

@end
