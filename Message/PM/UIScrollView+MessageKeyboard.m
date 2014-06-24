//
//  UIScrollView+MessageKeyboard.m
//  PM
//
//  Created by 张浩 on 14-6-16.
//  Copyright (c) 2014年 Huoli. All rights reserved.
//

#import "UIScrollView+MessageKeyboard.h"
#import <objc/runtime.h>
#import "UIView+AnimationForCurve.h"

static NSString * const KeyboardWillDismissedBlockKey = @"KeyboardWillDismissedBlockKey";
static NSString * const KeyboardDidHideBlockKey = @"KeyboardDidHideBlockKey";
static NSString * const KeyboardDidChangeBlockKey = @"KeyboardDidChangeBlockKey";
static NSString * const KeyboardDidScrollToPointBlockKey = @"KeyboardDidScrollToPointBlockKey";
static NSString * const KeyboardWillSnapBackToPointBlockKey = @"KeyboardWillSnapBackToPointBlockKey";
static NSString * const KeyboardWillChangeBlockKey = @"KeyboardWillChangeBlockKey";

static NSString * const KeyboardViewKey = @"KeyboardViewKey";
static NSString * const PreviousKeyboardYKey = @"PreviousKeyboardYKey";

static NSString * const MessageInputBarHeightKey = @"MessageInputBarHeightKey";


@interface UIScrollView (MessageKeyboard)

@property (nonatomic, assign) CGFloat previousKeyboardY;

@end

@implementation UIScrollView (MessageKeyboard)

