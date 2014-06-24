//
//  MessageFrame.m
//  PM
//
//  Created by 张浩 on 14-6-10.
//  Copyright (c) 2014年 Huoli. All rights reserved.
//

#import "MessageFrame.h"
#import "Message.h"

@implementation MessageFrame

- (void)setMessage:(Message *)message
{
    _message = message;
    // 计算时间的位置
    if (_showTime) {
        CGFloat timeY = kMargin;

        CGSize timeSize = [_message.time sizeWithFont:kTimeFont];
        
        
        CGFloat timeX = (SCREENWIDTH - timeSize.width) / 2;
        _timeFrame = CGRectMake(timeX, timeY, timeSize.width+kTimeMarginW, timeSize.height+kTimeMarginH);
        
    }
    
    
    //计算头像的位置
    CGFloat iconX = kMargin;
    //如果是自己发的消息，头像在右边
    if (_message.type == MessageTypeMe) {
        iconX = SCREENWIDTH - kMargin - kIconWH;
    }
    
    CGFloat iconY = CGRectGetMaxY(_timeFrame) + kMargin;
    _iconFrame = CGRectMake(iconX, iconY, kIconWH, kIconWH);
    
    //计算内容位置
    CGFloat contentX = CGRectGetMaxX(_iconFrame)+kMargin;
    CGFloat contentY = iconY;//内容和头像一样高
    
    CGSize contentSize = [_message.content sizeWithFont:kContentFont constrainedToSize:CGSizeMake(kContentW, CGFLOAT_MAX)];
//    NSLog(@"---%@", NSStringFromCGSize(contentSize));
    
    if (_message.type == MessageTypeMe) {
        contentX = iconX - kMargin - contentSize.width - kContentLeft - kContentRight;
    }
    
    
    _contentFrame = CGRectMake(contentX, contentY, contentSize.width + kContentLeft + kContentRight, contentSize.height + kContentTop + kContentBottom);
//    NSLog(@"%@", NSStringFromCGRect(_contentFrame));
    
    // 计算高度
    _cellHeight = MAX(CGRectGetMaxY(_contentFrame), CGRectGetMidY(_iconFrame)+kMargin);
    // 有的消息可能不如头像那部分的frame高，所以两者取大。
}

@end
