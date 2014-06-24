//
//  GridImageView.h
//  PM
//
//  Created by 张浩 on 14-6-10.
//  Copyright (c) 2014年 Huoli. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ImageBlock)(void);

@interface GridImageView : UIImageView

@property (nonatomic, copy) ImageBlock touchBlock;

@end
