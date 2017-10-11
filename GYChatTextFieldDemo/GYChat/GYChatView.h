//
//  GYChatView.h
//  GYChatTextFieldDemo
//
//  Created by lidianchao on 2017/8/30.
//  Copyright © 2017年 lidianchao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GYChatManager.h"
#import "GYChatInputCustomView.h"
#import "GYChatViewCount.h"
@interface GYChatView : UIView
/**
 创建底部输入框
 说明：
 1、TypeChat1类型为正常会话类型的输入框，没有切换按钮
 2、TypeChat2类型为公众号类型的输入框，切换按钮用来切换输入状态还是可以点击功能按钮状态
 */
- (instancetype)initWithFrame:(GYConfigChatViewItem *)item;
- (GYChatInputCustomView *)getChatInputCustomView;
- (void)setMuneButtonFrame:(CGRect)newFrame;
- (void)resetMuneButtonFrame;
//- (void)changeChatStyle:(ChatInputViewStyle)style;
//重新布局
- (void)viewWillLayoutSubviews;
@end
