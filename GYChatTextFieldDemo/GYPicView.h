//
//  GYPicView.h
//  GYChatTextFieldDemo
//
//  Created by lidianchao on 2017/8/30.
//  Copyright © 2017年 lidianchao. All rights reserved.
//

#import <UIKit/UIKit.h>
#define kFunctionItemTag_Picture 1000
#define kFunctionItemTag_Camera 1001
#define kFunctionItemTag_Video 1002
#define kFunctionItemTag_File 1003
#define kFunctionItemTag_Receipt 1004
#define kFunctionItemTag_VoiceInput 1005
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

@interface GYPicView : UIView
/** 点击按钮回调 */
@property(nonatomic, copy) void(^functionClickedCallback)(UIView *functionItem);
/** 长按发送文件 */
@property(nonatomic, copy) void(^sendFileCallback)(NSString *fileName);
@end
@interface NSDate(myformatter)

/**
 获取特定格式的日期字符串
 
 @param format 日期格式字符串
 
 @return 日期字符串
 */
- (NSString *)my_formattedDateWithFormat:(NSString *)format;

/**
 根据当前地区获取特定格式的日期字符串
 
 @param format 日期格式字符串
 @param locale 当前地区local对象
 
 @return 日期字符串
 */
- (NSString *)my_formattedDateWithFormat:(NSString *)format locale:(NSLocale *)locale;

/**
 根据特定地区、特定NSTimeZone、特定格式字符串，获取日期字符串
 
 @param format   日期格式字符串
 @param timeZone 特定timeZone对象
 @param locale   特定地区local对象
 
 @return 日期字符串
 */
- (NSString *)my_formattedDateWithFormat:(NSString *)format timeZone:(NSTimeZone *)timeZone locale:(NSLocale *)locale;
@end
