//
//  CC98API.h
//  MyCC98
//
//  Created by Yan Chen on 1/27/13.
//  Copyright (c) 2013 YANN. All rights reserved.
//

#import "AFHTTPClient.h"

@interface CC98API : AFHTTPClient
{
    NSString* cpath;
    NSString* key;
}

+(CC98API*)sharedInstance;
-(void)setRVPN:(BOOL)value key:(NSString*)rvpnkey;
- (void)loginWithData:(NSDictionary*)loginData
        success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
        failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;
- (void)getBoardStatWithSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
        failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;
- (void)getIndexWithSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
        failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;
- (void)getTopicListWithBoardId:(NSString*)boardId  pageNum:(NSInteger)pageNum
        success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
        failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;
- (void)getPostListWithTopicId:(NSString*)topicId boardId:(NSString*)boardId
        pageNum:(NSInteger)pageNum
        success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
        failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;
- (NSURL*)urlFromString:(NSString*)string;
@end
