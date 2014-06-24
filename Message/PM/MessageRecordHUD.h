//
//  MessageRecordHUD.h
//  PM
//
//  Created by 张浩 on 14-6-13.
//  Copyright (c) 2014年 Huoli. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MessageRecordHUD : UIView

@property (nonatomic, assign) CGFloat speakPower;

/**
 * 开始录音的HUD控件在某个View
 * @param view:具体要显示的view
 */
- (void)startRecordingHUDInSuperView:(UIView *)view;

/**
 * 提示取消录音
 */
- (void)pauseRecord;

/**
 * 提示继续录音
 */
- (void)continueRecord;

/**
 * 停止录音，意思是完成录音
 *
 * @param compled 完成录音后的block回调
 */
- (void)stopRecord:(void(^)(BOOL finished))completed;

/**
 * 取消录音
 *
 *  @param complete 取消录音完成后的回调
 */
- (void)cancelRecord:(void(^)(BOOL finished))completed;
@end
