//
//  GYChatView.h
//  GYChatTextFieldDemo
//
//  Created by lidianchao on 2017/8/30.
//  Copyright © 2017年 lidianchao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GYChatManager.h"

@interface GYChatView : UIView
/**
 创建底部输入框
 @param style 输入框样式
 */
- (instancetype)initWithFrame:(CGRect)frame viewStyle:(ChatInputViewStyle)style;
- (void)resetFrame;
- (void)changeFrame:(CGRect)newFrame;
@end
