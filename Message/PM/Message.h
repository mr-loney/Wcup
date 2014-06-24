//
//  Message.h
//  PM
//
//  Created by 张浩 on 14-6-10.
//  Copyright (c) 2014年 Huoli. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    MessageTypeMe = 0, // 自己发的
    MessageTypeOther = 1 // 别人发的
}MessageType;

@interface Message : NSObject

@property (nonatomic, copy) NSString *icon;
@property (nonatomic, copy) NSString *time;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, assign) MessageType type;
@property (nonatomic, copy) NSDictionary *dataDict;

@end
