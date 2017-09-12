//
//  KuQUIEngine.h
//  KuQ
//


#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>

#define kRecorderDirectory [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0]  stringByAppendingPathComponent:@"Recorders"]


@interface CL_AudioRecorder : NSObject<AVAudioRecorderDelegate>{
    int m_audioFileCount;
@private
    NSTimer *_recordTimer;
}


@property (nonatomic) int  m_audioFileCount;
@property (nonatomic, assign) void (^finishRecordingBlock)(CL_AudioRecorder *recorder,BOOL success);
@property (nonatomic, assign) void (^encodeErrorRecordingBlock)(CL_AudioRecorder *recorder,NSError *error);
@property (nonatomic, assign) void (^receivedRecordingBlock)(CL_AudioRecorder *recorder,float peakPower,float averagePower,float currentTime);

@property (nonatomic, strong,readonly) AVAudioRecorder* audioRecorder;
@property (nonatomic, strong) NSString *recorderingPath;
@property (nonatomic, assign,readonly) BOOL deletedRecording;

- (id)initWithFinishRecordingBlock:(void (^)(CL_AudioRecorder *recorder,BOOL success))finishRecordingBlock 
         encodeErrorRecordingBlock:(void (^)(CL_AudioRecorder *recorder,NSError *error))encodeErrorRecordingBlock
            receivedRecordingBlock:(void (^)(CL_AudioRecorder *recorder,float peakPower,float averagePower,float currentTime))receivedRecordingBlock;

- (BOOL)startRecord;
- (BOOL)startRecordForDuration: (NSTimeInterval) duration;

- (void)stopRecord;
- (void)stopAndDeleteRecord;
- (void)stopAndDeleteAllRecords;

- (void)cleanAllBlocks;

@end

