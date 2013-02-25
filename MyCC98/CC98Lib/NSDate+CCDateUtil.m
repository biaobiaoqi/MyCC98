//
//  NSDate+CCDateUtil.m
//  MyCC98
//
//  Created by Yan Chen on 2/25/13.
//  Copyright (c) 2013 YANN. All rights reserved.
//

#import "NSDate+CCDateUtil.h"

@implementation NSDate (CCDateUtil)

- (NSString*) convertToString
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setTimeZone:[NSTimeZone timeZoneWithName:@"Asia/Shanghai"]];
    [formatter setAMSymbol:@"AM"];
    [formatter setPMSymbol:@"PM"];
    [formatter setDateFormat:@"M/d/yyyy h:mm:ss aaa"];
    return [formatter stringFromDate:self];
}

@end
