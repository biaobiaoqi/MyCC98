//
//  CC98Store.h
//  MyCC98
//
//  Created by Yan Chen on 1/27/13.
//  Copyright (c) 2013 YANN. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CC98Store : NSObject

+(CC98Store*)sharedInstance;

-(void)updateAllBoardList:(NSMutableArray*)array;
-(NSMutableArray*)getAllBoardList;

-(void)updatePersonalBoardList:(NSMutableArray*)array;
-(NSMutableArray*)getPersonalBoardList;

-(void)updateTopicListWithEntity:(NSMutableArray*)array boardId:(NSString*)boardId pageNum:(NSInteger)pageNum;
-(NSMutableArray*)getTopicListWithBoardId:(NSString*)boardId;
-(NSInteger)getTopicListMaxPageNumWithBoardId:(NSString*)boardId;

-(void)updatePostListWithEntity:(NSMutableArray*)array topicId:(NSString*)topicId pageNum:(NSInteger)pageNum;
-(NSMutableArray*)getPostListWithTopicId:(NSString*)topicId;
-(NSInteger)getPostListMaxPageNumWithTopicId:(NSString*)topicId;
-(NSInteger)getPostListLastUpdateNumWithTopicId:(NSString*)topicId;

-(void)updateHotTopic:(NSMutableArray*)array;
-(NSMutableArray*)getHotTopic;

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@end
