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
    float _talkViewY;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        [self initEvent];
        [self configTalkingUI];
        [self configWarmingUI];
        [self configCancleUI];
    }
    return self;
}
- (void)initEvent
{
    _talkViewY = ((kScreenHeight - 64) - 120) / 2;
}
- (void)configTalkingUI
{
    UIImageView *talkIconView=[[UIImageView alloc]initWithFrame:CGRectMake((self.frame.size.width-131)/2.0, _talkViewY, 131, 120)];
    talkIconView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleRightMargin;
    talkIconView.image = [UIImage imageNamed:@"speak_Layer_bj.png"];
    [self addSubview:talkIconView];
    talkIconView.hidden=YES;
    
    
    UIImageView *talkimageview=[[UIImageView alloc]initWithFrame:CGRectMake(131/4.0, 5, 131/2.0, 120/2)];
    talkimageview.animationImages = [NSArray arrayWithObjects:
                                     [UIImage imageNamed:@"Microphone_ico01.png"],
                                     [UIImage imageNamed:@"Microphone_ico02.png"],
                                     [UIImage imageNamed:@"Microphone_ico03.png"],nil];
    
    // all frames will execute in 1.75 seconds
    talkimageview.animationDuration = 1;
    // repeat the annimation forever
    talkimageview.animationRepeatCount = 0;
    // start animating
    [talkimageview startAnimating];
    [talkIconView addSubview:talkimageview];
    
    UILabel *updateTimeLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 65, 131/2.0, 20)];
    updateTimeLabel.textAlignment=NSTextAlignmentCenter;
    updateTimeLabel.backgroundColor=[UIColor clearColor];
    [talkimageview addSubview:updateTimeLabel];
    
    UILabel *tipLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 90, 131, 20)];
    //    tipLabel.text=@"滑动到此可以取消发送";
    tipLabel.tag = 11;
    tipLabel.textAlignment=NSTextAlignmentCenter;
    tipLabel.font=[UIFont systemFontOfSize:12];
    tipLabel.backgroundColor=[UIColor clearColor];
    [talkIconView addSubview:tipLabel];
}
- (void)configWarmingUI
{
    //录音不播放提示。
    UIImageView *talkIconWarningView=[[UIImageView alloc]initWithFrame:CGRectMake((self.frame.size.width-131)/2.0, _talkViewY, 131, 120)];
    talkIconWarningView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleRightMargin;
    talkIconWarningView.image=[UIImage imageNamed:@"speak_Layer_bj1.png"];
    [self addSubview:talkIconWarningView];
    talkIconWarningView.hidden=YES;
    
    
    UILabel *warningtipLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 90, 131, 20)];
    //    warningtipLabel.text=@"说话时间太短";
    warningtipLabel.tag = 11;
    warningtipLabel.textColor=[UIColor whiteColor];
    warningtipLabel.textAlignment=NSTextAlignmentCenter;
    warningtipLabel.font=[UIFont systemFontOfSize:12];
    warningtipLabel.backgroundColor=[UIColor clearColor];
    [talkIconWarningView addSubview:warningtipLabel];
}
- (void)configCancleUI
{
    UIImageView *talkIconCancelView=[[UIImageView alloc]initWithFrame:CGRectMake((self.frame.size.width-131)/2.0, _talkViewY, 131, 120)];
    talkIconCancelView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleRightMargin;
    talkIconCancelView.image=[UIImage imageNamed:@"speak_Layer_bj.png"];
    UIImageView*imageview=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 131, 120)];
    imageview.image=[UIImage imageNamed:@"cancel_audio.png"];
    [talkIconCancelView addSubview:imageview];
    [self addSubview:talkIconCancelView];
    talkIconCancelView.hidden=YES;
    
    UILabel *cancelLabel=[[UILabel alloc]initWithFrame:CGRectMake(6.0, 90, 119.0, 26.0)];
    cancelLabel.tag = 11;
    cancelLabel.textAlignment=NSTextAlignmentCenter;
    cancelLabel.textColor = [UIColor whiteColor];
    cancelLabel.font=[UIFont systemFontOfSize:13.0];
    cancelLabel.backgroundColor=[UIColor redColor];
    [talkIconCancelView addSubview:cancelLabel];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
