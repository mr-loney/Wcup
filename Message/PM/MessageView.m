//
//  MessageView.m
//  PM
//
//  Created by 张浩 on 14-6-12.
//  Copyright (c) 2014年 Huoli. All rights reserved.
//

#import "MessageView.h"
#import "NSString+MessageView.h"

@interface MessageView ()

- (void)initView;

- (void)didReceiveTextDidChangeNotification:(NSNotification *)notification;

@end

@implementation MessageView


#pragma mark -- initialication
- (void)initView
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveTextDidChangeNotification:) name:UITextViewTextDidChangeNotification object:self];
    
    _placeHolderTextColor = [UIColor lightGrayColor];
    
    self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    self.scrollIndicatorInsets = UIEdgeInsetsMake(10.0f, 0.0f, 10.0f, 8.0f);
    self.contentInset = UIEdgeInsetsZero;
    self.scrollEnabled = YES;
    self.scrollsToTop = NO;
    self.userInteractionEnabled = YES;
    self.font = [UIFont systemFontOfSize:14.0f];
    self.textColor = [UIColor blackColor];
    self.textAlignment = NSTextAlignmentLeft;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initView];
    }
    return self;
}

#pragma mark -- Setter
- (void)setPlaceHolder:(NSString *)placeHolder
{
    if ([_placeHolder isEqualToString:placeHolder]) {
        return;
    }
    NSUInteger maxCharacters = [MessageView maxCharacterPerLine];
    if (placeHolder.length > maxCharacters) {
        placeHolder = [placeHolder substringToIndex:maxCharacters-6];
        placeHolder = [[placeHolder trimWihteSpace] stringByAppendingFormat:@"..."];
    }
    _placeHolder = placeHolder;
    [self setNeedsDisplay];//这个方法会调用drawRect方法
}

- (void)setPlaceHolderTextColor:(UIColor *)placeHolderTextColor
{
    if ([placeHolderTextColor isEqual:_placeHolderTextColor]) {
        return;
    }
    
    _placeHolderTextColor = placeHolderTextColor;
    [self setNeedsDisplay];
}

#pragma mark -- messageTextView
- (NSUInteger)numberOfLinesOfText
{
    return [MessageView numberOfLinesForMessage:self.text];
}

+ (NSUInteger)maxCharacterPerLine
{
    return ([UIDevice currentDevice].userInterfaceIdiom==UIUserInterfaceIdiomPhone)?33:109;
}

+ (NSUInteger)numberOfLinesForMessage:(NSString *)text
{
    return (text.length / [MessageView maxCharacterPerLine]) + 1;
}

#pragma mark -- textView overrides
- (void)setText:(NSString *)text
{
    [super setText:text];
    [self setNeedsDisplay];
}

- (void)insertText:(NSString *)text
{
    [super insertText:text];
    [self setNeedsDisplay];
}

- (void)setAttributedText:(NSAttributedString *)attributedText
{
    [super setAttributedText:attributedText];
    [self setNeedsDisplay];
}

- (void)setContentInset:(UIEdgeInsets)contentInset
{
    [super setContentInset:contentInset];
    [self setNeedsDisplay];
}

- (void)setFont:(UIFont *)font
{
    [super setFont:font];
    [self setNeedsDisplay];
}

- (void)setTextAlignment:(NSTextAlignment)textAlignment
{
    [super setTextAlignment:textAlignment];
    [self setNeedsDisplay];
}

//so， above codes are not needed .may be

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    if (self.text.length==0 && self.placeHolder) {
        CGRect placeHolderRect = CGRectMake(10.0f, 7.0f, rect.size.width, rect.size.height);
        [_placeHolderTextColor set];
        
        if (NSFoundationVersionNumber > NSFoundationVersionNumber_iOS_6_0) {
            //段的样式，包括缩进，对齐，间距等参数
            NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
            paragraphStyle.lineBreakMode = NSLineBreakByTruncatingTail;
            paragraphStyle.alignment = self.textAlignment;
            [self.placeHolder drawInRect:placeHolderRect
                          withAttributes:@{
                                           NSFontAttributeName:self.font,
                                           NSForegroundColorAttributeName:self.placeHolderTextColor,
                                           NSParagraphStyleAttributeName:paragraphStyle
                                           }];
        } else {
            [_placeHolder drawInRect:placeHolderRect withFont:self.font lineBreakMode:NSLineBreakByTruncatingTail alignment:self.textAlignment];
        }
        
        
    }
}

- (void)didReceiveTextDidChangeNotification:(NSNotification *)notification
{
    [self setNeedsDisplay];
}


- (void)dealloc
{
    _placeHolderTextColor = nil;
    _placeHolder = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextViewTextDidChangeNotification object:self];
}

@end
