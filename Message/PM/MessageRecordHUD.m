//
//  MessageRecordHUD.m
//  PM
//
//  Created by 张浩 on 14-6-13.
//  Copyright (c) 2014年 Huoli. All rights reserved.
//

#import "MessageRecordHUD.h"

#define kPauseString @"手指上滑，取消发送"
#define kContinueString @"松开手指，取消发送"

@interface MessageRecordHUD ()

@property (nonatomic, weak) UILabel *remindLabel;
@property (nonatomic, weak) UIImageView *microPhoneImageView;
@property (nonatomic, weak) UIImageView *cancelRecordImageView;
@property (nonatomic, weak) UIImageView *recordingHUDImageView;


/**
 * 逐渐消失自身
 * @param complete 消失完成的回调block
 */
- (void)dismissCompleted:(void(^)(BOOL finished))completed;

/**
 * 配置是否正在录音， 需要隐藏和显示某些特殊的控件
 * @param recording 是否录音中
 */
- (void)configRecording:(BOOL)recording;

/**
 * 根据语音输入的大小来配置需要显示的HUD图片
 * @param speakPower 输入音频的大小
 */
- (void)configRecordingHUDImageWithSpeakPower:(CGFloat)speakPower;


/**
 * 配置默认参数
 */
- (void)setup;


@end

@implementation MessageRecordHUD


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup
{
    self.backgroundColor = [UIColor blackColor];
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = 8;
    
    if (!_remindLabel) {
        UILabel *remindLabel = [[UILabel alloc] initWithFrame:CGRectMake(9.0, 114.0f, 120.0, 21.0)];
        remindLabel.textColor = [UIColor whiteColor];
        remindLabel.font = [UIFont systemFontOfSize:13.0f];
        remindLabel.layer.masksToBounds = YES;
        remindLabel.layer.cornerRadius = 4;
        remindLabel.autoresizingMask = UIViewAutoresizingFlexibleRightMargin|
        UIViewAutoresizingFlexibleBottomMargin;
        remindLabel.backgroundColor = [UIColor clearColor];
        remindLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:remindLabel];
        _remindLabel = remindLabel;
    }
    
    if (!_microPhoneImageView) {
        UIImageView *microPhoneImageView = [[UIImageView alloc] initWithFrame:CGRectMake(27.0, 8.0, 50.0, 99.0)];
        microPhoneImageView.image = [UIImage imageNamed:@"RecordingBkg"];
        microPhoneImageView.autoresizingMask =UIViewAutoresizingFlexibleRightMargin|
        UIViewAutoresizingFlexibleBottomMargin;
        microPhoneImageView.contentMode = UIViewContentModeScaleToFill;
        [self addSubview:microPhoneImageView];
        _microPhoneImageView = microPhoneImageView;
    }
    
    if (_recordingHUDImageView) {
        UIImageView *recordHUDImageView = [[UIImageView alloc] initWithFrame:CGRectMake(82.0, 34.0, 18.0, 61.0)];
        recordHUDImageView.image = [UIImage imageNamed:@"RecordingSignal001"];
        recordHUDImageView.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin;
        recordHUDImageView.contentMode = UIViewContentModeScaleToFill;
        [self addSubview:recordHUDImageView];
        _recordingHUDImageView = recordHUDImageView;
    }
    
    if (_cancelRecordImageView) {
        UIImageView *cancelRecordImageView = [[UIImageView alloc] initWithFrame:CGRectMake(19.0, 7.0f, 100.0f, 100.0f)];
        cancelRecordImageView.image = [UIImage imageNamed:@"RecordCancel"];
        cancelRecordImageView.hidden = YES;
        cancelRecordImageView.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin;
        cancelRecordImageView.contentMode = UIViewContentModeScaleToFill;
        [self addSubview:cancelRecordImageView];
        _cancelRecordImageView = cancelRecordImageView;
    }
    
}


#pragma mark -- methods
- (void)startRecordingHUDInSuperView:(UIView *)view
{
    CGPoint center = CGPointMake(CGRectGetWidth(view.frame)/2, CGRectGetHeight(view.frame)/2);
    self.center = center;
    [self configRecording:YES];
}

- (void)pauseRecord
{
    [self configRecording:YES];
    self.remindLabel.backgroundColor = [UIColor clearColor];
    self.remindLabel.text = kPauseString;
}

- (void)continueRecord
{
    [self configRecording:NO];
    self.remindLabel.backgroundColor = [UIColor colorWithRed:1.000 green:0.000 blue:0.000 alpha:0.630];
    self.remindLabel.text = kContinueString;
}

- (void)stopRecord:(void (^)(BOOL))completed
{
    [self dismissCompleted:completed];
}

- (void)cancelRecord:(void (^)(BOOL))completed
{
    [self dismissCompleted:completed];
}

- (void)dismissCompleted:(void (^)(BOOL))completed
{
    [UIView animateWithDuration:0.3
                          delay:0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         self.alpha = 0.0f;
                     } completion:^(BOOL finished) {
                         [super removeFromSuperview];
                         completed(finished);
                     }];
}

- (void)configRecording:(BOOL)recording
{
    self.microPhoneImageView.hidden = !recording;
    self.recordingHUDImageView.hidden = !recording;
    self.cancelRecordImageView.hidden = recording;
}

- (void)configRecordingHUDImageWithSpeakPower:(CGFloat)speakPower
{
    NSString *imageName = @"RecordingSignal00";
    if (speakPower >= 0 && speakPower <= 0.1) {
        imageName = [imageName stringByAppendingString:@"1"];
    } else if (speakPower > 0.1 && speakPower <= 0.2) {
        imageName = [imageName stringByAppendingString:@"2"];
    } else if (speakPower > 0.3 && speakPower <= 0.4) {
        imageName = [imageName stringByAppendingString:@"3"];
    } else if (speakPower > 0.4 && speakPower <= 0.5) {
        imageName = [imageName stringByAppendingString:@"4"];
    } else if (speakPower > 0.5 && speakPower <= 0.6) {
        imageName = [imageName stringByAppendingString:@"5"];
    } else if (speakPower > 0.7 && speakPower <= 0.8) {
        imageName = [imageName stringByAppendingString:@"6"];
    } else if (speakPower > 0.8 && speakPower <= 0.9) {
        imageName = [imageName stringByAppendingString:@"7"];
    } else if (speakPower > 0.9 && speakPower <= 1.0) {
        imageName = [imageName stringByAppendingString:@"8"];
    }
    self.recordingHUDImageView.image = [UIImage imageNamed:imageName];
}

- (void)setSpeakPower:(CGFloat)speakPower
{
    _speakPower = speakPower;
    [self configRecordingHUDImageWithSpeakPower:speakPower];
}


@end
