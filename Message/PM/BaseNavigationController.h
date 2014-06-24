//
//  BaseNavigationController.h
//  PM
//
//  Created by 张浩 on 14-6-9.
//  Copyright (c) 2014年 Huoli. All rights reserved.
//

#import <UIKit/UIKit.h>

// 背景视图起始frame.x
#define startX -200

@interface BaseNavigationController : UINavigationController
{
    CGFloat startBackViewX;
}

//默认为特效开启
@property (nonatomic, assign) BOOL canDragBack;
@end
