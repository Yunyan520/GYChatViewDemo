//
//  GYVoiceInputPromptView.h
//  GYChatTextFieldDemo
//
//  Created by lidianchao on 2017/9/8.
//  Copyright © 2017年 lidianchao. All rights reserved.
//



#import <UIKit/UIKit.h>
#import "GYVoiceInputPromptViewCount.h"
typedef NS_ENUM(NSInteger, PromptStatus)
{
    PromptStatus_Talking,
    PromptStatus_Warnning,
    PromptStatus_Cancle
};
//语音输入提示UI
@interface GYVoiceInputPromptView : UIView
- (void)InputPromptViewStatus:(PromptStatus)status;
@end
