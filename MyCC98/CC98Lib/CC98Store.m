//
//  CC98Store.m
//  MyCC98
//
//  Created by Yan Chen on 1/27/13.
//  Copyright (c) 2013 YANN. All rights reserved.
//

#import "CC98Store.h"
#import "CCBoardEntity.h"
#import "CCTopicEntity.h"
#import "CCPostEntity.h"
#import "CCHotTopicEntity.h"

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

-(void)updateAllBoardList:(NSMutableArray*)array
{
    NSEntityDescription* entity = [NSEntityDescription entityForName:@"Boards" inManagedObjectContext:managedObjectContext];
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entity];
    
    NSError *error;
    NSArray *items = [managedObjectContext executeFetchRequest:request error:&error];
    
    for (NSManagedObject *managedObject in items) {
        [managedObjectContext deleteObject:managedObject];
    }
    [managedObjectContext save:&error];
    
    //add array
    for (CCBoardEntity *entity in array) {
        NSManagedObject *new = [NSEntityDescription insertNewObjectForEntityForName:@"Boards" inManagedObjectContext:managedObjectContext];
        [new setValue:entity.boardId forKey:@"boardId"];
        [new setValue:entity.boardName forKey:@"boardName"];
        [managedObjectContext save:&error];
    }

}

-(NSMutableArray*)getAllBoardList
{
    NSMutableArray *allBoard = [[NSMutableArray alloc] init];
    
    NSEntityDescription* entity = [NSEntityDescription entityForName:@"Boards" inManagedObjectContext:managedObjectContext];
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entity];
    
    //NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"run" ascending:NO];
    //NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    
    //[request setSortDescriptors:sortDescriptors];
    
    NSError *error;
    NSMutableArray *mutableFetchResults = [[managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
    
    if(mutableFetchResults) {
        for (NSManagedObject *result in mutableFetchResults) {
            CCBoardEntity *boardEntity = [CCBoardEntity alloc];
            boardEntity.boardId = [result valueForKey:@"boardId"];
            boardEntity.boardName = [result valueForKey:@"boardName"];
            [allBoard addObject:boardEntity];
        }
    }
    return allBoard;
}

-(void)updatePersonalBoardList:(NSMutableArray*)array
{
    NSEntityDescription* entity = [NSEntityDescription entityForName:@"Boards" inManagedObjectContext:managedObjectContext];
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entity];
    for (CCBoardEntity *boardEntity in array) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"boardId == %@", boardEntity.boardId];
        [request setPredicate:predicate];
        
        NSError *error;
        NSArray *items = [managedObjectContext executeFetchRequest:request error:&error];
        if (items.count == 1) {
            NSManagedObject *object = [items objectAtIndex:0];
            [object setValue:[NSNumber numberWithBool:YES] forKey:@"isPersonal"];
            if(![managedObjectContext save:&error])
            {
                NSLog(@"%@", error);
            }
        }
    }
}
-(NSMutableArray*)getPersonalBoardList
{
    NSMutableArray *personalBoard = [[NSMutableArray alloc] init];
    
    NSEntityDescription* entity = [NSEntityDescription entityForName:@"Boards" inManagedObjectContext:managedObjectContext];
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entity];
    
    //NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"run" ascending:NO];
    //NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    
    //[request setSortDescriptors:sortDescriptors];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"isPersonal == TRUE"];
    [request setPredicate:predicate];
    
    NSError *error;
    NSMutableArray *mutableFetchResults = [[managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
    
    if(mutableFetchResults) {
        for (NSManagedObject *result in mutableFetchResults) {
            CCBoardEntity *boardEntity = [CCBoardEntity alloc];
            boardEntity.boardId = [result valueForKey:@"boardId"];
            boardEntity.boardName = [result valueForKey:@"boardName"];
            [personalBoard addObject:boardEntity];
        }
    }
    return personalBoard;
}

-(void)updateTopicListWithEntity:(NSMutableArray*)array boardId:(NSString*)boardId pageNum:(NSInteger)pageNum
{
    NSError *error;
    //NSLog(@"pageNum: %d", pageNum);
    if (pageNum == 1) {
        //NSLog(@"deleting!");
        NSEntityDescription* entity = [NSEntityDescription entityForName:@"Topics" inManagedObjectContext:managedObjectContext];
        
        NSFetchRequest *request = [[NSFetchRequest alloc] init];
        [request setEntity:entity];
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"displayBoardId == %@", boardId];
        [request setPredicate:predicate];
        
        NSArray *items = [managedObjectContext executeFetchRequest:request error:&error];
        
        for (NSManagedObject *managedObject in items) {
            [managedObjectContext deleteObject:managedObject];
        }
        [managedObjectContext save:&error];
    }
    
    //add array
    for (CCTopicEntity *entity in array) {
        NSManagedObject *new = [NSEntityDescription insertNewObjectForEntityForName:@"Topics" inManagedObjectContext:managedObjectContext];
        [new setValue:entity.topicId forKey:@"topicId"];
        [new setValue:entity.topicName forKey:@"topicName"];
        [new setValue:entity.topicAuthor forKey:@"topicAuthor"];
        [new setValue:entity.replyNum forKey:@"replyNum"];
        [new setValue:entity.boardId forKey:@"boardId"];
        [new setValue:entity.lastReplyAuthor forKey:@"lastReplyAuthor"];
        [new setValue:[NSNumber numberWithInteger:pageNum] forKey:@"pageNum"];
        [new setValue:boardId forKey:@"displayBoardId"];
        [managedObjectContext save:&error];
    }
}


