//
//  MessageCell.m
//  PM
//
//  Created by 张浩 on 14-6-10.
//  Copyright (c) 2014年 Huoli. All rights reserved.
//

#import "MessageCell.h"
#import "Message.h"
#import "MessageFrame.h"
#import "GridImageView.h"
#import "UIView+AddPush.h"


@interface MessageCell ()
{
    UIButton *_timeButton;
//    UIImageView *_iconView;
    GridImageView *_iconView;
    UIButton *_contentButton;
}
@end

@implementation MessageCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
  // 必须先设置clearColor,否则tableView的背景会被遮住
        self.backgroundColor = [UIColor clearColor];
        // 1、创建时间按钮
        _timeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_timeButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _timeButton.enabled = NO;
        _timeButton.titleLabel.font = kTimeFont;
        [_timeButton setBackgroundImage:[UIImage imageNamed:@"chat_timeline_bg.png"] forState:UIControlStateNormal];
        [self.contentView addSubview:_timeButton];
        
        // 2、创建头像
        
        __weak MessageCell *mesCell = self;
        _iconView = [[GridImageView alloc] init];
        _iconView.touchBlock = ^{
            [mesCell pushAction];
        };
        [self.contentView addSubview:_iconView];
        
        // 3、创建内容
        _contentButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_contentButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
        _contentButton.titleLabel.font = kContentFont;
        _contentButton.titleLabel.numberOfLines = 0;//去掉只显示一行
        [self.contentView addSubview:_contentButton];
    }
    return self;
}

- (void)setMessageFrame:(MessageFrame *)messageFrame
{
    _messageFrame = messageFrame;
    Message *message = _messageFrame.message;
    
    //设置时间
    [_timeButton setTitle:message.time forState:UIControlStateNormal];
    _timeButton.frame = _messageFrame.timeFrame;
    
    //设置头像
    _iconView.image = [UIImage imageNamed:message.icon];
    _iconView.frame = _messageFrame.iconFrame;
    
    //设置内容
    [_contentButton setTitle:message.content forState:UIControlStateNormal];
    _contentButton.contentEdgeInsets = UIEdgeInsetsMake(kContentTop, kContentLeft, kContentBottom, kContentRight);
    _contentButton.frame = _messageFrame.contentFrame;
    
    if (message.type == MessageTypeMe) {
        _contentButton.contentEdgeInsets = UIEdgeInsetsMake(kContentTop, kContentRight, kContentBottom, kContentLeft);
    }
    
    UIImage *normal, *focused;
    if (message.type == MessageTypeMe) {
        
        normal = [UIImage imageNamed:@"chatto_bg_normal.png"];
        normal = [normal stretchableImageWithLeftCapWidth:normal.size.width * 0.5 topCapHeight:normal.size.height * 0.7];
        focused = [UIImage imageNamed:@"chatto_bg_focused.png"];
        focused = [focused stretchableImageWithLeftCapWidth:focused.size.width * 0.5 topCapHeight:focused.size.height * 0.7];
        
    }else{
        
        normal = [UIImage imageNamed:@"chatfrom_bg_normal.png"];
        normal = [normal stretchableImageWithLeftCapWidth:normal.size.width * 0.5 topCapHeight:normal.size.height * 0.7];
        focused = [UIImage imageNamed:@"chatfrom_bg_focused.png"];
        focused = [focused stretchableImageWithLeftCapWidth:focused.size.width * 0.5 topCapHeight:focused.size.height * 0.7];
        
    }
    
    [_contentButton setBackgroundImage:normal forState:UIControlStateNormal];
    [_contentButton setBackgroundImage:focused forState:UIControlStateHighlighted];
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)pushAction
{
    [self.viewController.navigationController pushViewController:[[UIViewController alloc] init] animated:YES];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
