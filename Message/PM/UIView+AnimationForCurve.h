//
//  UIView+AnimationForCurve.h
//  PM
//
//  Created by 张浩 on 14-6-12.
//  Copyright (c) 2014年 Huoli. All rights reserved.
//

/*
 动画效果
 
 */

#import <UIKit/UIKit.h>

@interface UIView (AnimationForCurve)
+ (UIViewAnimationOptions)animationOptionsForCurve:(UIViewAnimationCurve)curve;
@end