-(NSMutableArray*)getTopicListWithBoardId:(NSString*)boardId
{
    NSMutableArray *topiclist = [[NSMutableArray alloc] init];
    
    NSEntityDescription* entity = [NSEntityDescription entityForName:@"Topics" inManagedObjectContext:managedObjectContext];
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entity];
    
    //NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"run" ascending:NO];
    //NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    
    //[request setSortDescriptors:sortDescriptors];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"displayBoardId == %@", boardId];
    [request setPredicate:predicate];
    
    NSError *error;
    NSMutableArray *mutableFetchResults = [[managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
    
    if(mutableFetchResults) {
        for (NSManagedObject *result in mutableFetchResults) {
            CCTopicEntity *topicEntity = [CCTopicEntity alloc];
            topicEntity.topicId = [result valueForKey:@"topicId"];
            topicEntity.topicName = [result valueForKey:@"topicName"];
            topicEntity.boardId = [result valueForKey:@"boardId"];
            topicEntity.topicAuthor = [result valueForKey:@"topicAuthor"];
            topicEntity.replyNum = [result valueForKey:@"replyNum"];
            topicEntity.lastReplyAuthor = [result valueForKey:@"lastReplyAuthor"];
            [topiclist addObject:topicEntity];
        }
    }
    return topiclist;
}

-(NSInteger)getTopicListMaxPageNumWithBoardId:(NSString*)boardId
{
    NSInteger num = 0;
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription* entity = [NSEntityDescription entityForName:@"Topics" inManagedObjectContext:managedObjectContext];
    [request setEntity:entity];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"displayBoardId == %@", boardId];
    [request setPredicate:predicate];
    
    // Specify that the request should return dictionaries.
    [request setResultType:NSDictionaryResultType];
    
    // Create an expression for the key path.
    NSExpression *keyPathExpression = [NSExpression expressionForKeyPath:@"pageNum"];
    
    // Create an expression to represent the maximum value at the key path 'creationDate'
    NSExpression *maxExpression = [NSExpression expressionForFunction:@"max:" arguments:[NSArray arrayWithObject:keyPathExpression]];
    
    // Create an expression description using the maxExpression and returning a date.
    NSExpressionDescription *expressionDescription = [[NSExpressionDescription alloc] init];
    
    // The name is the key that will be used in the dictionary for the return value.
    [expressionDescription setName:@"maxPageNum"];
    [expressionDescription setExpression:maxExpression];
    [expressionDescription setExpressionResultType:NSInteger16AttributeType];
    
    // Set the request's properties to fetch just the property represented by the expressions.
    [request setPropertiesToFetch:[NSArray arrayWithObject:expressionDescription]];
    
    // Execute the fetch.
    NSError *error = nil;
    NSArray *objects = [managedObjectContext executeFetchRequest:request error:&error];
    if (objects == nil) {
        // Handle the error.
    }
    else {
        if ([objects count] > 0) {
            num = [[[objects objectAtIndex:0] valueForKey:@"maxPageNum"] intValue];
        }
    }
    return num;
}

