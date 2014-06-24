//
//  MessageInputView.h
//  PM
//
//  Created by 张浩 on 14-6-13.
//  Copyright (c) 2014年 Huoli. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MessageView.h"

typedef NS_ENUM(NSUInteger, MessageInputViewStyle){
    MessageInputViewStyleQuasiphysical = 0,// ios6拟物化
    MessageInputViewStyleFlat //平面化
};

@protocol MessageInputViewDelegate <NSObject>

@required
/**
 *  输入框刚好开始编辑
 *
 *  @param messageInputTextView 输入框对象
 */
- (void)inputTextViewDidBeginEditing:(MessageView *)messageInputTextView;

/**
 *  输入框将要开始编辑
 *
 *  @param messageInputTextView 输入框对象
 */
- (void)inputTextViewWillBeginEditing:(MessageView *)messageInputTextView;



@optional
/**
 *  在发送文本和语音之间发送改变时，会触发这个回调函数
 *
 *  @param changed 是否改为发送语音状态
 */
- (void)didChangeSendVoiceAction:(BOOL)changed;

/**
 *  发送文本消息，包括系统的表情
 *
 *  @param text 目标文本消息
 */
- (void)didSendTextAction:(NSString *)content;

/**
 *  点击+号按钮Action
 */
- (void)didSelectMultipleMediaAction;

/**
 *  按下录音按钮开始录音
 */
- (void)didStartRecordingAction;

/**
 *  手指向上滑动取消录音
 */
- (void)didCancelRecordingAction;

/**
 *  松开手指完成录音
 */
- (void)didFinishRecordingAction;

/**
 *  当手指离开按钮的范围内时，主要为了通知外部的HUD
 */
- (void)didDragOutsizeAction;

/**
 *  当手指再次进入按钮的范围内时，主要也是为了通知外部的HUD
 */
- (void)didDragInsideAction;

/**
 *  发送第三方表情
 *
 *  @param facePath 目标表情的本地路径
 */
- (void)didSendFaceAction:(BOOL)sendFace;

@end


@interface MessageInputView : UIImageView

/**
 * MessageInputViewDelegate
 */
@property (nonatomic, weak) id<MessageInputViewDelegate>inputDelegate;


/**
 *  当前输入工具条的样式  @param default is XHMessageInputViewStyleFlat
 */
@property (nonatomic, assign) MessageInputViewStyle messageInputViewStyle;

/**
 *  是否允许发送语音 @param default is YES
 */
@property (nonatomic, assign) BOOL allowsSendVoice;

/**
 *  是否允许发送多媒体 @param default is YES
 */
@property (nonatomic, assign) BOOL allowsSendMultiMedia;

/**
 *  是否支持发送表情 @param default is YES
 */
@property (nonatomic, assign) BOOL allowsSendFace;





//==================控件===========================

/**
 *  用于输入文本消息的输入框
 */
@property (nonatomic, weak, readonly) MessageView *inputTextView;


/**
 *  切换文本和语音的按钮
 */
@property (nonatomic, weak, readonly) UIButton *voiceChangeButton;

/**
 *  +号按钮
 */
@property (nonatomic, weak, readonly) UIButton *multiMediaSendButton;

/**
 *  第三方表情按钮
 */
@property (nonatomic, weak, readonly) UIButton *faceSendButton;

/**
 *  语音录制按钮
 */
@property (nonatomic, weak, readonly) UIButton *voiceButton;


#pragma mark -- resize InputView

/**
 *  动态改变高度
 *
 *  @param changeInHeight 目标变化的高度
 */
- (void)adjustTextViewHeightBy:(CGFloat)changeInHeight;

/**
 *  获取输入框内容字体行高
 *
 *  @return 返回行高
 */
+ (CGFloat)textViewLineHeight;

/**
 *  获取最大行数
 *
 *  @return 返回最大行数
 */
+ (CGFloat)maxLines;

/**
 *  获取根据最大行数和每行高度计算出来的最大显示高度
 *
 *  @return 返回最大显示高度
 */
+ (CGFloat)maxHeight;


@end
