//
//  CC98API.m
//  MyCC98
//
//  Created by Yan Chen on 1/27/13.
//  Copyright (c) 2013 YANN. All rights reserved.
//
@interface NSMutableURLRequest (DummyInterface)
+ (BOOL)allowsAnyHTTPSCertificateForHost:(NSString*)host;
+ (void)setAllowsAnyHTTPSCertificate:(BOOL)allow forHost:(NSString*)host;
@end

@interface NSURLRequest (DummyInterface)
+ (BOOL)allowsAnyHTTPSCertificateForHost:(NSString*)host;
+ (void)setAllowsAnyHTTPSCertificate:(BOOL)allow forHost:(NSString*)host;
@end



#import "CC98API.h"
#import "CC98UrlManager.h"

#define CC98URL @"http://www.cc98.org"
#define RVPNURL @"https://rvpn.zju.edu.cn"

@implementation CC98API

#pragma mark - Singleton methods
/**
 * Singleton methods
 */
+(CC98API*)sharedInstance
{
    static CC98API *sharedInstance = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        sharedInstance = [[self alloc] initWithBaseURL:[NSURL URLWithString:CC98URL]];
    });
    
    return sharedInstance;
}

-(CC98API*)initWithBaseURL:(NSURL*)url
{
    cpath = @"";
    key = @"";
    return [super initWithBaseURL:url];
}

-(void)setRVPN:(BOOL)value key:(NSString*)rvpnkey
{
    if (value == FALSE) {
        self.baseURL = [NSURL URLWithString:CC98URL];
        cpath = @"";
        key = @"";
    }
    else
    {
        self.baseURL = [NSURL URLWithString:RVPNURL];
        //cpath = [rvpnkey stringByAppendingString:@"/web/1/http/2/www.cc98.org"];
        cpath = @"/web/1/http/2/www.cc98.org";
        key = [NSString stringWithString:rvpnkey];
        [NSMutableURLRequest setAllowsAnyHTTPSCertificate:YES forHost:@"rvpn.zju.edu.cn"];
        [NSURLRequest setAllowsAnyHTTPSCertificate:YES forHost:@"rvpn.zju.edu.cn"];
    }
}

- (void)loginWithData:(NSDictionary*)loginData
              success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
              failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    [self postPath:[NSString stringWithFormat:@"%@%@", cpath,[[CC98UrlManager sharedInstance] getLoginPath]] parameters:loginData success:success failure:failure];
}

- (void)getAvatarUrlWithUserName:(NSString*)username
                         success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                         failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    [self getPath:[[CC98UrlManager sharedInstance] getUserProfilePath:username] parameters:nil success:success failure:failure];
}

- (void)getBoardStatWithSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                        failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    [self getPath:[NSString stringWithFormat:@"%@%@", cpath,[[CC98UrlManager sharedInstance] getBoardStatPath]] parameters:nil success:success failure:failure];
}

- (void)getIndexWithSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                    failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    [self getPath:[NSString stringWithFormat:@"%@%@", cpath,[[CC98UrlManager sharedInstance] getIndexPath]] parameters:nil success:success failure:failure];
}

- (void)getTopicListWithBoardId:(NSString*)boardId pageNum:(NSInteger)pageNum
                        success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                        failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    [self getPath:[NSString stringWithFormat:@"%@%@", cpath, [[CC98UrlManager sharedInstance] getBoardPathWithBoardId:boardId pageNum:pageNum]] parameters:nil success:success failure:failure];
}

- (void)getPostListWithTopicId:(NSString*)topicId boardId:(NSString*)boardId
                       pageNum:(NSInteger)pageNum
                       success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                       failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    [self getPath:[NSString stringWithFormat:@"%@%@", cpath, [[CC98UrlManager sharedInstance] getTopicPathWithBoardId:boardId topicId:topicId pageNum:pageNum]] parameters:nil success:success failure:failure];
}

