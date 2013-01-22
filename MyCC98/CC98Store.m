//
//  CC98Store.m
//  MyCC98
//
//  Created by Yan Chen on 1/19/13.
//  Copyright (c) 2013 Zhejiang University. All rights reserved.
//

#import "CC98Store.h"
#import "HotTopicEntity.h"
#import "BoardEntity.h"
#import "TopicEntity.h"

@implementation CC98Store
@synthesize managedObjectContext;

#pragma mark - Singleton methods
/**
 * Singleton methods
 */
+(CC98Store*)sharedInstance
{
    static CC98Store *sharedInstance = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        sharedInstance = [[self alloc] init];
    });
    
    return sharedInstance;
}

-(void)updateHotTopic:(NSMutableArray*)array
{
    //delete all
    NSEntityDescription* entity = [NSEntityDescription entityForName:@"HotTopics" inManagedObjectContext:managedObjectContext];
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entity];
    
    NSError *error;
    NSArray *items = [managedObjectContext executeFetchRequest:request error:&error];
    
    for (NSManagedObject *managedObject in items) {
        [managedObjectContext deleteObject:managedObject];
    }
    [managedObjectContext save:&error];
    
    //add array
    for (HotTopicEntity *entity in array) {
        NSManagedObject *new = [NSEntityDescription insertNewObjectForEntityForName:@"HotTopics" inManagedObjectContext:managedObjectContext];
        [new setValue:[entity getTopicName] forKey:@"topicName"];
        [new setValue:[entity getPostId] forKey:@"postId"];
        [managedObjectContext save:&error];
    }
    
}

-(NSMutableArray*)getHotTopic
{
    NSMutableArray *hottopic = [[NSMutableArray alloc] init];
    
    NSEntityDescription* entity = [NSEntityDescription entityForName:@"HotTopics" inManagedObjectContext:managedObjectContext];
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entity];
    
    //NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"run" ascending:NO];
    //NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    
    //[request setSortDescriptors:sortDescriptors];
    
    NSError *error;
    NSMutableArray *mutableFetchResults = [[managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
    
    if(mutableFetchResults) {
        for (NSManagedObject *result in mutableFetchResults) {
            HotTopicEntity *topicEntity = [HotTopicEntity alloc];
            [topicEntity setTopicName:[result valueForKey:@"topicName"]];
            [topicEntity setPostId:[result valueForKey:@"postId"]];
            //NSLog(@"%@", [result valueForKey:@"topicName"]);
            [hottopic addObject:topicEntity];
        }
    }
    //NSLog(@"%@", hottopic);
    return hottopic;
}

-(void)updateCustomBoard:(NSMutableArray*)array
{
    //delete all
    NSEntityDescription* entity = [NSEntityDescription entityForName:@"CustomBoard" inManagedObjectContext:managedObjectContext];
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entity];
    
    NSError *error;
    NSArray *items = [managedObjectContext executeFetchRequest:request error:&error];
    
    for (NSManagedObject *managedObject in items) {
        [managedObjectContext deleteObject:managedObject];
    }
    [managedObjectContext save:&error];
    
    //add array
    for (BoardEntity *entity in array) {
        NSManagedObject *new = [NSEntityDescription insertNewObjectForEntityForName:@"CustomBoard" inManagedObjectContext:managedObjectContext];
        [new setValue:[entity getBoardName] forKey:@"boardName"];
        [new setValue:[entity getBoardId] forKey:@"boardId"];
        [new setValue:[entity getBoardIntro] forKey:@"boardIntro"];
        [new setValue:[NSNumber numberWithInteger:[entity getPostNumberToday]] forKey:@"postNumberToday"];
        [new setValue:[entity getLastReplyAuthor] forKey:@"lastReplyAuthor"];
        [new setValue:[entity getLastReplyTime] forKey:@"lastReplyTime"];
        [managedObjectContext save:&error];
    }
}
-(NSMutableArray*)getCustomBoard
{
    NSMutableArray *customboard = [[NSMutableArray alloc] init];
    
    NSEntityDescription* entity = [NSEntityDescription entityForName:@"CustomBoard" inManagedObjectContext:managedObjectContext];
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entity];
    
    //NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"run" ascending:NO];
    //NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    
    //[request setSortDescriptors:sortDescriptors];
    
    NSError *error;
    NSMutableArray *mutableFetchResults = [[managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
    
    if(mutableFetchResults) {
        for (NSManagedObject *result in mutableFetchResults) {
            BoardEntity *boardEntity = [BoardEntity alloc];
            [boardEntity setBoardName:[result valueForKey:@"boardName"]];
            [boardEntity setBoardId:[result valueForKey:@"boardId"]];
            [boardEntity setBoardInto:[result valueForKey:@"boardIntro"]];
            [boardEntity setPostNumberToday:[[result valueForKey:@"postNumberToday"] intValue]];
            [boardEntity setLastReplyAuthor:[result valueForKey:@"lastReplyAuthor"]];
            [boardEntity setLastReplyTime:[result valueForKey:@"lastReplyTime"]];
            //NSLog(@"%@", [result valueForKey:@"lastReplyTime"]);
            [customboard addObject:boardEntity];
        }
    }
    //NSLog(@"%@", hottopic);
    return customboard;
}

-(void)updateTopicListWithEntity:(NSMutableArray*)array boardId:(NSString*)boardId pageNum:(NSInteger)pageNum
{
    //if the page is empty in db, just insert instead of delete before insert
    //if the page is not empty, delete all topics in this board and then insert
    NSEntityDescription* entity = [NSEntityDescription entityForName:@"Topics" inManagedObjectContext:managedObjectContext];
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entity];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"displayBoardId == %@ && displayPageNum == %d", boardId, pageNum];
    [request setPredicate:predicate];
    
    NSError *error;
    NSArray *items = [managedObjectContext executeFetchRequest:request error:&error];
    //NSLog(@"%d", items.count);
    if (items.count != 0) {
        NSPredicate *predicate1 = [NSPredicate predicateWithFormat:@"displayBoardId == %@", boardId];
        [request setPredicate:predicate1];
        
        //NSError *error;
        NSArray *items1 = [managedObjectContext executeFetchRequest:request error:&error];
        
        for (NSManagedObject *managedObject in items1) {
            [managedObjectContext deleteObject:managedObject];
        }
        if(![managedObjectContext save:&error])
        {
            NSLog(@"%@", error);
        }
    }
    
    
    //add array
    //NSLog(@"%d", array.count);
    for (TopicEntity *entity in array) {
        NSManagedObject *new = [NSEntityDescription insertNewObjectForEntityForName:@"Topics" inManagedObjectContext:managedObjectContext];
        [new setValue:entity.topicName forKey:@"topicName"];
        [new setValue:entity.topicId forKey:@"topicId"];
        [new setValue:entity.boardId forKey:@"boardId"];
        [new setValue:[NSNumber numberWithInteger:entity.topicPageNum] forKey:@"topicPageNum"];
        [new setValue:entity.topicAuthor forKey:@"topicAuthor"];
        [new setValue:entity.lastReplyAuthor forKey:@"lastReplyAuthor"];
        [new setValue:entity.replyNum forKey:@"replyNum"];
        [new setValue:[NSNumber numberWithInteger:pageNum] forKey:@"displayPageNum"];
        [new setValue:boardId forKey:@"displayBoardId"];
        if(![managedObjectContext save:&error])
        {
            NSLog(@"%@", error);
        }
    }
}