#pragma mark -- setter getter
- (void)setKeyboardWillDismissed:(KeyboardWillDismissedBlock)keyboardWillDismissed
{
    objc_setAssociatedObject(self, &KeyboardWillDismissedBlockKey, keyboardWillDismissed, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (KeyboardWillDismissedBlock)keyboardWillDismissed
{
    return objc_getAssociatedObject(self, &KeyboardWillDismissedBlockKey);
}

- (void)setKeyboardDidHide:(KeyboardDidHideBlock)keyboardDidHide
{
    objc_setAssociatedObject(self, &KeyboardDidHideBlockKey, keyboardDidHide, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (KeyboardDidHideBlock)keyboardDidHide
{
    return  objc_getAssociatedObject(self, &KeyboardDidHideBlockKey);
}

- (void)setKeyboardDidChange:(KeyboardDidShowBlock)keyboardDidChange
{
    objc_setAssociatedObject(self, &KeyboardDidChangeBlockKey, keyboardDidChange, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (void)setKeyboardWillSnapBackToPoint:(KeyboardWillSnapBackToPointBlock)keyboardWillSnapBackToPoint
{
    objc_setAssociatedObject(self, &KeyboardWillSnapBackToPointBlockKey, keyboardWillSnapBackToPoint, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (KeyboardWillSnapBackToPointBlock)keyboardWillSnapBackToPoint
{
    return objc_getAssociatedObject(self, &KeyboardWillSnapBackToPointBlockKey);
}

- (void)setKeyboardDidScrollToPoint:(KeyboardDidScrollToPointBlock)keyboardDidScrollToPoint
{
    objc_setAssociatedObject(self, &KeyboardDidScrollToPointBlockKey, keyboardDidScrollToPoint, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (KeyboardDidScrollToPointBlock)keyboardDidScrollToPoint
{
    return objc_getAssociatedObject(self, &KeyboardDidScrollToPointBlockKey);
}


- (void)setKeyboardWillChange:(KeyboardWillChangeBlock)keyboardWillChange
{
    objc_setAssociatedObject(self, &KeyboardWillChangeBlockKey, keyboardWillChange, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (KeyboardWillChangeBlock)keyboardWillChange
{
    return objc_getAssociatedObject(self, &KeyboardWillChangeBlockKey);
}


//=====================UI==============
- (void)setKeyboardView:(UIView *)keyboardView
{
    objc_setAssociatedObject(self, &KeyboardViewKey, keyboardView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIView *)keyboardView
{
    return objc_getAssociatedObject(self, &KeyboardViewKey);
}

- (void)setPreviousKeyboardY:(CGFloat)previousKeyboardY
{
    objc_setAssociatedObject(self, &PreviousKeyboardYKey, [NSNumber numberWithFloat:previousKeyboardY], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (CGFloat)previousKeyboardY
{
    return [objc_getAssociatedObject(self, &PreviousKeyboardYKey) floatValue];
}

- (void)setMessageInputBarHeight:(CGFloat)messageInputBarHeight
{
    objc_setAssociatedObject(self, &MessageInputBarHeightKey, [NSNumber numberWithFloat:messageInputBarHeight], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (CGFloat)messageInputBarHeight
{
    return [objc_getAssociatedObject(self, &MessageInputBarHeightKey) floatValue];
}


#pragma mark -- Helper Method
+ (UIView *)findKeyboard
{
    UIView *keyboardView = nil;
    NSArray *windows = [[UIApplication sharedApplication] windows];
    for (UIWindow *window in [windows reverseObjectEnumerator]) {//逆序的效率更高。因为键盘总在最上方
        keyboardView = [self findKeyboardInView:window];
        if (keyboardView) {
            return keyboardView;
        }
    }
    
    return nil;
}

+ (UIView *)findKeyboardInView:(UIView *)view
{
    for (UIView *subView in [view subviews]) {
        
        if (strstr(object_getClassName(subView), "UIKeyboard")) {
            return subView;
        } else {
            UIView *tempView = [self findKeyboardInView:view];
            if (tempView) {
                return tempView;
            }
        }
    }
    
    return nil;
}

- (void)setupPanGestureControlKeyboardHide:(BOOL)isPanGestured
{
    //键盘通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleWillShowKeyboardNotification:) name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleWillHideKeyboardNotification:) name:UIKeyboardWillHideNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleKeyboardWillShowHideNotification:) name:UIKeyboardDidShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleKeyboardWillShowHideNotification:) name:UIKeyboardDidHideNotification object:nil];
    
    if (isPanGestured) {
        [self.panGestureRecognizer addTarget:self action:@selector(handlePanGesture:)];
    }
    
}

- (void)disSetupPanGesutreControlKeyboardHide:(BOOL)isPanGestured
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidHideNotification object:nil];
    
    if (isPanGestured) {
        [self.panGestureRecognizer removeTarget:self action:@selector(handlePanGesture:)];
    }
}

#pragma mark -- Gestures
- (void)handlePanGesture:(UIPanGestureRecognizer *)pan
{
    if (!self.keyboardView || self.keyboardView.hidden) {
        return;
    }
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenHeight = screenRect.size.height;
    
    UIWindow *panWindow = [[UIApplication sharedApplication] keyWindow];
    CGPoint location = [pan locationInView:panWindow];
    location.y += self.messageInputBarHeight;
    CGPoint velocity = [pan velocityInView:panWindow];
    switch (pan.state) {
        case UIGestureRecognizerStateBegan:
        {
            self.previousKeyboardY = self.keyboardView.frame.origin.y;
            break;
        }
        case UIGestureRecognizerStateEnded:
        {
            if (velocity.y>0 && self.keyboardView.frame.origin.y>self.previousKeyboardY) {
                [UIView animateWithDuration:0.3
                                      delay:0
                                    options:UIViewAnimationOptionCurveEaseOut
                                 animations:^{
                                     self.keyboardView.frame = CGRectMake(0.0, screenHeight, self.keyboardView.frame.size.width, self.keyboardView.frame.size.height);
                                     if (self.keyboardWillDismissed) {
                                         self.keyboardWillDismissed();
                                     }
                                     
                                 } completion:^(BOOL finished) {
                                     self.keyboardView.hidden = YES;
                                     self.keyboardView.frame = CGRectMake(0.0, self.previousKeyboardY, self.keyboardView.frame.size.width, self.keyboardView.frame.size.height);
                                     [self resignFirstResponder];
                                     if (self.keyboardDidHide) {
                                         self.keyboardDidHide();
                                     }
                                 }];
            } else {
                //gesture ended with no flick or a flick upwards，snap keyboard back to original position
                [UIView animateWithDuration:0.2
                                      delay:0
                                    options:UIViewAnimationOptionCurveEaseOut
                                 animations:^{
                                     if (self.keyboardWillSnapBackToPoint) {
                                         self.keyboardWillSnapBackToPoint(CGPointMake(0.0f, self.previousKeyboardY));
                                     }
                                     
                                     self.keyboardView.frame = CGRectMake(0.0f, self.previousKeyboardY, self.keyboardView.frame.size.width, self.keyboardView.frame.size.height);
                                 }
                                 completion:NULL];
            }
            break;
        }
        default:
        {
            if (location.y>self.keyboardView.frame.origin.y ||
                self.keyboardView.frame.origin.y!=self.previousKeyboardY) {
                CGFloat newKeyboardY = self.previousKeyboardY + (location.y - self.previousKeyboardY);
                newKeyboardY = newKeyboardY < self.previousKeyboardY ? self.previousKeyboardY : newKeyboardY;
                newKeyboardY = newKeyboardY > screenHeight ? screenHeight : newKeyboardY;
                
                self.keyboardView.frame = CGRectMake(0.0f,
                                                     newKeyboardY,
                                                     self.keyboardView.frame.size.width,
                                                     self.keyboardView.frame.size.height);
                
                if (self.keyboardDidScrollToPoint) {
                    self.keyboardDidScrollToPoint(CGPointMake(0.0f, newKeyboardY));
                }
            }
            break;
        }
            
    }
    
}


#pragma mark -- Keyboard notifications
- (void)handleKeyboardWillShowHideNotification:(NSNotification *)notification
{
    BOOL didShowed = YES;
    if ([notification.name isEqualToString:UIKeyboardDidShowNotification]) {
        self.keyboardView = [UIScrollView findKeyboard].superview;
        self.keyboardView.hidden = NO;
        didShowed = YES;
    } else if ([notification.name isEqualToString:UIKeyboardDidHideNotification]) {
        self.keyboardView.hidden = NO;
        [self resignFirstResponder];
    }
    if (self.keyboardDidChange) {
        self.keyboardDidChange(didShowed);
    }
    
}

- (void)handleWillShowKeyboardNotification:(NSNotification *)notification
{
    self.keyboardView.hidden = NO;
    [self keyboardWillShowHide:notification];
}

- (void)handleWillHideKeyboardNotification:(NSNotification *)notification
{
    [self keyboardWillShowHide:notification];
}

- (void)keyboardWillShowHide:(NSNotification *)notification
{
    CGRect keyboardRect = [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    UIViewAnimationCurve curve = [[notification.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] integerValue];
    double duration = [[notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    if (self.keyboardWillChange) {
        self.keyboardWillChange(keyboardRect, [UIView animationOptionsForCurve:curve], duration, [notification.name isEqualToString:UIKeyboardWillShowNotification]?YES:NO);
    }
}


@end
