//
//  CC98API.h
//  MyCC98
//
//  Created by Yan Chen on 11/21/12.
//  Copyright (c) 2012 VINCENT. All rights reserved.
//

#import "AFNetworking.h"

typedef void (^JSONResponseBlock)(NSDictionary* json);

@interface CC98API : AFHTTPClient

@property (strong, nonatomic) NSDictionary* user;

-(BOOL)isAuthorized;

-(void)index;
//-(void)commandWithParams:(NSMutableDictionary*)params onCompletion:(JSONResponseBlock)completionBlock;

+(CC98API*)sharedInstance;

@end
