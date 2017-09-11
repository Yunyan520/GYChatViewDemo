//
//  GYVoiceInputPromptView.m
//  GYChatTextFieldDemo
//
//  Created by lidianchao on 2017/9/8.
//  Copyright © 2017年 lidianchao. All rights reserved.
//


#import "GYVoiceInputPromptView.h"
#import "GYScreen.h"
@implementation GYVoiceInputPromptView
{
    UIImageView *_talkIconTalkingView;
    UIImageView *_talkIconWarningView;
    UIImageView *_talkIconCancelView;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        [self configTalkingUI];
        [self configWarmingUI];
        [self configCancleUI];
    }
    return self;
}

- (void)configTalkingUI
{
    _talkIconTalkingView = [[UIImageView alloc]initWithFrame:CGRectMake(kTalkIconTalkingViewX, kTalkIconViewY, kTalkIconTalkingViewWidth, kTalkIconViewHeight)];
    _talkIconTalkingView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleRightMargin;
    _talkIconTalkingView.image = [UIImage imageNamed:@"speak_Layer_bj.png"];
    [self addSubview:_talkIconTalkingView];
    _talkIconTalkingView.hidden = YES;
    
    UIImageView *talkimageview = [[UIImageView alloc]initWithFrame:CGRectMake(kTalkimageviewX, kTalkimageviewY, kTalkimageviewWidth, kTalkimageviewHeight)];
    talkimageview.animationImages = [NSArray arrayWithObjects:
                                     [UIImage imageNamed:@"Microphone_ico01.png"],
                                     [UIImage imageNamed:@"Microphone_ico02.png"],
                                     [UIImage imageNamed:@"Microphone_ico03.png"],nil];
    
    // all frames will execute in 1.75 seconds
    talkimageview.animationDuration = kTalkImageAnimationDuration;
    // repeat the annimation forever
    talkimageview.animationRepeatCount = kTalkImageAnimationRepeat;
    // start animating
    [talkimageview startAnimating];
    [_talkIconTalkingView addSubview:talkimageview];
    
    UILabel *updateTimeLabel = [[UILabel alloc]initWithFrame:CGRectMake(kUpdateTimeLabelX, kUpdateTimeLabelY, kUpdateTimeLabelWidth, kUpdateTimeLabelHeight)];
    updateTimeLabel.textAlignment = NSTextAlignmentCenter;
    updateTimeLabel.backgroundColor = [UIColor clearColor];
    [talkimageview addSubview:updateTimeLabel];
    
    UILabel *tipLabel = [[UILabel alloc]initWithFrame:kTipLabelRect];
    tipLabel.text=@"滑动到此可以取消发送";
    tipLabel.textAlignment = NSTextAlignmentCenter;
    tipLabel.font = [UIFont systemFontOfSize:kTipLabelFont];
    tipLabel.backgroundColor = [UIColor clearColor];
    [_talkIconTalkingView addSubview:tipLabel];
}
- (void)configWarmingUI
{
    //录音不播放提示。
    _talkIconWarningView = [[UIImageView alloc]initWithFrame:CGRectMake(kTalkIconTalkingViewX, kTalkIconViewY, kTalkIconTalkingViewWidth, kTalkIconViewHeight)];
    _talkIconWarningView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleRightMargin;
    _talkIconWarningView.image = [UIImage imageNamed:@"speak_Layer_bj1.png"];
    [self addSubview:_talkIconWarningView];
    _talkIconWarningView.hidden = YES;
    
    UILabel *warningtipLabel = [[UILabel alloc]initWithFrame:kTipLabelRect];
    warningtipLabel.text=@"说话时间太短";
    warningtipLabel.textColor = [UIColor whiteColor];
    warningtipLabel.textAlignment = NSTextAlignmentCenter;
    warningtipLabel.font = [UIFont systemFontOfSize:kTipLabelFont];
    warningtipLabel.backgroundColor = [UIColor clearColor];
    [_talkIconWarningView addSubview:warningtipLabel];
}
- (void)configCancleUI
{
    _talkIconCancelView = [[UIImageView alloc]initWithFrame:CGRectMake(kTalkIconTalkingViewX, kTalkIconViewY, kTalkIconTalkingViewWidth, kTalkIconViewHeight)];
    _talkIconCancelView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleRightMargin;
    _talkIconCancelView.image = [UIImage imageNamed:@"speak_Layer_bj.png"];
    UIImageView*imageview = [[UIImageView alloc]initWithFrame:CGRectMake(kCancleImageX, kCancleImageY, kTalkIconTalkingViewWidth, kTalkIconViewHeight)];
    imageview.image = [UIImage imageNamed:@"cancel_audio.png"];
    [_talkIconCancelView addSubview:imageview];
    [self addSubview:_talkIconCancelView];
    _talkIconCancelView.hidden = YES;
    
    UILabel *cancleLabel = [[UILabel alloc]initWithFrame:CGRectMake(cancleLabelX, cancleLabelY, cancleLabelWidth, cancleLabelHeight)];
    cancleLabel.textAlignment = NSTextAlignmentCenter;
    cancleLabel.textColor = [UIColor whiteColor];
    cancleLabel.font = [UIFont systemFontOfSize:cancleLabelFont];
    cancleLabel.text = @"滑到此处取消";
//    cancleLabel.backgroundColor = [UIColor redColor];
    [_talkIconCancelView addSubview:cancleLabel];
}
#pragma -mark publicMethods
- (void)InputPromptViewStatus:(PromptStatus)status
{
    switch (status) {
        case PromptStatus_IsTalking:
            _talkIconWarningView.hidden = YES;
            _talkIconCancelView.hidden = YES;
            _talkIconTalkingView.hidden = NO;
            break;
        case PromptStatus_WarnningTooShort:
            _talkIconWarningView.hidden = NO;
            _talkIconCancelView.hidden = YES;
            _talkIconTalkingView.hidden = YES;
            break;
        case PromptStatus_WarnningCancle:
            _talkIconWarningView.hidden = YES;
            _talkIconCancelView.hidden = NO;
            _talkIconTalkingView.hidden = YES;
            break;
        case PromptStatus_End:
            _talkIconWarningView.hidden = YES;
            _talkIconCancelView.hidden = YES;
            _talkIconTalkingView.hidden = YES;
        default:
            break;
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
