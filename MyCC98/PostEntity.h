//
//  PostEntity.h
//  MyCC98
//
//  Created by Yan Chen on 1/22/13.
//  Copyright (c) 2013 Zhejiang University. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PostEntity : NSObject
{
    NSString *postAuthor;
    NSString *postContent;
}

@property (nonatomic, strong) NSString *postAuthor;
@property (nonatomic, strong) NSString *postContent;

@end
