//
//  GridImageView.m
//  PM
//
//  Created by 张浩 on 14-6-10.
//  Copyright (c) 2014年 Huoli. All rights reserved.
//

#import "GridImageView.h"

@implementation GridImageView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {

        self.userInteractionEnabled = YES;
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapActions:)];
        [self addGestureRecognizer:tapGesture];
    }
    return self;
}

- (void)tapActions:(UITapGestureRecognizer *)tap
{
    if (self.touchBlock) {
        _touchBlock();
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
