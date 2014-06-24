//
//  Message.m
//  PM
//
//  Created by 张浩 on 14-6-10.
//  Copyright (c) 2014年 Huoli. All rights reserved.
//

#import "Message.h"

@implementation Message

// 得写setter方法
- (void)setDataDict:(NSDictionary *)dataDict
{
    _dataDict = dataDict;
    _icon = dataDict[@"icon"];
    _time = dataDict[@"time"];
    _content = dataDict[@"content"];
    _type = [dataDict[@"type"] intValue];
}

@end
