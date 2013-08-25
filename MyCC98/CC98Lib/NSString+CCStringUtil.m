//
//  NSString+CCEncrypt.m
//  MyCC98
//
//  Created by Yan Chen on 1/27/13.
//  Copyright (c) 2013 YANN. All rights reserved.
//

#import "NSString+CCStringUtil.h"
#import <CommonCrypto/CommonDigest.h>

#import "GTMNSString+HTML.h"


@implementation NSString (CCStringUtil)

- (NSString*) md5_32
{
    const char *cStr = [self UTF8String];
    unsigned char result[16];
    CC_MD5( cStr, strlen(cStr), result ); // This is the md5 call
    return [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0],result[1],result[2],result[3],
            result[4],result[5],result[6],result[7],
            result[8],result[9],result[10],result[11],
            result[12],result[13],result[14],result[15]];
}

- (NSString*) md5_16
{
    const char *cStr = [self UTF8String];
    unsigned char result[16];
    CC_MD5( cStr, strlen(cStr), result ); // This is the md5 call
    return [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x",
            result[4],result[5],result[6],result[7],
            result[8],result[9],result[10],result[11]];
}

- (NSDate*) convertToDate
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setTimeZone:[NSTimeZone timeZoneWithName:@"Asia/Shanghai"]];
    [formatter setAMSymbol:@"AM"];
    [formatter setPMSymbol:@"PM"];
    [formatter setDateFormat:@"M/d/yyyy h:mm:ss aaa"];
    return [formatter dateFromString:self];
}

- (NSString *)stringByDecodingHTMLEntities
{
    return [NSString stringWithString:[self gtm_stringByUnescapingFromHTML]];
}

@end
