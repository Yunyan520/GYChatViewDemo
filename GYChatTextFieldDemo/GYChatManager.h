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
#import "GYChatView.h"
#import "GYPicView.h"
#import "GYMotionView.h"

typedef NS_ENUM(NSInteger, InputViewStyle)
{
    /** 类似微信聊天界面输入框 */
    TypeChat1,
    /** 类似微信公众号输入框 */
    TypeChat2
};

@interface GYChatManagerItem : NSObject
@property(nonatomic, assign) CGRect inputViewFrame;
@property(nonatomic, assign) InputViewStyle style;
@end

typedef void(^ConfigViewCallback)(UIView *view);
@interface GYChatManager : NSObject
/** 点击功能按钮回调 */
@property(nonatomic, copy) void(^functionClickedCallback)(UIView *functionItem);
/** 长按发送文件 */
@property(nonatomic, copy) void(^sendFileCallback)(NSString *fileName);
/** 发送回调 */
@property(nonatomic, copy) void(^sendMessageCallback)(NSString *msg);
+ (GYChatManager *)sharedManager;
/** 创建框架UI */
- (void)configChatRootView:(CGRect)viewFrame callback:(ConfigViewCallback)callback;
/** 创建功能UI */
- (void)configPicView:(CGRect)inputViewFrame callback:(ConfigViewCallback)callback;
/** 创建表情UI */
- (void)configMotionView:(CGRect)inputViewFrame callback:(ConfigViewCallback)callback;
@end