-(void)updatePostListWithEntity:(NSMutableArray*)array topicId:(NSString*)topicId pageNum:(NSInteger)pageNum
{
    NSError *error;
    if (pageNum == 1) {
        NSEntityDescription* entity = [NSEntityDescription entityForName:@"Posts" inManagedObjectContext:managedObjectContext];
        
        NSFetchRequest *request = [[NSFetchRequest alloc] init];
        [request setEntity:entity];
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"topicId == %@", topicId];
        [request setPredicate:predicate];
        
        NSArray *items = [managedObjectContext executeFetchRequest:request error:&error];
        
        for (NSManagedObject *managedObject in items) {
            [managedObjectContext deleteObject:managedObject];
        }
        [managedObjectContext save:&error];
    }
    
    //add array
    for (CCPostEntity *entity in array) {
        /*NSEntityDescription* en = [NSEntityDescription entityForName:@"Posts" inManagedObjectContext:managedObjectContext];
        
        NSFetchRequest *request = [[NSFetchRequest alloc] init];
        [request setEntity:en];
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"postId == %@", entity.postId];
        [request setPredicate:predicate];
        
        NSArray *items = [managedObjectContext executeFetchRequest:request error:&error];
        
        for (NSManagedObject *managedObject in items) {
            [managedObjectContext deleteObject:managedObject];
        }*/

        
        
        NSManagedObject *new = [NSEntityDescription insertNewObjectForEntityForName:@"Posts" inManagedObjectContext:managedObjectContext];
        [new setValue:entity.postId forKey:@"postId"];
        [new setValue:entity.postTitle forKey:@"postTitle"];
        [new setValue:entity.postContent forKey:@"postContent"];
        [new setValue:entity.postAuthor forKey:@"postAuthor"];
        [new setValue:topicId forKey:@"topicId"];
        [new setValue:[NSNumber numberWithInteger:pageNum] forKey:@"pageNum"];
        [new setValue:entity.postTime forKey:@"postTime"];
        [new setValue:[NSNumber numberWithInteger:entity.bm] forKey:@"bm"];
        [new setValue:entity.replyId forKey:@"replyId"];
        
        [managedObjectContext save:&error];
    }
}

