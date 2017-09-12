//
//  RecordManager.m
//  GYChatTextFieldDemo
//
//  Created by lidianchao on 2017/9/12.
//  Copyright © 2017年 lidianchao. All rights reserved.
//

#import "RecordManager.h"
static RecordManager *instance = nil;
@implementation RecordManager
- (instancetype)init
{
    self = [super init];
    if(self)
    {
        
    }
    return self;
}
+ (RecordManager *)sharedManager
{
    static dispatch_once_t once_token;
    dispatch_once(&once_token, ^{
        instance = [[RecordManager alloc] init];
    });
    return instance;
}
#pragma -mark publicMethod
//开始录音
- (BOOL)startRecord
{
    return NO;
}
//判断是否正在录音
- (BOOL)isRecording
{
    return NO;
}
//停止录音
- (BOOL)stopRecord
{
    return NO;
}
//播放录音
- (BOOL)playVoice
{
    return NO;
}
//停止播放录音
- (BOOL)stopVoice
{
    return NO;
}
//暂停播放录音
- (BOOL)pauseVoice
{
    return NO;
}
//上传语音
- (BOOL)uploadVoice
{
    return NO;
}
//下载语音
- (BOOL)downloadVoice
{
    return NO;
}
@end
