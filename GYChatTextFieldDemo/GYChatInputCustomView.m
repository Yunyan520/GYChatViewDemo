//
//  GYChatInputCustomView.m
//  GYChatTextFieldDemo
//
//  Created by lidianchao on 2017/9/5.
//  Copyright © 2017年 lidianchao. All rights reserved.
//

#import "GYChatInputCustomView.h"
#import "GYScreen.h"
#import "GYChatView.h"
#define kKeyboardAnimationDuration 0.25
@implementation GYChatInputCustomViewItem

@end

@interface GYChatInputCustomView ()<UITextViewDelegate>

@end

@implementation GYChatInputCustomView
{
    UITextView *_textView;
    UIButton *_pressButton;
    UIButton *_talkButton;
    UIButton *_picButton;
    UIButton *_iconButton;
    GYMotionView *_motionView;
    GYPicView *_picView;
    CGRect _selfFrame;
    CGRect _motionViewFrame;
    CGRect _picViewFrame;
    GYChatInputCustomViewItem *_item;
    BOOL _keyboradIsShow;
    NSMutableString *_messageString;
}
- (instancetype)initWithFrame:(CGRect)frame item:(GYChatInputCustomViewItem *)item
{
    self = [super initWithFrame:frame];
    if(self)
    {
        _selfFrame = frame;
        _item = item;
        [self registerForKeyboardNotifications];
        [self configVoiceInputUI];
        [self configMotionPicSendUI];
        [self configMotionView];
        [self configPicView];
    }
    return self;
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
- (void)configVoiceInputUI
{
    //文本输入框
    _textView = [[UITextView alloc] init];
    _textView.frame = _item.textViewFrame;
    _textView.backgroundColor = [UIColor grayColor];
    _textView.layer.cornerRadius = 5;
    _textView.delegate = self;
    _textView.returnKeyType = UIReturnKeySend;
    [self addSubview:_textView];
    
    //语音发送按钮
    _pressButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _pressButton.frame = _item.pressButtonFrame;
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
    [self addSubview:_pressButton];
}
- (void)configMotionPicSendUI
{
    //	录音按钮
    _talkButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _talkButton.frame = _item.talkButtonFrame;
    [_talkButton setImage:[UIImage imageNamed:@"Fav_Search_Voice.png"] forState:UIControlStateNormal];
    [_talkButton setImage:[UIImage imageNamed:@"Keyboard_ios.png"] forState:UIControlStateSelected];
    [_talkButton addTarget:self action:@selector(talkAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_talkButton];
    //	表情选择按钮
    _iconButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    _iconButton.frame = _item.iconButtonFrame;
    [_iconButton setImage:[UIImage imageNamed:@"Album_ToolViewEmotion.png"] forState:UIControlStateNormal];
    [_iconButton setImage:[UIImage imageNamed:@"Keyboard_ios.png"] forState:UIControlStateSelected];
    [_iconButton addTarget:self action:@selector(moodIconAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_iconButton];
    
    //	图片选择按钮
    _picButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _picButton.frame = _item.picButtonFrame;
    [_picButton setImage:[UIImage imageNamed:@"type_select_btn_nor.png"] forState:UIControlStateNormal];
    [_picButton addTarget:self action:@selector(chooseItemAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_picButton];
}
- (void)configMotionView
{
    GYChatManager *chatManager = [GYChatManager sharedManager];
    [chatManager configMotionView:_item.currentSuperView.frame callback:^(UIView *view) {
        _motionView = (GYMotionView *)view;
        _motionViewFrame = CGRectMake(0, kScreenHeight - view.frame.size.height - _item.currentSuperView.frame.size.height, kScreenWidth, view.frame.size.height + _item.currentSuperView.frame.size.height);
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
    [[GYChatManager sharedManager] configPicView:_item.currentSuperView.frame callback:^(UIView *view) {
        _picView = (GYPicView *)view;
        _picViewFrame = CGRectMake(0, kScreenHeight - view.frame.size.height - _item.currentSuperView.frame.size.height, _item.currentSuperView.frame.size.width, view.frame.size.height + _item.currentSuperView.frame.size.height);
    }];
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
            [self resetFrame];
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
        [_item.currentSuperView addSubview:_motionView];
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
        [_item.currentSuperView addSubview:_picView];
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
- (void)resetFrame
{
    GYChatView *chatView = (GYChatView *)_item.currentSuperView;
    [chatView resetFrame];
}
- (void)changeFrame:(CGRect)newFrame
{
    GYChatView *chatView = (GYChatView *)_item.currentSuperView;
    [chatView changeFrame:newFrame];
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

#pragma -mark publicMethod
- (void)menuBtnSelected:(BOOL)isSelected
{
    [UIView animateWithDuration:kKeyboardAnimationDuration animations:^{
        [self resetFrame];
    }];
    if(isSelected)
    {
        if(_keyboradIsShow)
        {
            [_textView becomeFirstResponder];
        }
        _iconButton.selected = NO;
        _picButton.selected = NO;
    } else
    {
        [_motionView removeFromSuperview];
        [_picView removeFromSuperview];
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