-(NSMutableArray*)getPostListWithTopicId:(NSString*)topicId
{
    NSMutableArray *postlist = [[NSMutableArray alloc] init];
    
    NSEntityDescription* entity = [NSEntityDescription entityForName:@"Posts" inManagedObjectContext:managedObjectContext];
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entity];
    
    //NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"run" ascending:NO];
    //NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    
    //[request setSortDescriptors:sortDescriptors];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"topicId == %@", topicId];
    [request setPredicate:predicate];
    
    NSError *error;
    NSMutableArray *mutableFetchResults = [[managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
    
    if(mutableFetchResults) {
        for (NSManagedObject *result in mutableFetchResults) {
            CCPostEntity *postEntity = [CCPostEntity alloc];
            postEntity.postId = [result valueForKey:@"postId"];
            postEntity.postTitle = [result valueForKey:@"postTitle"];
            postEntity.postContent = [result valueForKey:@"postContent"];
            postEntity.postAuthor = [result valueForKey:@"postAuthor"];
            postEntity.bm = [[result valueForKey:@"bm"] intValue];
            postEntity.replyId = [result valueForKey:@"replyId"];
            postEntity.postTime = [result valueForKey:@"postTime"];
            [postlist addObject:postEntity];
        }
    }
    return postlist;
}

-(NSInteger)getPostListMaxPageNumWithTopicId:(NSString*)topicId
{
    NSInteger num = 0;
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription* entity = [NSEntityDescription entityForName:@"Posts" inManagedObjectContext:managedObjectContext];
    [request setEntity:entity];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"topicId == %@", topicId];
    [request setPredicate:predicate];
    
    // Specify that the request should return dictionaries.
    [request setResultType:NSDictionaryResultType];
    
    // Create an expression for the key path.
    NSExpression *keyPathExpression = [NSExpression expressionForKeyPath:@"pageNum"];
    
    // Create an expression to represent the maximum value at the key path 'creationDate'
    NSExpression *maxExpression = [NSExpression expressionForFunction:@"max:" arguments:[NSArray arrayWithObject:keyPathExpression]];
    
    // Create an expression description using the maxExpression and returning a date.
    NSExpressionDescription *expressionDescription = [[NSExpressionDescription alloc] init];
    
    // The name is the key that will be used in the dictionary for the return value.
    [expressionDescription setName:@"maxPageNum"];
    [expressionDescription setExpression:maxExpression];
    [expressionDescription setExpressionResultType:NSInteger16AttributeType];
    
    // Set the request's properties to fetch just the property represented by the expressions.
    [request setPropertiesToFetch:[NSArray arrayWithObject:expressionDescription]];
    
    // Execute the fetch.
    NSError *error = nil;
    NSArray *objects = [managedObjectContext executeFetchRequest:request error:&error];
    if (objects == nil) {
        // Handle the error.
    }
    else {
        if ([objects count] > 0) {
            num = [[[objects objectAtIndex:0] valueForKey:@"maxPageNum"] intValue];
        }
    }
    return num;
}

-(NSInteger)getPostListLastUpdateNumWithTopicId:(NSString*)topicId
{
    NSInteger maxPage = [self getPostListMaxPageNumWithTopicId:topicId];
    //NSLog(@"maxpage:%d", maxPage);
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription* entity = [NSEntityDescription entityForName:@"Posts" inManagedObjectContext:managedObjectContext];
    [request setEntity:entity];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"topicId == %@ && pageNum == %d",topicId,  maxPage];
    [request setPredicate:predicate];
    
    NSError *error = nil;
    NSUInteger num = [managedObjectContext countForFetchRequest:request error:&error];
    //NSLog(@"nummm: %d", num);
    return num;
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
    for (CCHotTopicEntity *entity in array) {
        NSManagedObject *new = [NSEntityDescription insertNewObjectForEntityForName:@"HotTopics" inManagedObjectContext:managedObjectContext];
        [new setValue:entity.topicName forKey:@"topicName"];
        [new setValue:entity.topicId forKey:@"topicId"];
        [new setValue:entity.boardId forKey:@"boardId"];
        [new setValue:entity.boardName forKey:@"boardName"];
        [new setValue:entity.postAuthor forKey:@"postAuthor"];
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
            CCHotTopicEntity *topicEntity = [CCHotTopicEntity alloc];
            topicEntity.topicName = [result valueForKey:@"topicName"];
            topicEntity.topicId = [result valueForKey:@"topicId"];
            topicEntity.boardId = [result valueForKey:@"boardId"];
            topicEntity.boardName = [result valueForKey:@"boardName"];
            topicEntity.postAuthor = [result valueForKey:@"postAuthor"];
            //NSLog(@"%@", [result valueForKey:@"topicName"]);
            [hottopic addObject:topicEntity];
        }
    }
    //NSLog(@"%@", hottopic);
    return hottopic;
}

@end
