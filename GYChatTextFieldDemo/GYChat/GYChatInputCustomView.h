//
//  GYChatInputCustomView.h
//  GYChatTextFieldDemo
//
//  Created by lidianchao on 2017/9/5.
//  Copyright © 2017年 lidianchao. All rights reserved.
//


/**
 *创建会话状态下输入框view
 *包含语音、文字切换按钮输入框,语音输入按钮,表情选择按钮,功能选择按钮
 */
#import <UIKit/UIKit.h>
#import "GYChatManager.h"
#import "GYChatInputCustomViewCount.h"
@interface GYChatInputCustomViewItem : NSObject
@property(nonatomic, assign) CGRect currentViewFrame;
@property(nonatomic, assign) CGRect talkButtonFrame;
@property(nonatomic, assign) CGRect textViewFrame;
@property(nonatomic, assign) CGRect pressButtonFrame;
@property(nonatomic, assign) CGRect iconButtonFrame;
@property(nonatomic, assign) CGRect picButtonFrame;
@property(nonatomic, assign) UIView *currentSuperView;
@property(nonatomic, assign) ChatInputViewStyle style;
@end

@interface GYChatInputCustomView : UIView
- (instancetype)initWithItem:(GYChatInputCustomViewItem *)item;
- (void)menuBtnSelected:(BOOL)isSelected;
- (void)keyBoardIsShow:(BOOL)isShow;
- (void)orientateAnswer:(NSString *)messageAnswered userName:(NSString *)userName;
- (void)atSomeone:(NSString *)personName isLongPressed:(BOOL)isLongPressed;
- (NSString *)getCurrentTextViewMessage;
- (void)addDraft:(NSString *)draft;
//重新布局
- (void)viewWillLayoutSubviews;
@end
