//
//  CC98Store.h
//  MyCC98
//
//  Created by Yan Chen on 1/19/13.
//  Copyright (c) 2013 Zhejiang University. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CC98Store : NSObject

+(CC98Store*)sharedInstance;
-(void)updateHotTopic:(NSMutableArray*)array;
-(NSMutableArray*)getHotTopic;

-(void)updateCustomBoard:(NSMutableArray*)array;
-(NSMutableArray*)getCustomBoard;

-(void)updateTopicListWithEntity:(NSMutableArray*)array boardId:(NSString*)boardId pageNum:(NSInteger)pageNum;
-(NSMutableArray*)getTopicListWithBoardId:(NSString*)boardId pageNum:(NSInteger)pageNum;

-(void)updateCustomBoard:(NSString*)boardId withTotalPageNum:(NSInteger)pageNum;
-(NSInteger)getCustomBoardTotalPageNumWithBoardId:(NSString*)boardId;

-(NSMutableArray*)getPostListWithBoardId:(NSString*)boardId topicId:(NSString*)topicId pageNum:(NSInteger)pageNum;

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@end
