//
//  CC98Store.m
//  MyCC98
//
//  Created by Yan Chen on 1/19/13.
//  Copyright (c) 2013 Zhejiang University. All rights reserved.
//

#import "CC98Store.h"
#import "HotTopicEntity.h"

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
            //NSLog(@"%@", [result valueForKey:@"topicName"]);
            [hottopic addObject:[result valueForKey:@"topicName"]];
        }
    }
    //NSLog(@"%@", hottopic);
    return hottopic;
}

@end
