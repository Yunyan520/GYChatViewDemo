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
#define kKeyboardAnimationDuration 0.25
@interface GYChatView()<UITextViewDelegate>

@end

@implementation GYChatView
{
    UITextView *_textView;
    UIButton *_pressButton;
    UIButton *_talkButton;
    UIButton *_picButton;
    UIButton *_iconButton;
    UIButton *_muneButton;
    ChatInputViewStyle _viewStyle;
    CGRect _selfFrame;
    CGRect _motionViewFrame;
    CGRect _picViewFrame;
    GYMotionView *_motionView;
    GYPicView *_picView;
    NSMutableString *_messageString;
    //根据View样式确定UIFrame;
    CGRect _talkBtnFrame;
    CGRect _textViewFrame;
    CGRect _pressBtnFrame;
    CGRect _iconBtnFrame;
    CGRect _picBtnFrame;
    CGRect _muneBtnFrame;
    CGRect _style1BackFrame;
    CGRect _style2BackFrame;
    UIView *_chatStyle1BackView;
    UIView *_chatStyle2BackView;
    BOOL _keyboradIsShow;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        _selfFrame = frame;
        [self configUI];
        [self configMotionView];
        [self configPicView];
        [self registerForKeyboardNotifications];
    }
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame viewStyle:(ChatInputViewStyle)style{
    self = [super initWithFrame:frame];
    if(self)
    {
        _selfFrame = frame;
        _viewStyle = style;
        [self setUIFrame];
        [self configUI];
        [self configMotionView];
        [self configPicView];
        [self registerForKeyboardNotifications];
    }
    return self;
}
//根据View样式确定UIFrame;
- (void)setUIFrame
{
    if(_viewStyle == TypeChat1)
    {
        _style1BackFrame = CGRectMake(0, 0, _selfFrame.size.width, _selfFrame.size.height);
        _talkBtnFrame = CGRectMake(5, 5+2, 30, 30);
        if (IOS7_OR_LATER)
        {
            _textViewFrame = CGRectMake(40,5,self.frame.size.width-128, 34);
            _pressBtnFrame = CGRectMake(40,5,self.frame.size.width-128, 34);
            _iconBtnFrame = CGRectMake(self.frame.size.width-85+4, 5+2, 30, 30);
        }
        else
        {
            _textViewFrame = CGRectMake(40,5,self.frame.size.width-122, 34);
            _pressBtnFrame = CGRectMake(40,5,self.frame.size.width-122, 34);
            _iconBtnFrame = CGRectMake(self.frame.size.width-85+8, 5+2, 30, 30);
        }
        _picBtnFrame = CGRectMake(self.frame.size.width-50, 5+2, 50,30);
    }
    else
    {
        _muneBtnFrame = CGRectMake(0, 5+2, 45, 30);
        _style1BackFrame = CGRectMake(_muneBtnFrame.size.width, 0, _selfFrame.size.width - _muneBtnFrame.size.width, _selfFrame.size.height);
        _style2BackFrame = CGRectMake(_muneBtnFrame.size.width, 0, _selfFrame.size.width - _muneBtnFrame.size.width, _selfFrame.size.height);
        _talkBtnFrame = CGRectMake(5, 5+2, 30, 30);
        if (IOS7_OR_LATER)
        {
            _textViewFrame = CGRectMake(40,5,self.frame.size.width-168, 34);
            _pressBtnFrame = CGRectMake(40,5,self.frame.size.width-168, 34);
            _iconBtnFrame = CGRectMake(self.frame.size.width-125+4, 5+2, 30, 30);
        }
        else
        {
            _textViewFrame = CGRectMake(40,5,self.frame.size.width-162, 34);
            _pressBtnFrame = CGRectMake(40,5,self.frame.size.width-162, 34);
            _iconBtnFrame = CGRectMake(self.frame.size.width-125+8, 5+2, 30, 30);
        }
        _picBtnFrame = CGRectMake(self.frame.size.width-90, 5+2, 50,30);
    }
}
- (void)configUI
{
    [self configBackView];
    [self configChatViewStyle2MenuBtn];
    [self configVoiceInputUI];
    [self configMotionPicSendUI];
}
- (void)configBackView
{
    _chatStyle1BackView = [[UIView alloc] initWithFrame:_style1BackFrame];
    _chatStyle2BackView = [[UIView alloc] initWithFrame:_style2BackFrame];
    _chatStyle2BackView.backgroundColor = [UIColor greenColor];
    [self addSubview:_chatStyle1BackView];
}
- (void)configChatViewStyle2MenuBtn
{
    if(_viewStyle == TypeChat1)
    {
        return;
    }
    _muneButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _muneButton.frame = _muneBtnFrame;
    _muneButton.imageView.contentMode = UIViewContentModeCenter;
    [_muneButton setBackgroundImage:[UIImage imageNamed:@"Mode_texttolist.png"] forState:UIControlStateNormal];
    [_muneButton setBackgroundImage:[UIImage imageNamed:@"Mode_listtotext.png"] forState:UIControlStateSelected];
    [_muneButton addTarget:self action:@selector(menuAction:) forControlEvents:UIControlEventTouchUpInside];
    _muneButton.selected = NO;
    [self addSubview:_muneButton];
}
- (void)configVoiceInputUI
{
    //文本输入框
    _textView = [[UITextView alloc] init];
    _textView.frame = _textViewFrame;
    _textView.backgroundColor = [UIColor grayColor];
    _textView.layer.cornerRadius = 5;
    _textView.delegate = self;
    _textView.returnKeyType = UIReturnKeySend;
    [_chatStyle1BackView addSubview:_textView];
    
    //语音发送按钮
    _pressButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _pressButton.frame = _pressBtnFrame;
    _pressButton.hidden = YES;
    [_pressButton setBackgroundImage:[UIImage imageNamed:@"speaking_Button.png"] forState:UIControlStateNormal];
    [_pressButton setBackgroundImage:[UIImage imageNamed:@"speaking_Button_click.png"] forState:UIControlStateHighlighted];
    [_pressButton setBackgroundImage:[UIImage imageNamed:@"speaking_Button_click.png"] forState:UIControlStateSelected];
    [_pressButton setBackgroundImage:[UIImage imageNamed:@"speaking_Button_click.png"] forState:UIControlStateDisabled];
    [_pressButton setTitle:@"按住说话" forState:UIControlStateNormal];
    [_pressButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_pressButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [_pressButton setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [_pressButton addTarget:self action:@selector(recordTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
    [_pressButton addTarget:self action:@selector(recordTouchUpOutside:) forControlEvents:UIControlEventTouchUpOutside];
    [_pressButton addTarget:self action:@selector(recordTouchDown:) forControlEvents:UIControlEventTouchDown];
    [_pressButton addTarget:self action:@selector(recordTouchDragOutside:) forControlEvents: UIControlEventTouchDragOutside];
    [_pressButton addTarget:self action:@selector(recordTouchDragIn:) forControlEvents: UIControlEventTouchDragInside];
    [_chatStyle1BackView addSubview:_pressButton];
}
- (void)configMotionPicSendUI
{
    //	录音按钮
    _talkButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _talkButton.frame = _talkBtnFrame;
    [_talkButton setImage:[UIImage imageNamed:@"Fav_Search_Voice.png"] forState:UIControlStateNormal];
    [_talkButton setImage:[UIImage imageNamed:@"Keyboard_ios.png"] forState:UIControlStateSelected];
    [_talkButton addTarget:self action:@selector(talkAction:) forControlEvents:UIControlEventTouchUpInside];
    [_chatStyle1BackView addSubview:_talkButton];
    //	表情选择按钮
    _iconButton = [UIButton buttonWithType:UIButtonTypeCustom];

    _iconButton.frame = _iconBtnFrame;
    [_iconButton setImage:[UIImage imageNamed:@"Album_ToolViewEmotion.png"] forState:UIControlStateNormal];
    [_iconButton setImage:[UIImage imageNamed:@"Keyboard_ios.png"] forState:UIControlStateSelected];
    [_iconButton addTarget:self action:@selector(moodIconAction:) forControlEvents:UIControlEventTouchUpInside];
    [_chatStyle1BackView addSubview:_iconButton];
    
    //	图片选择按钮
    _picButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _picButton.frame = _picBtnFrame;
    [_picButton setImage:[UIImage imageNamed:@"type_select_btn_nor.png"] forState:UIControlStateNormal];
    [_picButton addTarget:self action:@selector(chooseItemAction:) forControlEvents:UIControlEventTouchUpInside];
    [_chatStyle1BackView addSubview:_picButton];
}
- (void)configChatStyle2Button
{
    
}
- (void)configMotionView
{
    GYChatManager *chatManager = [GYChatManager sharedManager];
    [chatManager configMotionView:_selfFrame callback:^(UIView *view) {
        _motionView = (GYMotionView *)view;
        _motionViewFrame = CGRectMake(0, kScreenHeight - view.frame.size.height - _selfFrame.size.height, self.frame.size.width, view.frame.size.height + _selfFrame.size.height);
        __weak typeof(self) weakSelf = self;
        _motionView.chooseMotionCallback = ^(UIView *motion, NSArray *phArr, NSArray *bqArr) {
            __strong typeof(self) strongSelf = weakSelf;
            if (strongSelf) {
                [strongSelf chooseMotion:motion phArr:phArr bqArr:bqArr];
            }
            return;
        };
        _motionView.sendMessageCallback = ^{
            __strong typeof(self) strongSelf = weakSelf;
            if(strongSelf)
            {
                [strongSelf sendMessage];
            }
        };
    }];
}
- (void)configPicView
{
    [[GYChatManager sharedManager] configPicView:_selfFrame callback:^(UIView *view) {
        _picView = (GYPicView *)view;
        _picViewFrame = CGRectMake(0, kScreenHeight - view.frame.size.height - _selfFrame.size.height, self.frame.size.width, view.frame.size.height + _selfFrame.size.height);
    }];
}
- (void)registerForKeyboardNotifications
{
    //使用NSNotificationCenter 鍵盤出現時
    [[NSNotificationCenter defaultCenter] addObserver:self
     
                                             selector:@selector(keyboardWasShown:)
     
                                                 name:UIKeyboardDidShowNotification object:nil];
    
    //使用NSNotificationCenter 鍵盤隐藏時
    [[NSNotificationCenter defaultCenter] addObserver:self
     
                                             selector:@selector(keyboardWillBeHidden:)
     
                                                 name:UIKeyboardWillHideNotification object:nil];
    //键盘的frame即将发生变化时立刻发出该通知
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardChanged:) name:UIKeyboardWillChangeFrameNotification object:nil];
}
#pragma -mark ButtonClickedAction
- (void)menuAction:(id)sender
{
    UIButton *menuBtn = (UIButton *)sender;
    if(menuBtn.selected)
    {
        [_chatStyle2BackView removeFromSuperview];
        [self addSubview:_chatStyle1BackView];
        menuBtn.selected = NO;
        [UIView animateWithDuration:kKeyboardAnimationDuration animations:^{
            [self changeFrame:_selfFrame];
        }];
        if(_keyboradIsShow)
        {
            [_textView becomeFirstResponder];
        }
        _iconButton.selected = NO;
        _picButton.selected = NO;
    }
    else
    {
        [_chatStyle1BackView removeFromSuperview];
        [self addSubview:_chatStyle2BackView];
        menuBtn.selected = YES;
        [UIView animateWithDuration:kKeyboardAnimationDuration animations:^{
            [self changeFrame:_selfFrame];
        }];
        [_motionView removeFromSuperview];
        [_picView removeFromSuperview];
        
    }
}
- (void)talkAction:(id)sender
{
    UIButton *talkBtn = (UIButton *)sender;
    if(talkBtn.selected) {
        //弹起键盘
        [self isVoiceInputStatus:NO];
        [_textView becomeFirstResponder];
        _keyboradIsShow = YES;
    } else
    {
        [self isVoiceInputStatus:YES];
        [UIView animateWithDuration:kKeyboardAnimationDuration animations:^{
            [self changeFrame:_selfFrame];
        }];
        [_motionView removeFromSuperview];
        [_picView removeFromSuperview];
        _iconButton.selected = NO;
        [_textView resignFirstResponder];
        _keyboradIsShow = NO;
    }
}
- (void)moodIconAction:(id)sender
{
    UIButton *iconBtn = (UIButton *)sender;
    [self isVoiceInputStatus:NO];
    _keyboradIsShow = YES;
    if(iconBtn.selected) {
        //弹起键盘
        iconBtn.selected = NO;
        [_textView becomeFirstResponder];
        [_motionView removeFromSuperview];
    } else {
        iconBtn.selected = YES;
        [_textView resignFirstResponder];
        _textView.hidden = NO;
        _pressButton.hidden = YES;
        _picButton.selected = NO;
        [UIView animateWithDuration:kKeyboardAnimationDuration animations:^{
            [self changeFrame:_motionViewFrame];
        }];
        [_picView removeFromSuperview];
        [self addSubview:_motionView];
    }
}
- (void)chooseItemAction:(id)sender
{
    UIButton *picBtn = (UIButton *)sender;
    [self isVoiceInputStatus:NO];
    _keyboradIsShow = YES;
    if(picBtn.selected) {
        //弹起键盘
        picBtn.selected = NO;
        [_textView becomeFirstResponder];
        [_picView removeFromSuperview];
    } else {
        picBtn.selected = YES;
        [_textView resignFirstResponder];
        [UIView animateWithDuration:kKeyboardAnimationDuration animations:^{
            [self changeFrame:_picViewFrame];
        }];
        
        _iconButton.selected = NO;
        [_motionView removeFromSuperview];
        [self addSubview:_picView];
    }
}
- (void)recordTouchUpInside:(id)sender
{
}
- (void)recordTouchUpOutside:(id)sender
{
}
- (void)recordTouchDown:(id)sender
{
}
- (void)recordTouchDragOutside:(id)sender
{
}
- (void)recordTouchDragIn:(id)sender
{
}
#pragma -mark privateMethod
- (void)isVoiceInputStatus:(BOOL)isVoice
{
    _talkButton.selected = isVoice;
    _pressButton.hidden = !isVoice;
    _textView.hidden = isVoice;
}
- (void)changeFrame:(CGRect)newFrame
{
    self.frame = newFrame;
}
//发送消息
- (void)sendMessage
{
    if([GYChatManager sharedManager].sendMessageCallback)
    {
        [GYChatManager sharedManager].sendMessageCallback(_textView.text);
        _textView.text = @"";
    }
}
- (void)chooseMotion:(id)sender phArr:(NSArray *)phArr bqArr:(NSArray *)bqArr
{
    _messageString =[NSMutableString stringWithFormat:@"%@",_textView.text];
    int everNum = 32;   // 在6plus之前一页显示32个表情
    
    if (IS_IPHONE_6P) {
        everNum = 36;   // 在6plus上一页显示36个表情
    }
    
    UIButton *tempbtn = (UIButton *)sender;
    
    BOOL clearClick = NO;
    
    NSMutableDictionary *tempdic = [phArr objectAtIndex:tempbtn.tag];
    NSArray *temparray = [tempdic allKeys];
    if (temparray.count == 0) {
        return;
    }
    NSString *faceStr= [NSString stringWithFormat:@"%@",[temparray objectAtIndex:0]];
    if ([faceStr isEqualToString:@"[/sc]"]) {
        clearClick = YES;
    }
    if (clearClick)
    {
        [self clearClickMotion:bqArr];
    }
    else
    {
        NSMutableDictionary *tempdic = [phArr objectAtIndex:tempbtn.tag];
        NSArray *temparray = [tempdic allKeys];
        NSString *faceStr= [NSString stringWithFormat:@"%@",[temparray objectAtIndex:0]];
        [_messageString appendString:faceStr];
    }
    _textView.text=_messageString;
    _textView.selectedRange = NSMakeRange([_messageString length],0);
    [self textViewDidChange:_textView];
}
- (void)clearClickMotion:(NSArray *)bqStrArray
{
    if (_messageString.length <= 0)
    {
        return;
    }
    NSString *tempStr = [_messageString substringFromIndex:_messageString.length-1];
    //表情的结尾@"]"
    if (![tempStr isEqualToString:@"]"])
    {
        _messageString = (NSMutableString *)[_messageString substringToIndex:(_messageString.length-1)];
        return;
    }
    //从末尾检索表情的开始@"[/"
    NSRange range =  [_messageString rangeOfString:@"[/" options:NSBackwardsSearch];
    
    if (range.location == NSNotFound)
    {
        _messageString = (NSMutableString *)[_messageString substringToIndex:(_messageString.length-1)];
        return;
    }
    //截取@"[/"与@"]"之间的字符串
    NSString *tempMessageString = [_messageString substringWithRange:NSMakeRange(range.location+2, _messageString.length-range.location-3)];
    BOOL isMyBQ = NO;
    
    for (NSMutableString *bqStr in bqStrArray)
    {
        if ([bqStr isEqualToString:tempMessageString])
        {
            _messageString = (NSMutableString *)[_messageString substringToIndex:range.location];
            isMyBQ = YES;
        }
    }
    if (!isMyBQ)
    {
        _messageString = (NSMutableString *)[_messageString substringToIndex:(_messageString.length-1)];
    }
}
#pragma -mark keyboardNotification
//实现当键盘出现的时候计算键盘的高度大小。用于输入框显示位置
- (void)keyboardWasShown:(NSNotification*)aNotification
{
    _picButton.selected = NO;
    _iconButton.selected = NO;
    _talkButton.selected = NO;
}

- (void)keyboardChanged:(NSNotification*)aNotification
{
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;//得到鍵盤的高度
    if(_talkButton.selected)
    {
        return;
    }
    [UIView animateWithDuration:kKeyboardAnimationDuration animations:^{
        CGRect newFrame = CGRectMake(0, kScreenHeight - kbSize.height - _selfFrame.size.height, kScreenWidth, _selfFrame.size.height);
        [self changeFrame:newFrame];
    }];
    
}
//当键盘隐藏的时候
- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    
}
#pragma -mark UITextViewDelegate
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    _keyboradIsShow = YES;
    return YES;
}
- (void)textViewDidChange:(UITextView *)textView
{
    if(textView.text)
    {
        CGFloat offsetHeight;
        if(textView.contentSize.height >= textView.frame.size.height)
        {
            offsetHeight = textView.contentSize.height - textView.frame.size.height;
        }
        else
        {
            offsetHeight = 0;
        }
        [textView setContentOffset:CGPointMake(0,offsetHeight)];
    }
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([text isEqualToString:@"\n"]){ //判断输入的字是否是回车，即按下return
        [self sendMessage];
        return NO; //这里返回NO，就代表return键值失效，即页面上按下return，不会出现换行，如果为yes，则输入页面会换行
    }
    
    return YES;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
