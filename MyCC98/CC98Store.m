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

/*-(void)storeImageFile:(NSData*)data withUrl:(NSString*)url
{
    NSError *error;
    NSManagedObject *new = [NSEntityDescription insertNewObjectForEntityForName:@"Images" inManagedObjectContext:managedObjectContext];
    [new setValue:data forKey:@"image"];
    [new setValue:url forKey:@"url"];
    [managedObjectContext save:&error];
}
-(NSData*)fetchImageFileWithUrl:(NSString*)url
{
    NSEntityDescription *imageEntity = [NSEntityDescription entityForName:@"Images" inManagedObjectContext:self.managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:imageEntity];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"url == %@", url];
    [fetchRequest setPredicate:predicate];
    NSError *error;
    NSMutableArray *mutableFetchResults = [[managedObjectContext executeFetchRequest:fetchRequest error:&error] mutableCopy];
    if (mutableFetchResults) {
        NSManagedObject *result = [mutableFetchResults objectAtIndex:0];
        NSData *data = [result valueForKey:@"image"];
        return data;
    }
    else {
        return nil;
    }
}*/



@end
