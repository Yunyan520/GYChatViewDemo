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
#define kChangeIconPicDuration 0.4
@implementation GYChatInputCustomViewItem

@end

@interface GYChatInputCustomView ()<UITextViewDelegate>

@end

@implementation GYChatInputCustomView
{
    UITextView *_textView;
    UIView *_orientAnswerLabelBackView;
    UIButton *_pressButton;
    UIButton *_changeStatusButton;
    UIButton *_picButton;
    UIButton *_iconButton;
    GYMotionView *_motionView;
    GYPicView *_picView;
    CGRect _originSelfFrame;
    CGRect _currentSelfFrame;
    CGRect _selfFrameWithMotionView;
    CGRect _selfFrameWithPicView;
    CGRect _picViewFrame;
    CGRect _motionViewFrame;
    CGRect _selfCurrentOriginHeightFrame;
    CGRect _newTextViewFrame;
    CGRect _newSelfFrame;
    CGFloat _selfViewHeightAdd;
    CGFloat _currentTextViewHeight;
    GYChatInputCustomViewItem *_item;
    BOOL _keyboradIsShow;
    NSMutableString *_messageString;
    CGFloat _orientAnswerLabelHeight;
    CGRect _currentTextViewFrame;
    CGSize _currentContentSize;
    BOOL _isOrientAnswerStatus;
}
- (instancetype)initWithItem:(GYChatInputCustomViewItem *)item
{
    self = [super initWithFrame:item.currentViewFrame];
    if(self)
    {
        _item = item;
        [self initFrame];
        _orientAnswerLabelHeight = 0;
        self.backgroundColor = kUIColorFromValue(0xF7F7F7);
        [self registerForKeyboardNotifications];
        [self configVoiceInputUI];
        [self configOrientateAnswerLabel];
        [self configMotionPicSendUI];
        [self configMotionView];
        [self configPicView];
    }
    return self;
}
- (void)initFrame
{
    _newTextViewFrame = _item.textViewFrame;
    _originSelfFrame = _item.currentViewFrame;
    _currentSelfFrame = _item.currentViewFrame;
    _newSelfFrame = _item.currentViewFrame;
    _selfCurrentOriginHeightFrame = _item.currentViewFrame;
}
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}
- (void)registerForKeyboardNotifications
{
    //使用NSNotificationCenter 鍵盤出現時
    [[NSNotificationCenter defaultCenter] addObserver:self
     
                                             selector:@selector(keyboardWasShown:)
     
                                                 name:UIKeyboardDidShowNotification object:nil];
    //使用NSNotificationCenter 鍵盤将要出現時
    [[NSNotificationCenter defaultCenter] addObserver:self
     
                                             selector:@selector(keyboardWillShown:)
     
                                                 name:UIKeyboardWillShowNotification object:nil];
    
    //使用NSNotificationCenter 鍵盤隐藏時
    [[NSNotificationCenter defaultCenter] addObserver:self
     
                                             selector:@selector(keyboardWillBeHidden:)
     
                                                 name:UIKeyboardWillHideNotification object:nil];

}
- (void)configVoiceInputUI
{
    //文本输入框
    _textView = [[UITextView alloc] init];
    _textView.frame = _item.textViewFrame;
    _currentTextViewHeight = _item.textViewFrame.size.height;
    _textView.backgroundColor = kTextViewBackgroundColor;
    _textView.layer.cornerRadius = kTextViewCornerRadius;
    _textView.delegate = self;
    _textView.font = [UIFont systemFontOfSize:kTextViewFont];
    _textView.returnKeyType = UIReturnKeySend;
    _textView.userInteractionEnabled = YES;
    [self addSubview:_textView];
    
    //语音发送按钮
    _pressButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _pressButton.frame = _item.pressButtonFrame;
    _pressButton.hidden = YES;
    [_pressButton setBackgroundImage:[UIImage imageNamed:kPressBtnNormalImage] forState:UIControlStateNormal];
    [_pressButton setBackgroundImage:[UIImage imageNamed:kPressBtnHighlightedImage] forState:UIControlStateHighlighted];
    [_pressButton setBackgroundImage:[UIImage imageNamed:kPressBtnSelectedImage] forState:UIControlStateSelected];
    [_pressButton setBackgroundImage:[UIImage imageNamed:kPressBtnDisabledImage] forState:UIControlStateDisabled];
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
- (void)configOrientateAnswerLabel
{
    _orientAnswerLabelBackView = [[UIView alloc] init];
    _orientAnswerLabelBackView.frame = CGRectMake(_item.textViewFrame.origin.x, _item.textViewFrame.origin.y, _item.textViewFrame.size.width, kOrientAnswerLabelHeight + kOrientAnswerLabelHeightOffset);
    _orientAnswerLabelBackView.backgroundColor = _textView.backgroundColor;
    _orientAnswerLabelBackView.layer.cornerRadius = kTextViewCornerRadius;
    [self addSubview:_orientAnswerLabelBackView];
    _orientAnswerLabelBackView.hidden = YES;
    
    UILabel *orientAnswerLabel = [[UILabel alloc] init];
    orientAnswerLabel.frame = CGRectMake(kOrientAnswerLabelXOffset,kOrientAnswerLabelYOffset, _item.textViewFrame.size.width - kOrientAnswerLabelWidthOffset, kOrientAnswerLabelHeight);
    orientAnswerLabel.backgroundColor = kOrientAnswerLabelBackgroundColor;
    orientAnswerLabel.layer.masksToBounds = YES;
    orientAnswerLabel.layer.cornerRadius = kOrientAnswerLabelCornerRadius;
    orientAnswerLabel.font = [UIFont systemFontOfSize:kOrientAnswerLabelFont];
    orientAnswerLabel.textColor = kOrientAnswerLabelTextColor;
    orientAnswerLabel.tag = kOrientAnswerLabelTag;
    [_orientAnswerLabelBackView addSubview:orientAnswerLabel];
}
- (void)configMotionPicSendUI
{
    //	录音、输入状态切换按钮
    _changeStatusButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _changeStatusButton.frame = _item.talkButtonFrame;
    [_changeStatusButton setImage:[UIImage imageNamed:kChangeStatusBtnNormalImage] forState:UIControlStateNormal];
    [_changeStatusButton setImage:[UIImage imageNamed:kChangeStatusBtnSelectImage] forState:UIControlStateSelected];
    [_changeStatusButton addTarget:self action:@selector(talkAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_changeStatusButton];
    //	表情选择按钮
    _iconButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    _iconButton.frame = _item.iconButtonFrame;
    [_iconButton setImage:[UIImage imageNamed:kIconBtnNormalImage] forState:UIControlStateNormal];
    [_iconButton setImage:[UIImage imageNamed:kIconBtnSelectImage] forState:UIControlStateSelected];
    [_iconButton addTarget:self action:@selector(moodIconAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_iconButton];
    
    //	图片选择按钮
    _picButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _picButton.frame = _item.picButtonFrame;
    [_picButton setImage:[UIImage imageNamed:kPicBtnNormalImage] forState:UIControlStateNormal];
    [_picButton addTarget:self action:@selector(chooseItemAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_picButton];
}

- (void)configMotionView
{
    _motionViewFrame = CGRectMake(ZeroX, _item.currentSuperView.frame.size.height - kMotionViewHeight, _item.currentSuperView.frame.size.width, kMotionViewHeight);
    GYChatManager *chatManager = [GYChatManager sharedManager];
    [chatManager configMotionView:_motionViewFrame callback:^(UIView *view) {
        _motionView = (GYMotionView *)view;
        _selfFrameWithMotionView = CGRectMake(_originSelfFrame.origin.x, _motionViewFrame.origin.y - _originSelfFrame.size.height, _originSelfFrame.size.width, _originSelfFrame.size.height);
        _currentSelfFrame = _selfFrameWithMotionView;
        WS(ws);
        _motionView.chooseMotionCallback = ^(UIView *motion, NSArray *phArr, NSArray *bqArr) {
            __strong typeof(self) strongSelf = ws;
            if (strongSelf) {
                [strongSelf chooseMotion:motion phArr:phArr bqArr:bqArr];
            }
            return;
        };
        _motionView.sendMessageCallback = ^{
            __strong typeof(self) strongSelf = ws;
            if(strongSelf)
            {
                [strongSelf sendMessage];
            }
        };
    }];
}
- (void)reFrameMotionView
{
    _motionViewFrame = CGRectMake(ZeroX, _item.currentSuperView.frame.size.height - kMotionViewHeight, _item.currentSuperView.frame.size.width, kMotionViewHeight);
    _motionView.frame = _motionViewFrame;
    _selfFrameWithMotionView = CGRectMake(_originSelfFrame.origin.x, _motionViewFrame.origin.y - _originSelfFrame.size.height, _originSelfFrame.size.width, _originSelfFrame.size.height);
    _currentSelfFrame = _selfFrameWithMotionView;
}

- (void)configPicView
{
    _picViewFrame = CGRectMake(ZeroX, _item.currentSuperView.frame.size.height - kPicViewHeight, _item.currentSuperView.frame.size.width, kPicViewHeight);
    [[GYChatManager sharedManager] configPicView:_picViewFrame callback:^(UIView *view) {
        _picView = (GYPicView *)view;
        _selfFrameWithPicView = CGRectMake(_originSelfFrame.origin.x, _picViewFrame.origin.y - _originSelfFrame.size.height, _originSelfFrame.size.width, _originSelfFrame.size.height);
        _currentSelfFrame = _selfFrameWithPicView;
        
    }];
}
- (void)reFramePicView
{
    _picViewFrame = CGRectMake(ZeroX, _item.currentSuperView.frame.size.height - kPicViewHeight, _item.currentSuperView.frame.size.width, kPicViewHeight);
    _picView.frame = _picViewFrame;
    _selfFrameWithPicView = CGRectMake(_originSelfFrame.origin.x, _picViewFrame.origin.y - _originSelfFrame.size.height, _originSelfFrame.size.width, _originSelfFrame.size.height);
    _currentSelfFrame = _selfFrameWithPicView;
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
            [self resetCurrentViewFrame];
        }];
        [_motionView removeFromSuperview];
        [_picView removeFromSuperview];
        _iconButton.selected = NO;
        [_textView resignFirstResponder];
        _keyboradIsShow = NO;
    }
    if(_isOrientAnswerStatus)
    {
        _orientAnswerLabelBackView.hidden = talkBtn.selected;
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
        _selfCurrentOriginHeightFrame = _selfFrameWithMotionView;
        [_picView removeFromSuperview];
        [self changeToIconOrPicView:_motionView :_motionViewFrame];
    }
}
- (void)chooseItemAction:(id)sender
{
    [self isVoiceInputStatus:NO];
    _keyboradIsShow = YES;
    if(_picButton.selected) {
        //弹起键盘
        _picButton.selected = NO;
        [_textView becomeFirstResponder];
        [_picView removeFromSuperview];
    } else {
        _picButton.selected = YES;
        _iconButton.selected = NO;
        [_textView resignFirstResponder];
        _selfCurrentOriginHeightFrame = _selfFrameWithPicView;
        [_motionView removeFromSuperview];
        [self changeToIconOrPicView:_picView :_picViewFrame];
    }
}

- (void)recordTouchUpInside:(id)sender
{
    if([[GYChatManager sharedManager].delegate respondsToSelector:@selector(recordTouchUpInside:)])
    {
        [[GYChatManager sharedManager].delegate recordTouchUpInside:sender];
        [[GYChatManager sharedManager] InputPromptViewStatus:PromptStatus_End];
    }
    
}
- (void)recordTouchUpOutside:(id)sender
{
    if([[GYChatManager sharedManager].delegate respondsToSelector:@selector(recordTouchUpOutside:)])
    {
        [[GYChatManager sharedManager].delegate recordTouchUpOutside:sender];
        [[GYChatManager sharedManager] InputPromptViewStatus:PromptStatus_End];
    }
    
}
- (void)recordTouchDown:(id)sender
{
    if([[GYChatManager sharedManager].delegate respondsToSelector:@selector(recordTouchDown:)])
    {
        [[GYChatManager sharedManager].delegate recordTouchDown:sender];
        [[GYChatManager sharedManager] InputPromptViewStatus:PromptStatus_IsTalking];
    }
    
}
- (void)recordTouchDragOutside:(id)sender
{
    if([[GYChatManager sharedManager].delegate respondsToSelector:@selector(recordTouchDragOutside:)])
    {
        [[GYChatManager sharedManager].delegate recordTouchDragOutside:sender];
        [[GYChatManager sharedManager] InputPromptViewStatus:PromptStatus_WarnningCancle];
    }
}
- (void)recordTouchDragIn:(id)sender
{
    if([[GYChatManager sharedManager].delegate respondsToSelector:@selector(recordTouchDragIn:)])
    {
        [[GYChatManager sharedManager].delegate recordTouchDragIn:sender];
        [[GYChatManager sharedManager] InputPromptViewStatus:PromptStatus_IsTalking];
    }
    
}
#pragma -mark privateMethod
- (void)changeToIconOrPicView:(UIView *)changeToView :(CGRect)frame
{
    CGRect newFrame = CGRectMake(_selfCurrentOriginHeightFrame.origin.x, _selfCurrentOriginHeightFrame.origin.y - _selfViewHeightAdd, _selfCurrentOriginHeightFrame.size.width, _selfCurrentOriginHeightFrame.size.height + _selfViewHeightAdd);
    [UIView animateWithDuration:kKeyboardAnimationDuration animations:^{
        [self changeSelfViewFrame:newFrame];
    }];
    _currentSelfFrame = self.frame;
    [_item.currentSuperView addSubview:changeToView];
    changeToView.frame = CGRectMake(frame.origin.x, kScreenHeight, frame.size.width, frame.size.height);
    [UIView animateWithDuration:kChangeIconPicDuration animations:^{
        changeToView.frame = frame;
    }];
}
- (void)isVoiceInputStatus:(BOOL)isVoice
{
    _changeStatusButton.selected = isVoice;
    _pressButton.hidden = !isVoice;
    _textView.hidden = isVoice;
}
- (void)resetCurrentViewFrame
{
    self.frame = CGRectMake(_originSelfFrame.origin.x, _originSelfFrame.origin.y - _selfViewHeightAdd, _originSelfFrame.size.width, _originSelfFrame.size.height + _selfViewHeightAdd);
    _currentSelfFrame = self.frame;
    [_motionView removeFromSuperview];
    [_picView removeFromSuperview];
    GYChatView *chatView = (GYChatView *)_item.currentSuperView;
    [chatView resetMuneButtonFrame];
}
- (void)changeSelfViewFrame:(CGRect)newFrame
{
    _newSelfFrame = newFrame;
    self.frame = newFrame;
    if(_item.style == TypeChat2)
    {
        GYChatView *chatView = (GYChatView *)_item.currentSuperView;
        CGRect newMuneBtnFrame = CGRectMake(kChatType2_MenuBtnX, newFrame.origin.y + _currentTextViewHeight - _item.textViewFrame.size.height + 10, kChatType2_MenuBtnWidth, kChatType2_MenuBtnHeight);
        [chatView setMuneButtonFrame:newMuneBtnFrame];
    }
}
- (void)changeTextViewFrame:(CGRect)newFrame
{
    _newTextViewFrame = newFrame;
    _textView.frame = newFrame;
    _orientAnswerLabelBackView.frame = CGRectMake(_textView.frame.origin.x, _textView.frame.origin.y, _textView.frame.size.width, kOrientAnswerLabelHeight + kOrientAnswerLabelHeightOffset);
    _currentTextViewFrame = newFrame;
}
- (void)setTextViewFrame
{
    NSString *text = _textView.text;
    //获取单行字符串高度
    CGFloat separateHeight = [self calculateWidth:text];
    CGFloat maxHeight = kTextViewMaxLineCount * separateHeight;
    CGFloat textViewHeight = _textView.frame.size.height;
    if(maxHeight <= textViewHeight)
    {
        maxHeight = _textView.frame.size.height;
    }
    CGRect frame = _item.textViewFrame;
    CGSize constraintSize = CGSizeMake(frame.size.width, MAXFLOAT);
    CGSize size = [_textView sizeThatFits:constraintSize];
    if (size.height <= frame.size.height) {
        size.height = frame.size.height;
    }else{
        if (size.height >= maxHeight)
        {
            size.height = maxHeight;
            _textView.scrollEnabled = YES;   // 允许滚动
            CGFloat offsetHeight = [self getTextViewContentHeight] + _orientAnswerLabelHeight;
            [UIView animateWithDuration:kKeyboardAnimationDuration animations:^{
                [_textView setContentOffset:CGPointMake(0, offsetHeight)];
            }];
            
        }
        else
        {
            _textView.scrollEnabled = NO;    // 不允许滚动
        }
    }
    
    CGFloat heightAdd = size.height - _item.textViewFrame.size.height;
    _currentContentSize = size;
    [UIView animateWithDuration:kKeyboardAnimationDuration animations:^{
        CGRect newTextViewFrame = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, size.height);
        [self changeTextViewFrame:newTextViewFrame];
        _currentTextViewHeight = size.height;
        [self setContentUIFrame:heightAdd];
        [self changeSelfViewFrame:CGRectMake(_selfCurrentOriginHeightFrame.origin.x, _selfCurrentOriginHeightFrame.origin.y - heightAdd, _selfCurrentOriginHeightFrame.size.width, _selfCurrentOriginHeightFrame.size.height + heightAdd)];
    }];
    _selfViewHeightAdd = heightAdd;
}
- (CGFloat)calculateWidth:(NSString *)str {
    if([str rangeOfString:@"\r"].location != NSNotFound)
    {
        str = @"0";
    }
    NSDictionary *dic  = [NSDictionary dictionaryWithObjectsAndKeys:_textView.font, NSFontAttributeName, nil];
    CGSize size = [str sizeWithAttributes:dic];
    return size.height;
}
- (void)setContentUIFrame:(CGFloat)heightChange
{
    _changeStatusButton.frame = CGRectMake(_item.talkButtonFrame.origin.x, _item.talkButtonFrame.origin.y + heightChange, _item.talkButtonFrame.size.width, _item.talkButtonFrame.size.height);
    _iconButton.frame = CGRectMake(_item.iconButtonFrame.origin.x, _item.iconButtonFrame.origin.y + heightChange, _item.iconButtonFrame.size.width, _item.iconButtonFrame.size.height);
    _picButton.frame = CGRectMake(_item.picButtonFrame.origin.x, _item.picButtonFrame.origin.y + heightChange, _item.picButtonFrame.size.width, _item.picButtonFrame.size.height);
    _pressButton.frame = CGRectMake(_item.pressButtonFrame.origin.x, _item.pressButtonFrame.origin.y + heightChange, _item.pressButtonFrame.size.width, _item.pressButtonFrame.size.height);
}
//发送消息
- (void)sendMessage
{
    if([[GYChatManager sharedManager].delegate respondsToSelector:@selector(sendMessage:)])
    {
        [[GYChatManager sharedManager].delegate sendMessage:_textView.text];
        _textView.text = @"";
    }
    if(!_orientAnswerLabelBackView.hidden)
    {
        [self hiddenOrientAnswerLabel];
    }
}
- (void)chooseMotion:(id)sender phArr:(NSArray *)phArr bqArr:(NSArray *)bqArr
{
    _messageString =[NSMutableString stringWithFormat:@"%@",_textView.text];
    UIButton *tempbtn = (UIButton *)sender;

    NSMutableDictionary *tempdic = [phArr objectAtIndex:tempbtn.tag];
    NSArray *temparray = [tempdic allKeys];
    if (temparray.count == 0) {
        return;
    }
    NSString *faceStr= [NSString stringWithFormat:@"%@",[temparray objectAtIndex:0]];
    if ([faceStr isEqualToString:@"[/sc]"]) {
        [self clearClickMotion:bqArr];
    }
    else
    {
        NSMutableDictionary *tempdic = [phArr objectAtIndex:tempbtn.tag];
        NSArray *temparray = [tempdic allKeys];
        NSString *faceStr= [NSString stringWithFormat:@"%@",[temparray objectAtIndex:0]];
        [_messageString appendString:faceStr];
    }
    _textView.text = _messageString;
}
- (void)clearClickMotion:(NSArray *)bqStrArray
{
    if (_messageString.length <= 0)
    {
        [self hiddenOrientAnswerLabel];
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
        _messageString = (NSMutableString *)[_messageString substringToIndex:(_messageString.length - 1)];
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
- (CGFloat)getTextViewContentHeight
{
    if(_textView.text)
    {
        NSLog(@"textView.tex:%@",_textView.text);
        NSLog(@"%f",_item.textViewFrame.size.height);
        CGFloat offsetHeight;
        if(_textView.contentSize.height >= _textView.frame.size.height)
        {
            offsetHeight = _textView.contentSize.height - _textView.frame.size.height - kTextViewTextBank;
        }
        else
        {
            offsetHeight = 0;
        }
        return offsetHeight;
    }
    return 0;
}
- (void)hiddenOrientAnswerLabel
{
    _isOrientAnswerStatus = NO;
    _orientAnswerLabelBackView.hidden = YES;
    _textView.textContainerInset = UIEdgeInsetsMake(8, 0, 8, 0);
    CGRect frame = _item.textViewFrame;
    CGRect newTextViewFrame = frame;
    [UIView animateWithDuration:kKeyboardAnimationDuration animations:^{
        [self changeTextViewFrame:newTextViewFrame];
        [self setContentUIFrame:0];
        [self changeSelfViewFrame:_selfCurrentOriginHeightFrame];
    }];
    
}
#pragma -mark publicMethod
- (void)menuBtnSelected:(BOOL)isSelected
{
    [UIView animateWithDuration:kKeyboardAnimationDuration animations:^{
        [self resetCurrentViewFrame];
    }];
    if(isSelected)
    {
        _iconButton.selected = NO;
        _picButton.selected = NO;
    } else
    {
        [_motionView removeFromSuperview];
        [_picView removeFromSuperview];
    }
}
- (void)keyBoardIsShow:(BOOL)isShow
{
    if(isShow)
    {
        [_textView becomeFirstResponder];
    }
    else
    {
        [_textView resignFirstResponder];
        [UIView animateWithDuration:kKeyboardAnimationDuration animations:^{
            [self resetCurrentViewFrame];
        }];
        _picButton.selected = NO;
        _iconButton.selected = NO;
    }
}
- (void)orientateAnswer:(NSString *)messageAnswered userName:(NSString *)userName
{
    _isOrientAnswerStatus = YES;
    _orientAnswerLabelHeight = kOrientAnswerLabelHeight + kOrientAnswerLabelTopBank;
    _orientAnswerLabelBackView.hidden = NO;
    UILabel *orientAnswerLabel = (UILabel *)[_orientAnswerLabelBackView viewWithTag:kOrientAnswerLabelTag];
    
    orientAnswerLabel.text = messageAnswered;
    _textView.textContainerInset = UIEdgeInsetsMake(_orientAnswerLabelHeight, 0, 0, 0);
    [_textView becomeFirstResponder];
    
    CGRect frame = _currentTextViewFrame;
    if([_textView.text  isEqual: @""])
    {
        frame = _item.textViewFrame;
    }
    CGFloat heightAdd = _orientAnswerLabelHeight - kOrientAnswerLabelTopOffSet;
    [UIView animateWithDuration:kKeyboardAnimationDuration animations:^{
        CGRect newTextViewFrame = CGRectMake(frame.origin.x, frame.origin.y - heightAdd, frame.size.width, frame.size.height + heightAdd);
        [self changeTextViewFrame:newTextViewFrame];
    }];
    _textView.text = [NSString stringWithFormat:@"%@@%@ ",_textView.text,userName];
}
- (void)atSomeone:(NSString *)personName isLongPressed:(BOOL)isLongPressed
{
    if(isLongPressed)
    {
        //长按方式艾特某人
        //已经艾特过某人
        if([_textView.text rangeOfString:personName].location != NSNotFound)
        {
            return;
        }
    }
    _textView.text = [NSString stringWithFormat:@"%@@%@ ",_textView.text,personName];
    [_textView becomeFirstResponder];
}
- (NSString *)getCurrentTextViewMessage
{
    return _textView.text;
}
- (void)addDraft:(NSString *)draft
{
    if(draft)
    {
        _textView.text = draft;
        if(_item.style == TypeChat1)
        {
            [_textView becomeFirstResponder];
            [self setTextViewFrame];
        }
    }
}
- (void)viewWillLayoutSubviews
{
    [self initFrame];
    self.frame = _newSelfFrame;
    if(![_textView.text isEqualToString:@""])
    {
        [self setTextViewFrame];
    }
    else
    {
        _textView.frame = _newTextViewFrame;
        [self setContentUIFrame:0];
    }
    _orientAnswerLabelBackView.frame = CGRectMake(_item.textViewFrame.origin.x, _item.textViewFrame.origin.y, _item.textViewFrame.size.width, kOrientAnswerLabelHeight + kOrientAnswerLabelHeightOffset);
    _iconButton.selected = NO;
    _picButton.selected = NO;
    [_motionView removeFromSuperview];
    [_picView removeFromSuperview];
    [self reFrameMotionView];
    [self reFramePicView];
    [_motionView viewWillLayoutSubviews];
    [_picView viewWillLayoutSubviews];
}
#pragma -mark keyboardNotification
//实现当键盘出现的时候计算键盘的高度大小。用于输入框显示位置
- (void)keyboardWasShown:(NSNotification*)aNotification
{
    _picButton.selected = NO;
    _iconButton.selected = NO;
    [self isVoiceInputStatus:NO];
}
//键盘即将弹起
- (void)keyboardWillShown:(NSNotification*)aNotification
{
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;//得到鍵盤的高度
    
    [UIView animateWithDuration:kKeyboardAnimationDuration animations:^{
        CGRect newFrame = CGRectMake(_originSelfFrame.origin.x, kScreenHeight - kbSize.height - _originSelfFrame.size.height - _selfViewHeightAdd, kScreenWidth, _originSelfFrame.size.height + _selfViewHeightAdd);
        [self changeSelfViewFrame:newFrame];
        _selfCurrentOriginHeightFrame = CGRectMake(_originSelfFrame.origin.x, kScreenHeight - kbSize.height - _originSelfFrame.size.height, kScreenWidth, _originSelfFrame.size.height);
        _currentSelfFrame = self.frame;
    }];
    if([[GYChatManager sharedManager].delegate respondsToSelector:@selector(keyboardShown:)])
    {
        [[GYChatManager sharedManager].delegate keyboardShown:kbSize];
    }
}
//当键盘即将隐藏的时候
- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    if([[GYChatManager sharedManager].delegate respondsToSelector:@selector(keyboradHidden)])
    {
        [[GYChatManager sharedManager].delegate keyboradHidden];
    }
    if(!_iconButton.selected && !_picButton.selected)
    {
        [UIView animateWithDuration:kKeyboardAnimationDuration animations:^{
            [self resetCurrentViewFrame];
        }];
    }
    NSLog(@"键盘隐藏");
}
#pragma -mark UITextViewDelegate
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    _keyboradIsShow = YES;
    return YES;
}
- (void)textViewDidChangeSelection:(UITextView *)textView
{
    [self setTextViewFrame];
    UIEdgeInsets point  = textView.textContainerInset;
    NSLog(@"pointX:%f,%f,%f,%f",point.top,point.left,point.bottom,point.right);
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([text isEqualToString:@"\n"]){ //判断输入的字是否是回车，即按下return
        [self sendMessage];
        return NO; //这里返回NO，就代表return键值失效，即页面上按下return，不会出现换行，如果为yes，则输入页面会换行
    }
    if([text isEqualToString:@"@"])
    {
        if([[GYChatManager sharedManager].delegate respondsToSelector:@selector(clickedAt:)])
        {
            [[GYChatManager sharedManager].delegate clickedAt:text];
        }
    }
    if([text isEqualToString:@""])
    {
        //监听删除事件
        if([_textView.text  isEqual: @""])
        {
            [self hiddenOrientAnswerLabel];
        }
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
