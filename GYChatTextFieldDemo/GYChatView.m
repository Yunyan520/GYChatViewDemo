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
    UIButton *_muneButton;
    GYChatInputCustomView *_chatInputCustomView;
    GYChatInputStyle1View *_chatInputStyle1View;
}
- (instancetype)initWithFrame:(GYConfigChatViewItem *)item
{
    self = [super initWithFrame:item.inputViewFrame];
    if(self)
    {
        _item = item;
//        self.backgroundColor = [UIColor redColor];
        [self setBackViewFrame];
        [self configUI];
    }
    return self;
}
- (void)setBackViewFrame
{
    if(_item.style == TypeChat1)
    {
        _style1BackFrame = CGRectMake(kChatType1_Style1BgX, kChatType1_Style1BgY, _item.inputViewFrame.size.width, kChatFooterHeight);
    }
    else
    {
        _muneBtnFrame = CGRectMake(kChatType2_MenuBtnX, kChatType2_MenuBtnY, kChatType2_MenuBtnWidth, kChatType2_MenuBtnHeight);
        _style1BackFrame = CGRectMake(_muneBtnFrame.size.width, kChatType2_Style1BgY, _item.inputViewFrame.size.width - _muneBtnFrame.size.width, kChatFooterHeight);
        _style2BackFrame = CGRectMake(_muneBtnFrame.size.width, kChatType2_Style2BgY, _item.inputViewFrame.size.width - _muneBtnFrame.size.width, kChatFooterHeight);
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
    _muneButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _muneButton.frame = _muneBtnFrame;
    _muneButton.imageView.contentMode = UIViewContentModeCenter;
    [_muneButton setBackgroundImage:[UIImage imageNamed:@"Mode_texttolist.png"] forState:UIControlStateNormal];
    [_muneButton setBackgroundImage:[UIImage imageNamed:@"Mode_listtotext.png"] forState:UIControlStateSelected];
    [_muneButton addTarget:self action:@selector(menuAction:) forControlEvents:UIControlEventTouchUpInside];
    _muneButton.selected = NO;
    [self addSubview:_muneButton];
}
- (void)configCustomBackViewUI
{
    GYChatInputCustomViewItem *chatCustomViewItem = [[GYChatInputCustomViewItem alloc] init];
    if(_item.style == TypeChat1)
    {
        chatCustomViewItem.talkButtonFrame = CGRectMake(kChatType1_TalkBtnX,kChatType1_TalkBtnY, kChatType1_TalkBtnWidth, kChatType1_TalkBtnHeight);
        chatCustomViewItem.textViewFrame = CGRectMake(kChatType1_TextViewX,kChatType1_TextViewY,kChatType1_TextViewWidth, kChatType1_TextViewHeight);
        chatCustomViewItem.pressButtonFrame = CGRectMake(kChatType1_PressBtnX,kChatType1_PressBtnY,kChatType1_PressBtnWidth, kChatType1_PressBtnHeight);
        chatCustomViewItem.iconButtonFrame = CGRectMake(kChatType1_IconBtnX, kChatType1_IconBtnY, kChatType1_IconBtnWidth, kChatType1_IconBtnHeight);
        chatCustomViewItem.picButtonFrame = CGRectMake(kChatType1_PicBtnX, kChatType1_PicBtnY, kChatType1_PicBtnWidth,kChatType1_PicBtnHeight);
    }
    else
    {
        chatCustomViewItem.talkButtonFrame = CGRectMake(kChatType2_TalkBtnX, kChatType2_TalkBtnY, kChatType2_TalkBtnWidth, kChatType2_TalkBtnHeight);
        chatCustomViewItem.textViewFrame = CGRectMake(kChatType2_TextViewX,kChatType2_TextViewY,kChatType2_TextViewWidth, kChatType2_TextViewHeight);
        chatCustomViewItem.pressButtonFrame = CGRectMake(kChatType2_PressBtnX,kChatType2_PressBtnY,kChatType2_PressBtnWidth, kChatType2_PressBtnHeight);
        chatCustomViewItem.iconButtonFrame = CGRectMake(kChatType2_IconBtnX, kChatType2_IconBtnY, kChatType2_IconBtnWidth, kChatType2_IconBtnHeight);
        chatCustomViewItem.picButtonFrame = CGRectMake(kChatType2_PicBtnX, kChatType2_PicBtnY, kChatType2_PicBtnWidth,kChatType2_PicBtnHeight);
    }
    chatCustomViewItem.currentSuperView = self;
    _chatInputCustomView = [[GYChatInputCustomView alloc] initWithFrame:_style1BackFrame item:chatCustomViewItem];
//    _chatInputCustomView.backgroundColor = [UIColor redColor];
     [self addSubview:_chatInputCustomView];
}

- (void)configStyle1BackView
{
    ButtonItem *item = [[ButtonItem alloc] init];
    item.btnCount = 2;
    item.btnTitles = @[@"功能介绍",@"人工服务"];
    _chatInputStyle1View = [[GYChatInputStyle1View alloc] initWithFrame:_style2BackFrame footeBtnItem:item];
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
- (void)setMuneButtonFrame:(CGRect)newFrame
{
    if(_item.style == TypeChat2)
    {
        _muneButton.frame = newFrame;
    }
}
- (void)resetMuneButtonFrame
{
    if(_item.style == TypeChat2)
    {
        _muneButton.frame = _muneBtnFrame;
    }
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
