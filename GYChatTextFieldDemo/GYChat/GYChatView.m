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
    GYChatInputCustomViewItem *_chatCustomViewItem;
    CGRect _changeBtnFrame;
    CGRect _style1BackFrame;
    CGRect _style2BackFrame;
    UIButton *_changeBtn;
    GYChatInputCustomView *_chatInputCustomView;
    GYChatInputStyle1View *_chatInputStyle1View;
    GYVoiceInputPromptView *_voiceInputPromtView;
}
- (instancetype)initWithFrame:(GYConfigChatViewItem *)item
{
    self = [super initWithFrame:item.inputViewFrame];
    if(self)
    {
        _item = item;
//        self.backgroundColor = [UIColor greenColor];
        [self setChatInputCustomViewItem];
        [self setBackViewFrame];
        [self configUI];
        [self addTapGestureRecognizer];
    }
    return self;
}
- (void)addTapGestureRecognizer
{
    UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    [self addGestureRecognizer:recognizer];
}
- (void)tapAction:(id)sender
{
    [[GYChatManager sharedManager] keyboardIsShow:NO];
}
- (void)setBackViewFrame
{
    if(_item.style == TypeChat1)
    {
        _style1BackFrame = CGRectMake(kChatType1_Style1BgX, kChatType1_Style1BgY, kScreenWidth, kChatFooterHeight);
    }
    else
    {
        _style1BackFrame = CGRectMake(_changeBtnFrame.size.width, kChatType2_Style1BgY, kScreenWidth - _changeBtnFrame.size.width, kChatFooterHeight);
    }
    _changeBtnFrame = CGRectMake(kChatType2_MenuBtnX, kChatType2_MenuBtnY, kChatType2_MenuBtnWidth, kChatType2_MenuBtnHeight);
    _style2BackFrame = CGRectMake(_changeBtnFrame.size.width, kChatType2_Style2BgY, kScreenWidth - _changeBtnFrame.size.width, kChatFooterHeight);
    _chatCustomViewItem.style = _item.style;
    _chatCustomViewItem.currentViewFrame = _style1BackFrame;
}
- (void)setContentUIFrame
{
    if(_item.style == TypeChat1)
    {
        _chatCustomViewItem.talkButtonFrame = CGRectMake(kChatType1_TalkBtnX,kChatType1_TalkBtnY, kChatType1_TalkBtnWidth, kChatType1_TalkBtnHeight);
        _chatCustomViewItem.textViewFrame = CGRectMake(kChatType1_TextViewX,kChatType1_TextViewY,kChatType1_TextViewWidth, kChatType1_TextViewHeight);
        _chatCustomViewItem.pressButtonFrame = CGRectMake(kChatType1_PressBtnX,kChatType1_PressBtnY,kChatType1_PressBtnWidth, kChatType1_PressBtnHeight);
        _chatCustomViewItem.iconButtonFrame = CGRectMake(kChatType1_IconBtnX, kChatType1_IconBtnY, kChatType1_IconBtnWidth, kChatType1_IconBtnHeight);
        _chatCustomViewItem.picButtonFrame = CGRectMake(kChatType1_PicBtnX, kChatType1_PicBtnY, kChatType1_PicBtnWidth,kChatType1_PicBtnHeight);
    }
    else
    {
        _chatCustomViewItem.talkButtonFrame = CGRectMake(kChatType2_TalkBtnX, kChatType2_TalkBtnY, kChatType2_TalkBtnWidth, kChatType2_TalkBtnHeight);
        _chatCustomViewItem.textViewFrame = CGRectMake(kChatType2_TextViewX,kChatType2_TextViewY,kChatType2_TextViewWidth, kChatType2_TextViewHeight);
        _chatCustomViewItem.pressButtonFrame = CGRectMake(kChatType2_PressBtnX,kChatType2_PressBtnY,kChatType2_PressBtnWidth, kChatType2_PressBtnHeight);
        _chatCustomViewItem.iconButtonFrame = CGRectMake(kChatType2_IconBtnX, kChatType2_IconBtnY, kChatType2_IconBtnWidth, kChatType2_IconBtnHeight);
        _chatCustomViewItem.picButtonFrame = CGRectMake(kChatType2_PicBtnX, kChatType2_PicBtnY, kChatType2_PicBtnWidth,kChatType2_PicBtnHeight);
    }
}
- (void)setChatInputCustomViewItem
{
    _chatCustomViewItem = [[GYChatInputCustomViewItem alloc] init];
    [self setContentUIFrame];
    _chatCustomViewItem.currentSuperView = self;
}

