//
//  MessageFrame.h
//  PM
//
//  Created by 张浩 on 14-6-10.
//  Copyright (c) 2014年 Huoli. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kMargin 10 // 间隔
#define kIconWH 45 // 头像宽高
#define kContentW 180 //内容宽度

#define kTimeMarginW 20 // 时间文本与边框间隔宽度方向(两边总和)
#define kTimeMarginH 10 // 时间文本与边框间隔高度方向(两边总和)

#define kContentTop 10 //文本内容与按钮上边缘间隔
#define kContentLeft 25 //文本内容与按钮左边缘间隔
#define kContentBottom 15 //文本内容与按钮下边缘间隔
#define kContentRight 15 //文本内容与按钮右边缘间隔

#define kTimeFont [UIFont systemFontOfSize:12] //时间字体
#define kContentFont [UIFont systemFontOfSize:16] //内容字体


@class Message;
@interface MessageFrame : NSObject



@property (nonatomic, assign, readonly) CGRect iconFrame;
@property (nonatomic, assign, readonly) CGRect timeFrame;
@property (nonatomic, assign, readonly) CGRect contentFrame;

@property (nonatomic, assign, readonly) CGFloat cellHeight;
@property (nonatomic, strong) Message *message;
@property (nonatomic, assign) BOOL showTime;



@end
