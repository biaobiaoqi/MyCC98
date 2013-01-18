//
//  CC98API.h
//  MyCC98
//
//  Created by Yan Chen on 1/18/13.
//  Copyright (c) 2013 Zhejiang University. All rights reserved.
//

#import "AFHTTPClient.h"
#import "CC98UrlManager.h"
#import "CC98Parser.h"
#import "BoardEntity.h"
#import "HotTopicEntity.h"

@interface CC98API : AFHTTPClient

+(CC98API*)sharedInstance;

@end
