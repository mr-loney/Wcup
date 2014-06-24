//
//  UIView+AddPush.m
//  PM
//
//  Created by 张浩 on 14-6-10.
//  Copyright (c) 2014年 Huoli. All rights reserved.
//

#import "UIView+AddPush.h"

@implementation UIView (AddPush)

- (UIViewController *)viewController
{
    UIResponder *next = self.nextResponder;
    do {
        if ([next isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)next;
        } else {
            next = [next nextResponder];
        }
    } while (next != nil);
    return nil;
}

@end
