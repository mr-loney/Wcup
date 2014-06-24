//
//  MessageListViewController.h
//  PM
//
//  Created by 张浩 on 14-6-11.
//  Copyright (c) 2014年 Huoli. All rights reserved.
//

#import "BaseViewController.h"


@interface MessageListViewController : BaseViewController<UITableViewDataSource, UITableViewDelegate, UITextViewDelegate>
{
    UITableView *listView;
    NSMutableArray *_allMessagesFrame;

    
}

@property (assign, nonatomic) CGFloat previousTextViewContentHeight;
@property (assign, nonatomic, readonly) UIEdgeInsets originalTableViewContentInset;



@end
