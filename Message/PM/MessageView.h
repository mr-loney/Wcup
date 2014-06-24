//
//  MessageView.h
//  PM
//
//  Created by 张浩 on 14-6-12.
//  Copyright (c) 2014年 Huoli. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, MessageVIewType) {
    MessageViewInputTypeNormal = 0,
    MessageViewInputTypeText,
    MessageViewInputTypeEmotion,
    MessageViewInputTypeShareMenu
};

@interface MessageView : UITextView
/**
 * 提标用户输入的标语
 */
@property (nonatomic, copy) NSString *placeHolder;

/**
 * 标语的文本颜色
 */
@property (nonatomic, strong) UIColor *placeHolderTextColor;

/**
 * 获取自身文本占据有多少行，@return 行数
 */
- (NSUInteger)numberOfLinesOfText;

/**
 * 获取每行的高度 @return 根据iPhone或者iPad来获取每行字体的高度
 */
+ (NSUInteger)maxCharacterPerLine;

/**
 * 获取某段文本占据自身适应宽度的行数
 */
+ (NSUInteger)numberOfLinesForMessage:(NSString *)text;

@end
