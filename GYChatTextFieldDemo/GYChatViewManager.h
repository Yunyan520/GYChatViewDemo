//
//  GYChatViewManager.h
//  GYChatTextFieldDemo
//
//  Created by lidianchao on 2017/8/31.
//  Copyright © 2017年 lidianchao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#define kFunctionItemTag_Picture 1000
#define kFunctionItemTag_Camera 1001
#define kFunctionItemTag_Video 1002
#define kFunctionItemTag_File 1003
#define kFunctionItemTag_Receipt 1004
#define kFunctionItemTag_VoiceInput 1005


typedef void(^FunctionClickedCallback)(UIView *functionItem);
@interface FunctionButtonModel : NSObject

/** 功能名称 */
@property(nonatomic,copy) NSString *functionName;
/** 常态图片名称 */
@property(nonatomic,copy) NSString *imageName;
/** 高亮图片名称 */
@property(nonatomic,copy) NSString *hlImageName;
/** tag */
@property(nonatomic, assign) NSInteger btnTag;
@end

@interface GYChatViewManager : NSObject
+ (GYChatViewManager *)sharedManager;
/** 获取所有表情 */
- (NSMutableArray *)getAllMotions;
/** 获取所有功能 */
- (NSMutableArray *)getAllFunctionItems;
- (NSMutableArray *)prepareFaceArray;
- (NSMutableArray *)loadFaceArray;
@end