- (void)getRVPNWithKey:(NSString*)rvpnkey
               success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
               failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    [self getPath:[NSString stringWithFormat:@"/%@%@%@",rvpnkey, cpath, [[CC98UrlManager sharedInstance] getIndexPath]] parameters:nil success:success failure:failure];
}

- (NSURL*)urlFromString:(NSString*)string
{
    if ([key isEqual: @""]) {
        return [NSURL URLWithString:string];
    } else {
        string = [string stringByReplacingOccurrencesOfString:@"http:\\/\\/|https:\\/\\/" withString:@"" options:NSRegularExpressionSearch range:NSMakeRange(0, [string length])];
        return [NSURL URLWithString:[NSString stringWithFormat:@"https://rvpn.zju.edu.cn/%@/web/1/http/2/%@", key, string]];
    }
}

- (NSURL*)urlFromBoardId:(NSString*)boardId topicId:(NSString*)topicId pageNum:(NSString*)pageNum
{
    if ([key isEqual: @""]) {
        return [NSURL URLWithString:[NSString stringWithFormat:@"http://www.cc98.org/dispbbs.asp?boardID=%@&ID=%@&page=%@", boardId, topicId, pageNum]];
    } else {
        return [NSURL URLWithString:[NSString stringWithFormat:@"https://rvpn.zju.edu.cn/%@/web/1/http/2/www.cc98.org/dispbbs.asp?boardID=%@&ID=%@&page=%@", key, boardId, topicId, pageNum]];
    }
}

- (void)replyPostWithBoardId:(NSString*)boardId replyId:(NSString*)replyId topicId:(NSString*)topicId
                          bm:(NSString*)bm data:(NSDictionary*)postData
                     success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                     failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    NSMutableURLRequest *request = [self requestWithMethod:@"POST" path:[NSString stringWithFormat:@"/SaveReAnnounce.asp?method=Topic&boardID=%@&bm=%@", boardId, bm] parameters:postData];
    [request setValue:[NSString stringWithFormat:@"http://www.cc98.org/reannounce.asp?BoardID=%@&replyID=%@&id=%@&star=1&reply=true&bm=%@", boardId, replyId, topicId, bm] forHTTPHeaderField:@"Referer"];
	AFHTTPRequestOperation *operation = [self HTTPRequestOperationWithRequest:request success:success failure:failure];
    [self enqueueHTTPRequestOperation:operation];
}

- (void)replyTopicWithBoardId:(NSString*)boardId topicId:(NSString*)topicId
                         data:(NSDictionary*)postData
                      success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                      failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    NSMutableURLRequest *request = [self requestWithMethod:@"POST" path:[NSString stringWithFormat:@"/SaveReAnnounce.asp?method=Topic&boardID=%@&bm=", boardId] parameters:postData];
    [request setValue:[NSString stringWithFormat:@"http://www.cc98.org/reannounce.asp?BoardID=%@&id=%@&star=1", boardId, topicId] forHTTPHeaderField:@"Referer"];
	AFHTTPRequestOperation *operation = [self HTTPRequestOperationWithRequest:request success:success failure:failure];
    [self enqueueHTTPRequestOperation:operation];
}

- (void)newPostWithBoardId:(NSString*)boardId data:(NSDictionary*)postData
                   success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                   failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    NSMutableURLRequest *request = [self requestWithMethod:@"POST" path:[NSString stringWithFormat:@"/SaveAnnounce.asp?boardID=%@", boardId] parameters:postData];
    [request setValue:[NSString stringWithFormat:@"http://www.cc98.org/announce.asp?boardid=%@", boardId] forHTTPHeaderField:@"Referer"];
	AFHTTPRequestOperation *operation = [self HTTPRequestOperationWithRequest:request success:success failure:failure];
    [self enqueueHTTPRequestOperation:operation];
}

- (void)getHotTopicListWithSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                           failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    [[CC98API sharedInstance] getPath:[[CC98UrlManager sharedInstance] getHotTopicPath] parameters:nil success:success failure:failure];
}

@end
