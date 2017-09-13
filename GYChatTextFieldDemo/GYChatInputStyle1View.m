//
//  GYChatInputStyle1View.m
//  GYChatTextFieldDemo
//
//  Created by lidianchao on 2017/9/5.
//  Copyright © 2017年 lidianchao. All rights reserved.
//

#import "GYChatInputStyle1View.h"

@implementation ButtonItem



@end

@implementation GYChatInputStyle1View
{
    CGRect _selfFrame;
    ButtonItem *_footeBtnItem;
}
- (instancetype)initWithFrame:(CGRect)frame footeBtnItem:(ButtonItem *)item
{
    self = [super initWithFrame:frame];
    if (self) {
        _selfFrame = frame;
        _footeBtnItem = item;
        [self configUI];
    }
    return self;
}
- (void)configUI
{
    NSInteger count = _footeBtnItem.btnCount;
    for (NSInteger i = 0; i < count; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        CGFloat btnWidth = _selfFrame.size.width / count;
        btn.frame = CGRectMake(i * btnWidth, 0, btnWidth, _selfFrame.size.height);
        [btn setTitle:_footeBtnItem.btnTitles[i] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
        btn.backgroundColor = [UIColor grayColor];
        [self addSubview:btn];
    }
}
- (void)btnClicked:(id)sender
{
    
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