- (void)configUI
{
    [self configVoiceInputPromtUI];
    [self configBackViewByStyle];
}
- (void)configVoiceInputPromtUI
{
    [[GYChatManager sharedManager] configVoiceInputPromtUI:self callback:^(UIView *view) {
        _voiceInputPromtView = (GYVoiceInputPromptView *)view;
        [self addSubview:view];
    }];
}
- (void)configBackViewByStyle
{
    [self configChatViewStyle2MenuBtn];
    [self configCustomBackViewUI];
    [self configStyle1BackView];
}
- (void)configChatViewStyle2MenuBtn
{
    if(_item.style == TypeChat2)
    {
        //切换类型按钮
        _changeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _changeBtn.frame = _changeBtnFrame;
        _changeBtn.imageView.contentMode = UIViewContentModeCenter;
        [_changeBtn setImage:[UIImage imageNamed:kMenuBtnSelectImage] forState:UIControlStateNormal];
        [_changeBtn setImage:[UIImage imageNamed:kMenuBtnNormalImage] forState:UIControlStateSelected];
        [_changeBtn addTarget:self action:@selector(changeAction:) forControlEvents:UIControlEventTouchUpInside];
        _changeBtn.selected = NO;
        [self addSubview:_changeBtn];
    }
}
- (void)configCustomBackViewUI
{
    _chatInputCustomView = [[GYChatInputCustomView alloc] initWithItem:_chatCustomViewItem];
    if(_item.style == TypeChat1)
    {
        [self addSubview:_chatInputCustomView];
    }
}
- (void)configStyle1BackView
{
    GYButtonItem *item = [[GYButtonItem alloc] init];
    item.btnCount = kChatType2_BtnCount;
    item.btnTitles = kChatInputStyle1ViewBtnTitles;
    _chatInputStyle1View = [[GYChatInputStyle1View alloc] initWithFrame:_style2BackFrame footeBtnItem:item];

    if(_item.style == TypeChat2)
    {
         [self addSubview:_chatInputStyle1View];
    }
}
#pragma -mark ButtonClickedAction
- (void)changeAction:(id)sender
{
    UIButton *changeBtn = (UIButton *)sender;
    if(changeBtn.selected)
    {
        [_chatInputCustomView removeFromSuperview];
        [self changeView:_chatInputStyle1View frame:_style2BackFrame];
        [_chatInputCustomView menuBtnSelected:NO];
    }
    else
    {
        [_chatInputStyle1View removeFromSuperview];
        [self changeView:_chatInputCustomView frame:_style1BackFrame];
        [_chatInputCustomView menuBtnSelected:YES];
    }
//    changeBtn.selected = !changeBtn.selected;
}
- (void)changeView:(UIView *)changeToView frame:(CGRect)frame
{
    [self addSubview:changeToView];
    _changeBtn.frame = CGRectMake(_changeBtnFrame.origin.x, kScreenHeight, _changeBtnFrame.size.width, _changeBtnFrame.size.height);
    changeToView.frame = CGRectMake(frame.origin.x, kScreenHeight, frame.size.width, frame.size.height);
    [UIView animateWithDuration:kKeyboardAnimationDuration animations:^{
        changeToView.frame = frame;
        _changeBtn.frame = _changeBtnFrame;
        _changeBtn.selected = !_changeBtn.selected;
    }];
    
}
#pragma -mark publicMethod
- (void)setMuneButtonFrame:(CGRect)newFrame
{
    if(_item.style == TypeChat2)
    {
        _changeBtn.frame = newFrame;
    }
}
- (void)resetMuneButtonFrame
{
    if(_item.style == TypeChat2)
    {
        _changeBtn.frame = _changeBtnFrame;
    }
}
/*
- (void)changeChatStyle:(ChatInputViewStyle)style
{
    _item.style = style;
    [_chatInputCustomView removeFromSuperview];
    [_chatInputStyle1View removeFromSuperview];
    _chatInputCustomView = nil;
    _chatInputStyle1View = nil;
    [self setChatInputCustomViewItem];
    [self setBackViewFrame];
    [self setContentUIFrame];
    [self configBackViewByStyle];
}
*/
- (void)viewWillLayoutSubviews
{
    self.frame = [UIScreen mainScreen].bounds;
    [self setBackViewFrame];
    [self setContentUIFrame];
    _changeBtn.frame = _changeBtnFrame;
    _chatInputCustomView.frame = _style1BackFrame;
    [_chatInputCustomView viewWillLayoutSubviews];
    _chatInputStyle1View.frame = _style2BackFrame;
    [_chatInputStyle1View viewWillLayoutSubviews];
    _voiceInputPromtView.frame = self.frame;
    [_voiceInputPromtView viewWillLayoutSubviews];
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
