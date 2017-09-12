//
//  KuQUIEngine.h
//  KuQ
//



#import "CL_AudioRecorder.h"

@interface CL_AudioRecorder (Private)
-(NSDictionary *)recordingSettings;
-(NSDictionary *)recordingSettingsWithAudioFormat:(NSNumber*)format;
+(NSString*) stringWithUUID;
-(void)startReceivedRecordingCallBackTimer;
@end

@implementation CL_AudioRecorder
@synthesize recorderingPath = _recorderingPath;
@synthesize audioRecorder =  _audioRecorder;
@synthesize finishRecordingBlock = _finishRecordingBlock;
@synthesize receivedRecordingBlock = _receivedRecordingBlock;
@synthesize encodeErrorRecordingBlock = _encodeErrorRecordingBlock;
@synthesize deletedRecording = _deletedRecording;
@synthesize m_audioFileCount;

- (id)initWithFinishRecordingBlock:(void (^)(CL_AudioRecorder *recorder,BOOL success))finishRecordingBlock 
         encodeErrorRecordingBlock:(void (^)(CL_AudioRecorder *recorder,NSError *error))encodeErrorRecordingBlock
            receivedRecordingBlock:(void (^)(CL_AudioRecorder *recorder,float peakPower,float averagePower,float currentTime))receivedRecordingBlock {
    
    self = [super init];
    if (self) {
        
        _finishRecordingBlock= finishRecordingBlock;
        _encodeErrorRecordingBlock= encodeErrorRecordingBlock;
        _receivedRecordingBlock= receivedRecordingBlock;
        
        m_audioFileCount = 0;
    }
    return self;
}
- (void)cleanAllBlocks{
    _finishRecordingBlock= nil;
    _encodeErrorRecordingBlock= nil;
    _receivedRecordingBlock= nil;
}


- (BOOL)startRecord
{
    return [self startRecordForDuration:0];    
}
- (BOOL)startRecordForDuration: (NSTimeInterval) duration
{
    if (!_audioRecorder.recording) {
        
        AVAudioSession *audioSession = [AVAudioSession sharedInstance];
        if ([[audioSession category] isEqualToString:AVAudioSessionCategoryPlayAndRecord] ||
            [[audioSession category] isEqualToString:AVAudioSessionCategoryRecord]) {
            if ([audioSession inputIsAvailable]) {
                
                NSError * error = NULL;
                if (![[NSFileManager defaultManager] fileExistsAtPath:kRecorderDirectory]) {
                    [[NSFileManager defaultManager] createDirectoryAtPath:kRecorderDirectory 
                                              withIntermediateDirectories:YES 
                                                               attributes:nil 
                                                                    error:&error];
                }
                if (!error) {
#if  TARGET_IPHONE_SIMULATOR
//                    NSString *fullPath = [kRecorderDirectory stringByAppendingPathComponent:
//                                          [NSString stringWithFormat:@"%@.caf",[[self class] stringWithUUID]]];
                    NSString *fullPath = [kRecorderDirectory stringByAppendingPathComponent:
                                          [NSString stringWithFormat:@"recordAudio.caf"]];
#else
//                    NSString *fullPath = [kRecorderDirectory stringByAppendingPathComponent:
//                                          [NSString stringWithFormat:@"%@.aac",[[self class] stringWithUUID]]];
                    NSString *fullPath = [kRecorderDirectory stringByAppendingPathComponent:
                                          [NSString stringWithFormat:@"recordAudio.wav"]];
#endif
                    
                    NSDictionary *recordingSettings = [self recordingSettings];
					NSURL *fullPathURL = [NSURL fileURLWithPath:fullPath];

//					update by shisp
					if(self.recorderingPath && self.recorderingPath.length > 0)
					{
						fullPathURL  = [NSURL fileURLWithPath:self.recorderingPath];
					}
 					
                    _audioRecorder = [[AVAudioRecorder alloc] initWithURL:fullPathURL 
                                                                 settings:recordingSettings 
                                                                    error:&error];
                    
//                    float version = [[[UIDevice currentDevice] systemVersion] floatValue];
//                    if (version < 6.0) { //小于ios6.0的处理
                    _audioRecorder.delegate = self;
//                       }
                    _audioRecorder.meteringEnabled = YES;
                    
                    if (!error) {
                        if ([_audioRecorder prepareToRecord]) {
                            
//                            _recorderingPath = [fullPath retain];
                            _deletedRecording = NO;
                            [self startReceivedRecordingCallBackTimer];
                            if (duration < 0.001) {
                                return [_audioRecorder record]; 
                            }
                            else {
                                return [_audioRecorder recordForDuration:duration]; 
                            }
                        }
                        else NSLog(@"AVAudioRecorder prepareToRecord failure.");
                    }
                    else NSLog(@"AVAudioRecorder alloc failure.");
                }
                else NSLog(@"AVAudioRecorder createDirectoryAtPath failure.");
                
            }
            else NSLog(@"Audio input hardware not available.");
        }
        else NSLog(@"AudioSession  not allowed to record.");
    }
    else NSLog(@"AVAudioRecorder  already in recording.");
    
    return NO;
}

- (void)stopRecord
{    
    double delayInSeconds = 0.1; //0629 0.1
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        if(_recordTimer){[_recordTimer invalidate]; _recordTimer=nil;}
        if (_audioRecorder.recording) {
            [_audioRecorder stop];
            [[AVAudioSession sharedInstance] setActive:NO error:nil];
        }
        else NSLog(@"AVAudioRecorder  in  not in recording.");
    });
}
- (void)stopAndDeleteRecord
{
    double delayInSeconds = 0.1; //0.1
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        if(_recordTimer){[_recordTimer invalidate]; _recordTimer=nil;}
        
        if (_audioRecorder.recording) {
            [_audioRecorder stop];
        }
        if (!_deletedRecording) {
            _deletedRecording = [_audioRecorder deleteRecording];
        }
    });
}

