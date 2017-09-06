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

#import "GYChatInputStyle1View.h"
@interface GYChatView()<UITextViewDelegate>

@end

@implementation GYChatView
{
    GYConfigChatViewItem *_item;
    CGRect _muneBtnFrame;
    CGRect _style1BackFrame;
    CGRect _style2BackFrame;
    GYChatInputCustomView *_chatInputCustomView;
    GYChatInputStyle1View *_chatInputStyle1View;
}
- (instancetype)initWithFrame:(GYConfigChatViewItem *)item
{
    self = [super initWithFrame:item.inputViewFrame];
    if(self)
    {
        _item = item;
        [self setBackViewFrame];
        [self configUI];
    }
    return self;
}
- (void)setBackViewFrame
{
    if(_item.style == TypeChat1)
    {
        _style1BackFrame = CGRectMake(0, 0, _item.inputViewFrame.size.width, _item.inputViewFrame.size.height);
    }
    else
    {
        _muneBtnFrame = CGRectMake(0, 7, 45, 30);
        _style1BackFrame = CGRectMake(_muneBtnFrame.size.width, 0, _item.inputViewFrame.size.width - _muneBtnFrame.size.width, _item.inputViewFrame.size.height);
        _style2BackFrame = CGRectMake(_muneBtnFrame.size.width, 0, _item.inputViewFrame.size.width - _muneBtnFrame.size.width, _item.inputViewFrame.size.height);
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
    if(_item.style == TypeChat1)
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
    if(_item.style == TypeChat1)
    {
        chatCustomViewItem.talkButtonFrame = CGRectMake(5, 7, 30, 30);
        chatCustomViewItem.textViewFrame = CGRectMake(40,5,self.frame.size.width-128, 34);
        chatCustomViewItem.pressButtonFrame = CGRectMake(40,5,self.frame.size.width-128, 34);
        chatCustomViewItem.iconButtonFrame = CGRectMake(self.frame.size.width-81, 7, 30, 30);
        chatCustomViewItem.picButtonFrame = CGRectMake(self.frame.size.width-50, 7, 50,30);
    }
    else
    {
        chatCustomViewItem.talkButtonFrame = CGRectMake(5, 7, 30, 30);
        chatCustomViewItem.textViewFrame = CGRectMake(40,5,self.frame.size.width-168, 34);
        chatCustomViewItem.pressButtonFrame = CGRectMake(40,5,self.frame.size.width-168, 34);
        chatCustomViewItem.iconButtonFrame = CGRectMake(self.frame.size.width-121, 7, 30, 30);
        chatCustomViewItem.picButtonFrame = CGRectMake(self.frame.size.width-90, 7, 50,30);
    }
    chatCustomViewItem.currentSuperView = self;
    _chatInputCustomView = [[GYChatInputCustomView alloc] initWithFrame:_style1BackFrame item:chatCustomViewItem];
     [self addSubview:_chatInputCustomView];
}

- (void)configStyle1BackView
{
    _chatInputStyle1View = [[GYChatInputStyle1View alloc] initWithFrame:_style2BackFrame footeBtnCount:_item.type2footerBtnCount];
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
        [self addSubview:_chatInputStyle1View];
        menuBtn.selected = YES;
        [_chatInputCustomView menuBtnSelected:NO];
    }
}
#pragma -mark publicMethod
- (void)resetFrame
{
    self.frame = _item.inputViewFrame;
}
- (void)changeFrame:(CGRect)newFrame
{
    self.frame = newFrame;
}
- (GYChatInputCustomView *)getChatInputCustomView
{
    return _chatInputCustomView;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
