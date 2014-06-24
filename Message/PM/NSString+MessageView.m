//
//  NSString+MessageView.m
//  PM
//
//  Created by 张浩 on 14-6-12.
//  Copyright (c) 2014年 Huoli. All rights reserved.
//

#import "NSString+MessageView.h"

@implementation NSString (MessageView)

- (NSString *)trimWihteSpace
{
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

- (NSUInteger)numberOfLines
{
    return [self componentsSeparatedByString:@"\n"].count + 1;
}

@end