- (void)stopAndDeleteAllRecords
{
    double delayInSeconds = 0.1; //0.1
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        if(_recordTimer){[_recordTimer invalidate]; _recordTimer=nil;}
        
        if (_audioRecorder.recording) {
            [_audioRecorder stop];
        }
        if (!_deletedRecording) {
            _deletedRecording = [_audioRecorder deleteRecording];
        } 
        if ([[NSFileManager defaultManager] fileExistsAtPath:kRecorderDirectory]) {
            [[NSFileManager defaultManager] createDirectoryAtPath:kRecorderDirectory 
                                      withIntermediateDirectories:YES 
                                                       attributes:nil 
                                                            error:nil];
        }
    });
}
- (void)audioRecorderDidFinishRecording:(AVAudioRecorder *)recorder successfully:(BOOL)flag {
    if(_recordTimer){[_recordTimer invalidate]; _recordTimer=nil;}
    if (_finishRecordingBlock) {
        _finishRecordingBlock(self,flag);
    }
}
- (void)audioRecorderEncodeErrorDidOccur:(AVAudioRecorder *)recorder error:(NSError *)error {
    if(_recordTimer){[_recordTimer invalidate]; _recordTimer=nil;}
    if (_encodeErrorRecordingBlock) {
        _encodeErrorRecordingBlock(self,error);
    }
}
- (void)audioRecorderReceivedRecordingCallBack:(NSTimer*)timer
{
    if (_receivedRecordingBlock) {
        if (_audioRecorder.recording) {
            [_audioRecorder updateMeters];
            float peakPower = pow(10, (0.05 * [_audioRecorder peakPowerForChannel:0]));
            float averagePower = pow(10, (0.05 * [_audioRecorder averagePowerForChannel:0]));
            float currentTime = _audioRecorder.currentTime;
            _receivedRecordingBlock(self,peakPower,averagePower,currentTime);
        }  
    }
}

#pragma mark - Private methods

- (void)startReceivedRecordingCallBackTimer{
    if(_recordTimer){[_recordTimer invalidate]; _recordTimer=nil;}
    _recordTimer = [NSTimer scheduledTimerWithTimeInterval:0.1 
                                                    target:self
                                                  selector:@selector(audioRecorderReceivedRecordingCallBack:) 
                                                  userInfo:nil 
                                                   repeats:YES];
    NSRunLoop *runLoop = [NSRunLoop currentRunLoop]; 
    [runLoop addTimer:_recordTimer forMode:NSDefaultRunLoopMode];
    
}
-(NSDictionary *)recordingSettings
{    
#if  TARGET_IPHONE_SIMULATOR
    return  [NSDictionary dictionaryWithObjectsAndKeys:
            [NSNumber numberWithInt:kAudioFormatLinearPCM], AVFormatIDKey,
            [NSNumber numberWithFloat:44100.0], AVSampleRateKey,
            [NSNumber numberWithInt: 2], AVNumberOfChannelsKey,
            [NSNumber numberWithInt:16], AVLinearPCMBitDepthKey, 
            [NSNumber numberWithInt:AVAudioQualityMax],AVEncoderAudioQualityKey,
            [NSNumber numberWithBool:NO], AVLinearPCMIsBigEndianKey, 
            [NSNumber numberWithBool:NO], AVLinearPCMIsFloatKey, nil];
    
#else
//    return   [NSDictionary dictionaryWithObjectsAndKeys:
//            [NSNumber numberWithInt:kAudioFormatMPEG4AAC], AVFormatIDKey,
//            [NSNumber numberWithFloat:8000.0], AVSampleRateKey,
//            [NSNumber numberWithInt:1], AVNumberOfChannelsKey,
//            [NSNumber numberWithInt:8], AVLinearPCMBitDepthKey,
//            [NSNumber numberWithInt:96], AVEncoderBitRateKey,
//            [NSNumber numberWithInt:AVAudioQualityMin],AVEncoderAudioQualityKey,
//            [NSNumber numberWithBool:NO], AVLinearPCMIsBigEndianKey, 
//            [NSNumber numberWithBool:NO], AVLinearPCMIsFloatKey, nil];
   return
     [[NSDictionary alloc] initWithObjectsAndKeys:
     [NSNumber numberWithFloat: 8000.0],AVSampleRateKey, //采样率
     [NSNumber numberWithInt: kAudioFormatLinearPCM],AVFormatIDKey,
     [NSNumber numberWithInt:16],AVLinearPCMBitDepthKey,//采样位数 默认 16
     [NSNumber numberWithInt: 1], AVNumberOfChannelsKey,//通道的数目
     //                                   [NSNumber numberWithBool:NO],AVLinearPCMIsBigEndianKey,//大端还是小端 是内存的组织方式
     //                                   [NSNumber numberWithBool:NO],AVLinearPCMIsFloatKey,//采样信号是整数还是浮点数
     //                                   [NSNumber numberWithInt: AVAudioQualityMedium],AVEncoderAudioQualityKey,//音频编码质量
     nil];
            //24000.0  1 8 96
#endif
}

+(NSString*) stringWithUUID
{
    CFUUIDRef uuidObj = CFUUIDCreate(kCFAllocatorDefault);
    CFStringRef strRef = CFUUIDCreateString(kCFAllocatorDefault, uuidObj);
    NSString* uuidString = [NSString stringWithString:(__bridge NSString*)strRef];
    CFRelease(strRef);
    CFRelease(uuidObj);
    return uuidString;
}

@end

