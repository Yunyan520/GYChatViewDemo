//
//  GYChatView.h
//  GYChatTextFieldDemo
//
//  Created by lidianchao on 2017/8/30.
//  Copyright © 2017年 lidianchao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GYChatViewManager.h"
@interface GYChatView : UIView
@property(nonatomic, copy) void(^functionClickedCallback)(UIView *functionItem);
@property(nonatomic, copy) void(^sendMessageCallback)(NSString *msg);
/** 长按发送文件 */
@property(nonatomic, copy) void(^sendFileCallback)(NSString *fileName);
@end
