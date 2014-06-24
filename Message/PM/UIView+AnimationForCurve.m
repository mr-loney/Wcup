//
//  UIView+AnimationForCurve.m
//  PM
//
//  Created by 张浩 on 14-6-12.
//  Copyright (c) 2014年 Huoli. All rights reserved.
//

#import "UIView+AnimationForCurve.h"

@implementation UIView (AnimationForCurve)

+ (UIViewAnimationOptions)animationOptionsForCurve:(UIViewAnimationCurve)curve
{
    switch (curve) {
        case UIViewAnimationCurveEaseInOut:
            return UIViewAnimationOptionCurveEaseInOut;
            break;
        case UIViewAnimationCurveEaseIn:
            return UIViewAnimationOptionCurveEaseIn;
            break;
        case UIViewAnimationCurveEaseOut:
            return UIViewAnimationOptionCurveEaseOut;
            break;
        case UIViewAnimationCurveLinear:
            return UIViewAnimationOptionCurveLinear;
            break;
    }
    return kNilOptions;
}

@end
