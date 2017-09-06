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
        _style1BackFrame = CGRectMake(GY_ChatType1_Style1BgX, GY_ChatType1_Style1BgY, _item.inputViewFrame.size.width, _item.inputViewFrame.size.height);
    }
    else
    {
        _muneBtnFrame = CGRectMake(GY_ChatType2_MenuBtnX, GY_ChatType2_MenuBtnY, GY_ChatType2_MenuBtnWidth, GY_ChatType2_MenuBtnHeight);
        _style1BackFrame = CGRectMake(_muneBtnFrame.size.width, GY_ChatType2_Style1BgY, _item.inputViewFrame.size.width - _muneBtnFrame.size.width, _item.inputViewFrame.size.height);
        _style2BackFrame = CGRectMake(_muneBtnFrame.size.width, GY_ChatType2_Style2BgY, _item.inputViewFrame.size.width - _muneBtnFrame.size.width, _item.inputViewFrame.size.height);
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
        chatCustomViewItem.talkButtonFrame = CGRectMake(GY_ChatType1_TalkBtnX, GY_ChatType1_TalkBtnY, GY_ChatType1_TalkBtnWidth, GY_ChatType1_TalkBtnHeight);
        chatCustomViewItem.textViewFrame = CGRectMake(GY_ChatType1_TextViewX,GY_ChatType1_TextViewY,GY_ChatType1_TextViewWidth, GY_ChatType1_TextViewHeight);
        chatCustomViewItem.pressButtonFrame = CGRectMake(GY_ChatType1_PressBtnX,GY_ChatType1_PressBtnY,GY_ChatType1_PressBtnWidth, GY_ChatType1_PressBtnHeight);
        chatCustomViewItem.iconButtonFrame = CGRectMake(GY_ChatType1_IconBtnX, GY_ChatType1_IconBtnY, GY_ChatType1_IconBtnWidth, GY_ChatType1_IconBtnHeight);
        chatCustomViewItem.picButtonFrame = CGRectMake(GY_ChatType1_PicBtnX, GY_ChatType1_PicBtnY, GY_ChatType1_PicBtnWidth,GY_ChatType1_PicBtnHeight);
    }
    else
    {
        chatCustomViewItem.talkButtonFrame = CGRectMake(GY_ChatType2_TalkBtnX, GY_ChatType2_TalkBtnY, GY_ChatType2_TalkBtnWidth, GY_ChatType2_TalkBtnHeight);
        chatCustomViewItem.textViewFrame = CGRectMake(GY_ChatType2_TextViewX,GY_ChatType2_TextViewY,GY_ChatType2_TextViewWidth, GY_ChatType2_TextViewHeight);
        chatCustomViewItem.pressButtonFrame = CGRectMake(GY_ChatType2_PressBtnX,GY_ChatType2_PressBtnY,GY_ChatType2_PressBtnWidth, GY_ChatType2_PressBtnHeight);
        chatCustomViewItem.iconButtonFrame = CGRectMake(GY_ChatType2_IconBtnX, GY_ChatType2_IconBtnY, GY_ChatType2_IconBtnWidth, GY_ChatType2_IconBtnHeight);
        chatCustomViewItem.picButtonFrame = CGRectMake(GY_ChatType2_PicBtnX, GY_ChatType2_PicBtnY, GY_ChatType2_PicBtnWidth,GY_ChatType2_PicBtnHeight);
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
