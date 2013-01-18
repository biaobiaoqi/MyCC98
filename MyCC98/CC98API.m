//
//  CC98API.m
//  MyCC98
//
//  Created by Yan Chen on 1/18/13.
//  Copyright (c) 2013 Zhejiang University. All rights reserved.
//

#import "CC98API.h"

#define CC98 @"http://www.cc98.org"

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
        sharedInstance = [[self alloc] initWithBaseURL:[NSURL URLWithString:CC98]];
    });
    
    return sharedInstance;
}

@end
