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
 */
- (instancetype)initWithFrame:(GYConfigChatViewItem *)item;
- (GYChatInputCustomView *)getChatInputCustomView;
- (void)setMuneButtonFrame:(CGRect)newFrame;
- (void)resetMuneButtonFrame;
@end
