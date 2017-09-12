//
//  RecordManager.h
//  GYChatTextFieldDemo
//
//  Created by lidianchao on 2017/9/12.
//  Copyright © 2017年 lidianchao. All rights reserved.
//

#import <Foundation/Foundation.h>
@protocol RecordStatusDelegate <NSObject>

@optional

//状态：开始录音
- (void)willStartRecord;

//状态：停止录音
- (void)willStopRecord;

//状态：录音持续时间
- (void)recordTime:(NSNumber *)second;

//状态：播放录音
- (void)willPlayVoice;

//状态：停止播放录音
- (void)willStopVoice;

//状态：暂停播放录音
- (void)willPauseVoice;

//状态：上传完成
- (void)uploadFinished:(NSArray *)result;

@end
@interface RecordManager : NSObject

@property (nonatomic,assign) id<RecordStatusDelegate> delegate;

+ (RecordManager *)sharedManager;
//开始录音
- (BOOL)startRecord;

//判断是否正在录音
- (BOOL)isRecording;

//停止录音
- (BOOL)stopRecord;

//播放录音
- (BOOL)playVoice;

//停止播放录音
- (BOOL)stopVoice;

//暂停播放录音
- (BOOL)pauseVoice;

//上传语音
- (BOOL)uploadVoice;

//下载语音
- (BOOL)downloadVoice;
@end
