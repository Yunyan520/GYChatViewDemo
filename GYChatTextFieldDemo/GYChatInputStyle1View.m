//
//  GYChatInputStyle1View.m
//  GYChatTextFieldDemo
//
//  Created by lidianchao on 2017/9/5.
//  Copyright © 2017年 lidianchao. All rights reserved.
//

#import "GYChatInputStyle1View.h"

@implementation GYChatInputStyle1View
{
    CGRect _selfFrame;
    NSInteger _footeBtnCount;
}
- (instancetype)initWithFrame:(CGRect)frame footeBtnCount:(NSInteger)footeBtnCount
{
    self = [super initWithFrame:frame];
    if (self) {
        _selfFrame = frame;
        _footeBtnCount = footeBtnCount;
        [self configUI];
    }
    return self;
}
- (void)configUI
{
    for (NSInteger i = 0; i < _footeBtnCount; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        CGFloat btnWidth = _selfFrame.size.width / _footeBtnCount;
        btn.frame = CGRectMake(i * btnWidth, 0, btnWidth, _selfFrame.size.height);
        [btn setTitle:[NSString stringWithFormat:@"%ld",(long)i] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
        btn.backgroundColor = [UIColor greenColor];
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
