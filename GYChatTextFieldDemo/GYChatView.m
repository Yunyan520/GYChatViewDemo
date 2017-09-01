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
#import "GYChatManager.h"
@interface GYChatView()<UITextViewDelegate>

@end

@implementation GYChatView
{
    UITextView *_textView;
    UIButton *_pressButton;
    UIButton *_talkButton;
    UIButton *_picButton;
    UIButton *_iconButton;
    CGRect _selfFrame;
    CGRect _motionViewFrame;
    CGRect _picViewFrame;
    GYMotionView *_motionView;
    GYPicView *_picView;
    NSMutableString *_messageString;
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
- (void)configUI
{
    [self configVoiceInputUI];
    [self configMotionPicSendUI];
}
- (void)configVoiceInputUI
{
    //	录音按钮
    _talkButton = [[UIButton alloc]initWithFrame:CGRectMake(5, 5+2, 30, 30)];
    [_talkButton setImage:[UIImage imageNamed:@"Fav_Search_Voice.png"] forState:UIControlStateNormal];
    [_talkButton setImage:[UIImage imageNamed:@"Keyboard_ios.png"] forState:UIControlStateSelected];
    [_talkButton addTarget:self action:@selector(talkAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_talkButton];
    //文本输入框
    _textView = [[UITextView alloc] init];
    if (IOS7_OR_LATER) {
        [_textView setFrame:CGRectMake(40,5,self.frame.size.width-128, 34)];
    }else
    {
        [_textView setFrame:CGRectMake(40,5,self.frame.size.width-122, 34)];
    }
    _textView.backgroundColor = [UIColor grayColor];
    _textView.layer.cornerRadius = 5;
    _textView.delegate = self;
    _textView.returnKeyType = UIReturnKeySend;
    [self addSubview:_textView];
    
    //语音发送按钮
    _pressButton = [UIButton buttonWithType:UIButtonTypeCustom];
    if (IOS7_OR_LATER) {
        [_pressButton setFrame:CGRectMake(40,5,self.frame.size.width-128, 34)];
    }else
    {
        [_pressButton setFrame:CGRectMake(40,5,self.frame.size.width-122, 34)];
    }
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
    //	表情选择按钮
    _iconButton = [UIButton buttonWithType:UIButtonTypeCustom];
    if(IOS7_OR_LATER)
    {
        _iconButton.frame = CGRectMake(self.frame.size.width-85+4, 5+2, 30, 30);
    }else
    {
        _iconButton.frame = CGRectMake(self.frame.size.width-85+8, 5+2, 30, 30);
    }
    [_iconButton setImage:[UIImage imageNamed:@"Album_ToolViewEmotion.png"] forState:UIControlStateNormal];
    [_iconButton setImage:[UIImage imageNamed:@"Keyboard_ios.png"] forState:UIControlStateSelected];
    [_iconButton addTarget:self action:@selector(moodIconAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_iconButton];
    
    //	图片选择按钮
    _picButton = [[UIButton alloc]initWithFrame:CGRectMake(self.frame.size.width-50, 5+2, 50,30)];
    [_picButton setImage:[UIImage imageNamed:@"type_select_btn_nor.png"] forState:UIControlStateNormal];
    [_picButton addTarget:self action:@selector(chooseItemAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_picButton];
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
        __weak typeof(_textView) weakTextView = _textView;
        _motionView.sendMessageCallback = ^{
            __strong typeof(self) strongSelf = weakSelf;
            if(!strongSelf)
            {
                return;
            }
            if(chatManager.sendMessageCallback)
            {
                __strong typeof(_textView) strongTextView = weakTextView;
                if(weakTextView)
                {
                    chatManager.sendMessageCallback(strongTextView.text);
                }
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
}
#pragma -mark ButtonClickedAction
- (void)talkAction:(id)sender
{
    UIButton *talkBtn = (UIButton *)sender;
    if(talkBtn.selected) {
        //弹起键盘
        [self isVoiceInputStatus:NO];
        [_textView becomeFirstResponder];
    } else
    {
        [self isVoiceInputStatus:YES];
        self.frame = _selfFrame;
        [_motionView removeFromSuperview];
        [_picView removeFromSuperview];
        _iconButton.selected = NO;
        [_textView resignFirstResponder];
    }
}
- (void)moodIconAction:(id)sender
{
    UIButton *iconBtn = (UIButton *)sender;
    [self isVoiceInputStatus:NO];
    if(iconBtn.selected) {
        //弹起键盘
        iconBtn.selected = NO;
        [_textView becomeFirstResponder];
        self.frame = _selfFrame;
        [_motionView removeFromSuperview];
    } else {
        iconBtn.selected = YES;
        [_textView resignFirstResponder];
        _textView.hidden = NO;
        _pressButton.hidden = YES;
        _picButton.selected = NO;
        self.frame = _motionViewFrame;
        [_picView removeFromSuperview];
        [self addSubview:_motionView];
    }
}
- (void)chooseItemAction:(id)sender
{
    UIButton *picBtn = (UIButton *)sender;
    [self isVoiceInputStatus:NO];
    if(picBtn.selected) {
        //弹起键盘
        picBtn.selected = NO;
        [_textView becomeFirstResponder];
        self.frame = _selfFrame;
        [_picView removeFromSuperview];
    } else {
        picBtn.selected = YES;
        [_textView resignFirstResponder];
        self.frame = _picViewFrame;
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
    NSDictionary* info = [aNotification userInfo];
    //kbSize即為鍵盤尺寸 (有width, height)
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;//得到鍵盤的高度
    NSLog(@"hight_hitht:%f",kbSize.height);
    _picButton.selected = NO;
    _iconButton.selected = NO;
    _talkButton.selected = NO;
    self.frame = CGRectMake(0, kScreenHeight - kbSize.height - _selfFrame.size.height, kScreenWidth, _selfFrame.size.height);
}
//当键盘隐藏的时候
- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    
}
#pragma -mark UITextViewDelegate
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
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
        if([GYChatManager sharedManager].sendMessageCallback)
        {
            [GYChatManager sharedManager].sendMessageCallback(_textView.text);
        }
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
