//
//  GYChatView.m
//  GYChatTextFieldDemo
//
//  Created by lidianchao on 2017/8/30.
//  Copyright © 2017年 lidianchao. All rights reserved.
//

#import "GYChatView.h"
#import "GYScreen.h"
#import "GYMotionView.h"
#import "GYPicView.h"
#import "GYChatInputCustomView.h"
#import "GYChatInputStyle1View.h"
@interface GYChatView()<UITextViewDelegate>

@end

@implementation GYChatView
{
    ChatInputViewStyle _viewStyle;
    CGRect _selfFrame;
    CGRect _muneBtnFrame;
    CGRect _style1BackFrame;
    CGRect _style2BackFrame;
    GYChatInputCustomView *_chatInputCustomView;
    GYChatInputStyle1View *_chatInputStyle1View;
}
- (instancetype)initWithFrame:(CGRect)frame viewStyle:(ChatInputViewStyle)style{
    self = [super initWithFrame:frame];
    if(self)
    {
        _selfFrame = frame;
        _viewStyle = style;
        [self setBackViewFrame];
        [self configUI];
    }
    return self;
}
- (void)setBackViewFrame
{
    if(_viewStyle == TypeChat1)
    {
        _style1BackFrame = CGRectMake(0, 0, _selfFrame.size.width, _selfFrame.size.height);
    }
    else
    {
        _muneBtnFrame = CGRectMake(0, 5+2, 45, 30);
        _style1BackFrame = CGRectMake(_muneBtnFrame.size.width, 0, _selfFrame.size.width - _muneBtnFrame.size.width, _selfFrame.size.height);
        _style2BackFrame = CGRectMake(_muneBtnFrame.size.width, 0, _selfFrame.size.width - _muneBtnFrame.size.width, _selfFrame.size.height);
    }
}
- (void)configUI
{
    [self configChatViewStyle2MenuBtn];
    [self configCustomBackViewUI];
    [self configStyle1BackView];
}
- (void)configChatViewStyle2MenuBtn
{
    if(_viewStyle == TypeChat1)
    {
        return;
    }
    //切换类型按钮
    UIButton *muneButton = [UIButton buttonWithType:UIButtonTypeCustom];
    muneButton.frame = _muneBtnFrame;
    muneButton.imageView.contentMode = UIViewContentModeCenter;
    [muneButton setBackgroundImage:[UIImage imageNamed:@"Mode_texttolist.png"] forState:UIControlStateNormal];
    [muneButton setBackgroundImage:[UIImage imageNamed:@"Mode_listtotext.png"] forState:UIControlStateSelected];
    [muneButton addTarget:self action:@selector(menuAction:) forControlEvents:UIControlEventTouchUpInside];
    muneButton.selected = NO;
    [self addSubview:muneButton];
}
- (void)configCustomBackViewUI
{
    GYChatInputCustomViewItem *chatCustomViewItem = [[GYChatInputCustomViewItem alloc] init];
    if(_viewStyle == TypeChat1)
    {
        chatCustomViewItem.talkButtonFrame = CGRectMake(5, 5+2, 30, 30);
        chatCustomViewItem.textViewFrame = CGRectMake(40,5,self.frame.size.width-128, 34);
        chatCustomViewItem.pressButtonFrame = CGRectMake(40,5,self.frame.size.width-128, 34);
        chatCustomViewItem.iconButtonFrame = CGRectMake(self.frame.size.width-85+4, 5+2, 30, 30);
        chatCustomViewItem.picButtonFrame = CGRectMake(self.frame.size.width-50, 5+2, 50,30);
    }
    else
    {
        chatCustomViewItem.talkButtonFrame = CGRectMake(5, 5+2, 30, 30);
        chatCustomViewItem.textViewFrame = CGRectMake(40,5,self.frame.size.width-168, 34);
        chatCustomViewItem.pressButtonFrame = CGRectMake(40,5,self.frame.size.width-168, 34);
        chatCustomViewItem.iconButtonFrame = CGRectMake(self.frame.size.width-125+4, 5+2, 30, 30);
        chatCustomViewItem.picButtonFrame = CGRectMake(self.frame.size.width-90, 5+2, 50,30);
    }
    chatCustomViewItem.currentSuperView = self;
    _chatInputCustomView = [[GYChatInputCustomView alloc] initWithFrame:_style1BackFrame item:chatCustomViewItem];
     [self addSubview:_chatInputCustomView];
}

- (void)configStyle1BackView
{
    _chatInputStyle1View = [[GYChatInputStyle1View alloc] initWithFrame:_style2BackFrame];
    _chatInputStyle1View.backgroundColor = [UIColor greenColor];
}
#pragma -mark ButtonClickedAction
- (void)menuAction:(id)sender
{
    UIButton *menuBtn = (UIButton *)sender;
    if(menuBtn.selected)
    {
        [_chatInputStyle1View removeFromSuperview];
        [self addSubview:_chatInputCustomView];
        menuBtn.selected = NO;
        [_chatInputCustomView menuBtnSelected:YES];
    }
    else
    {
        [_chatInputCustomView removeFromSuperview];
        [self addSubview:_chatInputCustomView];
        menuBtn.selected = YES;
        [_chatInputCustomView menuBtnSelected:NO];
    }
}
- (void)resetFrame
{
    self.frame = _selfFrame;
}
- (void)changeFrame:(CGRect)newFrame
{
    self.frame = newFrame;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