-(NSMutableArray*)getTopicListWithBoardId:(NSString*)boardId pageNum:(NSInteger)pageNum
{
    NSMutableArray *topiclist = [[NSMutableArray alloc] init];
    
    NSEntityDescription* entity = [NSEntityDescription entityForName:@"Topics" inManagedObjectContext:managedObjectContext];
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entity];
    
    //NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"run" ascending:NO];
    //NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    
    //[request setSortDescriptors:sortDescriptors];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"displayBoardId == %@ && displayPageNum == %d", boardId, pageNum];
    [request setPredicate:predicate];
    
    NSError *error;
    NSMutableArray *mutableFetchResults = [[managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
    //NSLog(@"%d", mutableFetchResults.count);
    if(mutableFetchResults) {
        for (NSManagedObject *result in mutableFetchResults) {
            TopicEntity *entity = [TopicEntity alloc];
            entity.topicName = [result valueForKey:@"topicName"];
            entity.topicId = [result valueForKey:@"topicId"];
            entity.boardId = [result valueForKey:@"boardId"];
            entity.topicAuthor = [result valueForKey:@"topicAuthor"];
            entity.topicPageNum = [[result valueForKey:@"topicPageNum"] intValue];
            entity.lastReplyAuthor = [result valueForKey:@"lastReplyAuthor"];
            entity.replyNum = [result valueForKey:@"replyNum"];
            //NSLog(@"%@", entity.topicAuthor);
            [topiclist addObject:entity];
        }
    }
    //NSLog(@"%@", hottopic);
    return topiclist;
}

-(void)updateCustomBoard:(NSString*)boardId withTotalPageNum:(NSInteger)pageNum
{
    NSEntityDescription* entity = [NSEntityDescription entityForName:@"CustomBoard" inManagedObjectContext:managedObjectContext];
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entity];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"boardId == %@", boardId];
    [request setPredicate:predicate];
    
    NSError *error;
    NSArray *items = [managedObjectContext executeFetchRequest:request error:&error];
    if (items.count == 1) {
        NSManagedObject *object = [items objectAtIndex:0];
        [object setValue:[NSNumber numberWithInteger:pageNum] forKey:@"totalPageNum"];
        if(![managedObjectContext save:&error])
        {
            NSLog(@"%@", error);
        }
    }
}
-(NSInteger)getCustomBoardTotalPageNumWithBoardId:(NSString*)boardId
{
    NSEntityDescription* entity = [NSEntityDescription entityForName:@"CustomBoard" inManagedObjectContext:managedObjectContext];
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entity];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"boardId == %@", boardId];
    [request setPredicate:predicate];
    
    NSError *error;
    NSArray *items = [managedObjectContext executeFetchRequest:request error:&error];
    if (items.count == 1) {
        NSManagedObject *object = [items objectAtIndex:0];
        return [[object valueForKey:@"totalPageNum"] intValue];
    }
    else {
        return 11111;
    }
}

-(NSMutableArray*)getPostListWithBoardId:(NSString*)boardId topicId:(NSString*)topicId pageNum:(NSInteger)pageNum
{
    return nil;
}

@end
