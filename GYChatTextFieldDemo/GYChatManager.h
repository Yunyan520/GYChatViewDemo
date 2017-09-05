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
//#import "GYChatView.h"
#import "GYPicView.h"
#import "GYMotionView.h"

typedef NS_ENUM(NSInteger, ChatInputViewStyle)
{
    /** 类似微信聊天界面输入框 */
    TypeChat1,
    /** 类似微信公众号输入框 */
    TypeChat2
};

typedef void(^ConfigViewCallback)(UIView *view);

@interface GYChatManagerItem : NSObject
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
/** 收起键盘回调 */
@property(nonatomic, copy) void(^keyboradHiddenCallback)();
+ (GYChatManager *)sharedManager;
/** 创建框架UI */
- (void)configChatRootView:(GYChatManagerItem *)item;
/** 创建功能UI */
- (void)configPicView:(CGRect)inputViewFrame callback:(ConfigViewCallback)callback;
/** 创建表情UI */
- (void)configMotionView:(CGRect)inputViewFrame callback:(ConfigViewCallback)callback;
@end
