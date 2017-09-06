//
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


@interface GYChatManager : NSObject
/** 点击功能按钮回调 */
@property(nonatomic, copy) void(^functionClickedCallback)(UIView *functionItem);
/** 长按发送文件 */
@property(nonatomic, copy) void(^sendFileCallback)(NSString *fileName);
/** 发送回调 */
@property(nonatomic, copy) void(^sendMessageCallback)(NSString *msg);
/** 弹起键盘回调 */
@property(nonatomic, copy) void(^keyboardShownCallback)(CGSize keyboardSize);
/** 点击键盘上@按钮键时回调 */
@property(nonatomic, copy) void(^clickedAtCallback)(NSString *msg);

/** 收起键盘回调 */
@property(nonatomic, copy) void(^keyboradHiddenCallback)();
+ (GYChatManager *)sharedManager;
/** 创建框架UI */
- (void)configChatRootView:(GYConfigChatViewItem *)item;
/** 创建功能UI */
- (void)configPicView:(CGRect)inputViewFrame callback:(ConfigViewCallback)callback;
/** 创建表情UI */
- (void)configMotionView:(CGRect)inputViewFrame callback:(ConfigViewCallback)callback;
/**
 是否收起键盘
 @param isShow 0为隐藏键盘，1为弹起键盘
 */
- (void)keyboardIsShow:(BOOL)isShow;

/**
 定向回复
 @param personName 对谁进行定向回复
 @param isLongPressed 是否通过长按方式
 */
- (void)orientateAnswer:(NSString *)personName isLongPressed:(BOOL)isLongPressed;
/**
 添加草稿
 @param draft 草稿内容
 */
- (void)addDraft:(NSString *)draft;
@end
