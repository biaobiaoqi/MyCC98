//
//  CCRegexParser.h
//  MyCC98
//
//  Created by Jason Chen on 6/10/13.
//  Copyright (c) 2013 YANN. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CCRegexParser : NSObject

+ (NSString*) removeBlankInString:(NSString*)target;
+ (NSArray*) matchesInString:(NSString*)target Regex:(NSString*)regex;
+ (NSString*) firstMatchInString:(NSString*)target Regex:(NSString*)regex;

@end
