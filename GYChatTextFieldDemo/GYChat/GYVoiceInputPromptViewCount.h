//
//  GYVoiceInputPromptViewCount.h
//  GYChatTextFieldDemo
//
//  Created by lidianchao on 2017/9/8.
//  Copyright © 2017年 lidianchao. All rights reserved.
//

#ifndef GYVoiceInputPromptViewCount_h
#define GYVoiceInputPromptViewCount_h

#define kTalkIconViewHeight 120
#define kTalkIconViewY ((kScreenHeight - kNavigationBarHeight) - kTalkIconViewHeight) / 2

#define kTalkIconTalkingViewWidth 131
#define kTalkIconTalkingViewX (self.frame.size.width-kTalkIconTalkingViewWidth)/2.0

#define kTalkimageviewX 131/4.0
#define kTalkimageviewY 5
#define kTalkimageviewWidth kTalkIconTalkingViewWidth/2.0
#define kTalkimageviewHeight kTalkIconViewHeight/2.0
#define kTalkImageAnimationDuration 1
#define kTalkImageAnimationRepeat 0

#define kUpdateTimeLabelX 0
#define kUpdateTimeLabelY 65
#define kUpdateTimeLabelWidth kTalkIconTalkingViewWidth/2.0
#define kUpdateTimeLabelHeight 20

#define kTipLabelRect CGRectMake(0, 90, 131, 20)
#define kTipLabelFont 12

#define kCancleImageX 0
#define kCancleImageY 0

#define cancleLabelX 6.0
#define cancleLabelY 90
#define cancleLabelWidth 119.0
#define cancleLabelHeight 26.0
#define cancleLabelFont 13

#define kTalkingStatus_TalkingImage @"speak_Layer_bj.png"
#define kTalkingStatus_WarningImage @"speak_Layer_bj1.png"
#define kTalkingStatus_CancelImage @"speak_Layer_bj.png"

#endif /* GYVoiceInputPromptViewCount_h */
