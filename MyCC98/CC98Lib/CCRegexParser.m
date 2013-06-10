//
//  CCRegexParser.m
//  MyCC98
//
//  Created by Jason Chen on 6/10/13.
//  Copyright (c) 2013 YANN. All rights reserved.
//

#import "CCRegexParser.h"

@implementation CCRegexParser

+ (NSString*) removeBlankInString:(NSString*)target
{
    NSMutableString *webcontent = [NSMutableString stringWithString:target];
    NSRegularExpression *trim = [[NSRegularExpression alloc]
                                 initWithPattern:@"[\\r\\n\\t]"
                                 options:NSRegularExpressionCaseInsensitive
                                 error:nil];
    [trim replaceMatchesInString:webcontent options:0 range:NSMakeRange(0, webcontent.length) withTemplate:@""];
    return webcontent;
}

+ (NSArray*) matchesInString:(NSString*)target Regex:(NSString*)regex
{
    NSRegularExpression *regex_ = [[NSRegularExpression alloc]
                                       initWithPattern:regex
                                       options:NSRegularExpressionCaseInsensitive
                                       error:nil];
    NSArray *array = [regex_ matchesInString:target options:0 range:NSMakeRange(0, target.length)];
    NSMutableArray *resultarray = [[NSMutableArray alloc] init];
    for (NSTextCheckingResult *result in array) {
        NSString *result_ = [target substringWithRange:result.range];
        [resultarray addObject:result_];
    }
    return resultarray;
}

+ (NSString*) firstMatchInString:(NSString*)target Regex:(NSString*)regex
{
    NSRegularExpression *regex_ = [[NSRegularExpression alloc]
                                   initWithPattern:regex
                                   options:NSRegularExpressionCaseInsensitive
                                   error:nil];
    NSRange range = [regex_ rangeOfFirstMatchInString:target options:0 range:NSMakeRange(0, target.length)];
    return [target substringWithRange:range];
}

@end
