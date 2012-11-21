//
//  CC98API.m
//  MyCC98
//
//  Created by Yan Chen on 11/21/12.
//  Copyright (c) 2012 VINCENT. All rights reserved.
//

#import "CC98API.h"

#define kAPIHost @"http://www.cc98.org"

@implementation CC98API

@synthesize user;

#pragma mark - Singleton methods
/**
 * Singleton methods
 */
+(CC98API*)sharedInstance
{
    static CC98API *sharedInstance = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        sharedInstance = [[self alloc] initWithBaseURL:[NSURL URLWithString:kAPIHost]];
    });
    
    return sharedInstance;
}


#pragma mark - init
//intialize the API class with the destination host name
-(CC98API*)init
{
    //call super init
    self = [super init];
    
    if (self != nil) {
        //initialize the object
        user = nil;
        
        [self registerHTTPOperationClass:[AFHTTPRequestOperation class]];
        
        [self setDefaultHeader:@"Accept" value:@"text/http"];
    }
    
    return self;
}

-(BOOL)isAuthorized
{
    return [[user objectForKey:@"IdUser"] intValue] > 0;
}

-(void)login
{
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            @"a", @"i",
                            @"u", @"348191",
                            @"p", @"69ad7dfbd3684e8d",
                            @"userhidden", @"2",
                            nil];
    
    NSMutableURLRequest *loginRequest = [self multipartFormRequestWithMethod:@"POST" path:@"/sign.asp" parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        //
    }];
    AFHTTPRequestOperation* operation = [[AFHTTPRequestOperation alloc] initWithRequest:loginRequest];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *aString = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSLog(@"%@",aString);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Failure");
    }];
    [operation start];
}

-(void)index
{
    NSMutableURLRequest *apiRequest = [self requestWithMethod:@"GET" path:@"/" parameters:nil];
    AFHTTPRequestOperation* operation = [[AFHTTPRequestOperation alloc] initWithRequest:apiRequest];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *aString = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSLog(@"%@",aString);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Failure");
    }];
    
    [operation start];
}
//-(void)commandWithParams:(NSMutableDictionary*)params onCompletion:(JSONResponseBlock)completionBlock
//{
//    NSMutableURLRequest *apiRequest =
//    [self multipartFormRequestWithMethod:@"POST"
//                                    path:kAPIPath
//                              parameters:params
//               constructingBodyWithBlock: ^(id formData) {
//                   //TODO: attach file if needed
//               }];
//    
//    AFJSONRequestOperation* operation = [[AFJSONRequestOperation alloc] initWithRequest: apiRequest];
//    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
//        //success!
//        completionBlock(responseObject);
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        //failure
//        completionBlock([NSDictionary dictionaryWithObject:[error localizedDescription] forKey:@"error"]);
//    }];
//    
//    [operation start];
//}



@end
