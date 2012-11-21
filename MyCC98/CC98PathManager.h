//
//  CC98PathManager.h
//  MyCC98
//
//  Created by Yan Chen on 11/21/12.
//  Copyright (c) 2012 VINCENT. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CC98PathManager : NSObject

-(NSString*)getHotTopicPath;
-(NSString*)getUserProfilePath:(NSString*)userName;

@end
