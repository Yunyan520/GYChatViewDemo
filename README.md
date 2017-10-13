# GYChatViewDemo
# iOS项目基本框架
## 1、iOS仿微信聊天输入框封装搭建
## 2、简易MVC框架
## 3、方法扩展，接口暴露，便于调用
# 代码分析---接口展示
##//
//  GYChatManager.h
//  GYChatTextFieldDemo
//
//  Created by lidianchao on 2017/9/1.
//  Copyright © 2017年 lidianchao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "GYScreen.h"
#import "GYPicView.h"
#import "GYMotionView.h"
#import "GYChatManagerCount.h"
#import "GYVoiceInputPromptView.h"
typedef NS_ENUM(NSInteger, ChatInputViewStyle)
{
/** 类似微信聊天界面输入框 */
TypeChat1,
/** 类似微信公众号输入框 */
TypeChat2
};
typedef void(^ConfigViewCallback)(UIView *view);
@interface GYConfigChatViewItem : NSObject
@property(nonatomic, assign) CGRect inputViewFrame;
@property(nonatomic, assign) ChatInputViewStyle style;
@property(nonatomic, assign) NSInteger type2footerBtnCount;
@property(nonatomic, copy) ConfigViewCallback configViewCallback;
@end


@protocol GYChatManagerDelegate <NSObject>
@optional
/** 点击功能按钮回调 */
- (void)functionClicked:(UIView *)functionItem;
/** 长按发送文件 */
- (void)longPressSendFile:(NSString *)fileName;
/** 发送回调 */
- (void)sendMessage:(NSString *)msg;
/** 弹起键盘回调 */
- (void)keyboardShown:(CGSize)keyboardSize;
/** 点击键盘上@按钮键时回调 */
- (void)clickedAt:(NSString *)msg;
/** 收起键盘回调 */
- (void)keyboradHidden;
/** 语音输入按钮事件 */
- (void)recordTouchUpInside:(id)sender;
- (void)recordTouchUpOutside:(id)sender;
- (void)recordTouchDown:(id)sender;
- (void)recordTouchDragOutside:(id)sender;
- (void)recordTouchDragIn:(id)sender;
@end
@interface GYChatManager : NSObject
@property(nonatomic, assign) id<GYChatManagerDelegate>delegate;
@property(nonatomic, copy) NSString *draft;

+ (GYChatManager *)sharedManager;
/**
创建框架UI
@param item 所需item
*/
- (void)configChatRootView:(GYConfigChatViewItem *)item;
/**
创建语音输入提示UI
@param superView 父视图
@param callback 回调，返回提示view
*/
- (void)configVoiceInputPromtUI:(UIView *)superView callback:(ConfigViewCallback)callback;

/**
更改提示状态
@param status 修改后的提示状态
*/
- (void)InputPromptViewStatus:(PromptStatus)status;
/**
创建功能UI
包含相册、相机、视频等按钮
@param inputViewFrame Frame
@param callback 回调
*/
- (void)configPicView:(CGRect)inputViewFrame callback:(ConfigViewCallback)callback;
/**
创建表情UI
@param inputViewFrame Frame
@param callback 回调
*/
- (void)configMotionView:(CGRect)inputViewFrame callback:(ConfigViewCallback)callback;
/**
是否收起键盘
@param isShow 0为隐藏键盘，1为弹起键盘
*/
- (void)keyboardIsShow:(BOOL)isShow;
/**
对某条消息定向回复
@param messageAnswered 回复的消息
@param userName 消息主人名称
*/
- (void)orientateAnswer:(NSString *)messageAnswered userName:(NSString *)userName;
/**
艾特某人
@param personName 人名
@param isLongPressed 是否通过长按方式
*/
- (void)atSomeone:(NSString *)personName isLongPressed:(BOOL)isLongPressed;
/**
获取当前textView内内容
@return 返回当前textView内容
*/
- (NSString *)getCurrentTextViewMessage;
/**
添加草稿
@param draft 草稿内容
*/
- (void)addDraft:(NSString *)draft;
/**
切换输入框类型
@param newStyle 新类型
*/
//- (void)changeChatStyle:(ChatInputViewStyle)newStyle;
/**
自动布局方法
*/
- (void)viewWillLayoutSubviews;
@end

