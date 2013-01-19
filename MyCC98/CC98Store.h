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

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@end
