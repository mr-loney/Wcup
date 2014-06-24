//
//  BaseNavigationController.m
//  PM
//
//  Created by 张浩 on 14-6-9.
//  Copyright (c) 2014年 Huoli. All rights reserved.
//

#import "BaseNavigationController.h"


@interface BaseNavigationController ()
{
    CGPoint startTouch;
    
    UIImageView *lastScreenShotView;
    UIView *blackMask;
}

@property (nonatomic, retain) UIView *backgroundView;
@property (nonatomic, retain) NSMutableArray *screenShotsList;
@property (nonatomic, assign) BOOL isMoving;

@end

@implementation BaseNavigationController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
//        self.screenShotsList = [[NSMutableArray alloc] initWithCapacity:2];
//        self.canDragBack = YES;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
//    if ([self.navigationBar respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)]) {
//        [self.navigationBar setBackgroundImage:[self imageFromColor:[UIColor blueColor]] forBarMetrics:UIBarMetricsDefault];
//    }
    
//    UIPanGestureRecognizer *recognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(paningGestureReceive:)];
//    [recognizer delaysTouchesBegan];
//    [self.view addGestureRecognizer:recognizer];
    
    self.interactivePopGestureRecognizer.enabled = YES;
}




/*
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    [self.screenShotsList addObject:[self capture]];

    [super pushViewController:viewController animated:animated];
}

- (UIViewController *)popViewControllerAnimated:(BOOL)animated
{
    [self.screenShotsList removeLastObject];
    return [super popViewControllerAnimated:animated];
}

#pragma mark - Utility Methods
- (UIImage *)capture
{
    UIGraphicsBeginImageContextWithOptions(self.view.bounds.size, self.view.opaque, 0.0);
    [self.view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

- (UIImage *)imageFromColor:(UIColor *)color
{
    CGRect rect = CGRectMake(0, 0, 10, 10);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

- (void)moveViewWithX:(float)x
{
    x = x>SCREENWIDTH?SCREENWIDTH:x;
    x = x<0?0:x;
    CGRect frame = self.view.frame;
    frame.origin.x = x;
    self.view.frame = frame;

    float alpha = 0.4 - (x/800);
    blackMask.alpha = alpha;
    
    CGFloat aa = abs(startBackViewX)/SCREENWIDTH;
    CGFloat y = x*aa;
    CGFloat lastScreenShotViewHeight = SCREENHEIGHT;
    [lastScreenShotView setFrame:CGRectMake(startBackViewX+y,
                                           0,
                                           SCREENWIDTH,
                                           lastScreenShotViewHeight)];
}

- (BOOL)isBlurryImg:(CGFloat)tmp
{
    return YES;
}

#pragma mark -- Gesture Recognizer
- (void)paningGestureReceive:(UIPanGestureRecognizer *)recognizer
{
    if (self.viewControllers.count<=1 || !self.canDragBack) {
        return;
    }
    
    CGPoint touchPoint = [recognizer locationInView:KEY_WINDOW];
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        _isMoving = YES;
        startTouch = touchPoint;
        if (!self.backgroundView) {
            CGRect frame = self.view.frame;
            self.backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
            [self.view.superview insertSubview:self.backgroundView belowSubview:self.view];
            
            blackMask = [[UIView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
            blackMask.backgroundColor = [UIColor clearColor];
            [self.backgroundView addSubview:blackMask];
        }
        
        self.backgroundView.hidden = NO;
        
        if (lastScreenShotView) {
            [lastScreenShotView removeFromSuperview];
        }
        
        UIImage *lastScreenShot = [self.screenShotsList lastObject];
        lastScreenShotView = [[UIImageView alloc] initWithImage:lastScreenShot];
        startBackViewX = startX;
        [lastScreenShotView setFrame:CGRectMake(startBackViewX,
                                               lastScreenShotView.frame.origin.y,
                                               lastScreenShotView.frame.size.height,
                                                lastScreenShotView.frame.size.width)];
        [self.backgroundView insertSubview:lastScreenShotView belowSubview:blackMask];
    } else if (recognizer.state == UIGestureRecognizerStateEnded) {
        if (touchPoint.x-startTouch.x > 50) {
            [UIView animateWithDuration:0.3 animations:^{
                [self moveViewWithX:SCREENWIDTH];
            } completion:^(BOOL finished) {
                [self popViewControllerAnimated:NO];
                CGRect frame = self.view.frame;
                frame.origin.x = 0;
                self.view.frame = frame;
                _isMoving = NO;
            }];
        } else {
            [UIView animateWithDuration:0.3 animations:^{
                [self moveViewWithX:0];
            } completion:^(BOOL finished) {
                _isMoving = NO;
                self.backgroundView.hidden = YES;
            }];
        }
        return;
    } else if (recognizer.state == UIGestureRecognizerStateCancelled) {
        [UIView animateWithDuration:0.3 animations:^{
            [self moveViewWithX:0];
        } completion:^(BOOL finished) {
            _isMoving = NO;
            self.backgroundView.hidden = YES;
        }];
        return;
    }
    
    if (_isMoving) {
        [self moveViewWithX:touchPoint.x - startTouch.x ];
    }
}

- (void)dealloc
{
    self.screenShotsList = nil;
    [self.backgroundView removeFromSuperview];
    self.backgroundView = nil;

}

*/
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
