//
//  GYChatInputStyle1View.m
//  GYChatTextFieldDemo
//
//  Created by lidianchao on 2017/9/5.
//  Copyright © 2017年 lidianchao. All rights reserved.
//

#import "GYChatInputStyle1View.h"
#define kFooterBtnBaseTag 9000
@implementation GYButtonItem



@end

@implementation GYChatInputStyle1View
{
    CGRect _selfFrame;
    GYButtonItem *_footeBtnItem;
}
- (instancetype)initWithFrame:(CGRect)frame footeBtnItem:(GYButtonItem *)item
{
    self = [super initWithFrame:frame];
    if (self) {
//        self.backgroundColor = [UIColor blueColor];
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
        btn.frame = CGRectMake(i * btnWidth, 10, btnWidth, 30);
        [btn setTitle:_footeBtnItem.btnTitles[i] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
        btn.backgroundColor = [UIColor grayColor];
        btn.tag = kFooterBtnBaseTag + i;
        [self addSubview:btn];
    }
}
- (void)viewWillLayoutSubviews
{
    CGRect selfFrame = self.frame;
    NSInteger count = _footeBtnItem.btnCount;
    for (NSInteger i = 0; i < count; i++) {
        UIButton *btn = (UIButton *)[self viewWithTag:i + kFooterBtnBaseTag];
        CGFloat btnWidth = selfFrame.size.width / count;
        btn.frame = CGRectMake(i * btnWidth, 10, btnWidth, 30);
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
