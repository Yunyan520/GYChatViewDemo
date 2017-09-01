//
//  GYChatViewManager.m
//  GYChatTextFieldDemo
//
//  Created by lidianchao on 2017/8/31.
//  Copyright © 2017年 lidianchao. All rights reserved.
//

#import "GYChatViewManager.h"
#import "faceDefine.h"
#import "GYScreen.h"
@implementation FunctionButtonModel

@end
static GYChatViewManager *instance = nil;
@implementation GYChatViewManager
{
    NSMutableArray *_bqStrArray;
    NSMutableArray *_phraseArray;
}
+ (GYChatViewManager *)sharedManager
{
    static dispatch_once_t pred;
    dispatch_once(&pred, ^{
        instance = [[GYChatViewManager alloc] init];
        [instance loadFaceArray];
        [instance prepareFaceArray];
    });
    return instance;
}

- (NSMutableArray *)getAllFunctionItems
{
    NSMutableArray *functionArray = [[NSMutableArray alloc]init];
    FunctionButtonModel *button = nil;
    //    照片按钮
    button = [[FunctionButtonModel alloc]init];
    button.functionName = @"照片";
    button.imageName = @"chat_picture_icon.png";
    button.hlImageName = @"chat_picture_icon_hl.png";
    button.btnTag = kFunctionItemTag_Picture;
    [functionArray addObject:button];
    //    拍照按钮
    button = [[FunctionButtonModel alloc]init];
    button.functionName = @"拍照";
    button.imageName = @"chat_camera_icon.png";
    button.hlImageName = @"chat_camera_icon_hl.png";
    button.btnTag = kFunctionItemTag_Camera;
    [functionArray addObject:button];
    //    视频按钮
    button = [[FunctionButtonModel alloc]init];
    button.functionName = @"视频";
    button.imageName = @"chat_video_icon.png";
    button.hlImageName = @"chat_video_icon_hl.png";
    button.btnTag = kFunctionItemTag_Video;
    [functionArray addObject:button];
    //文件按钮
    button = [[FunctionButtonModel alloc]init];//文件
    button.functionName = @"文件";
    button.imageName = @"chat_file_icon.png";
    button.hlImageName = @"chat_file_icon_hl.png";
    button.btnTag = kFunctionItemTag_File;
    [functionArray addObject:button];
    //回执按钮
    button = [[FunctionButtonModel alloc]init];
    button.functionName = @"回执";
    button.imageName = @"chat_receipt_icon.png";
    button.hlImageName = @"chat_receipt_icon_hl.png";
    button.btnTag = kFunctionItemTag_Receipt;
    [functionArray addObject:button];
    //语音按钮
    button = [[FunctionButtonModel alloc]init];
    button.functionName = @"语音";
    button.imageName = @"语音输入.png";
    button.hlImageName = @"voiceInput.png";
    button.btnTag = kFunctionItemTag_VoiceInput;
    [functionArray addObject:button];
    return functionArray;
}
//准备表情数组
- (NSMutableArray *)prepareFaceArray{
    //聊天表情相关
    NSMutableArray *temp = [[NSMutableArray alloc] init];
    NSString *faceName = @"";
    
    for (int i = 0; i < [_bqStrArray count]; i++){
        //		 表情名字
        faceName = [NSString stringWithFormat:@"%@_%@.png", @"face",[_bqStrArray objectAtIndex:i]];
        //        表情对应的image对象
        UIImage *face = [UIImage imageNamed:faceName];// [NSString stringWithFormat:@"%03d.png",i+1]];
        NSMutableDictionary *dicFace = [NSMutableDictionary dictionary];
        [dicFace setValue:face forKey:[NSString stringWithFormat:@"[/%@]",[_bqStrArray objectAtIndex:i]]];// [NSString stringWithFormat:@"[/%03d]",i+1]];
        [temp addObject:dicFace];
        _phraseArray = temp;
    }
    return _phraseArray;
}
#pragma mark - 初始化表情集合
- (NSMutableArray *)loadFaceArray{
    
    if (_bqStrArray == nil || _bqStrArray.count == 0) {
        // 加载表情数据

        _bqStrArray = faceAfterName;

        int rowCount = 8;   // 一行显示的表情个数
        //支持竖屏
        if (IS_IPHONE) {
            if (IS_IPHONE_6P) {
                rowCount = 9;
            }
        }else if (IS_IPAD){
            if (kScreenWidth < kScreenHeight) {
                rowCount = 10;
            }else{
                rowCount = 14;
            }
        }
        
        NSInteger pageCount = _bqStrArray.count/(rowCount * 4); // 表情的总的页数
        // 为表情的每一页的最后添加一个删除表情
        for (int i = 0; i < pageCount+1; i++) {
            NSInteger scIndex = 4*rowCount*(i+1)-1;
            if (i == pageCount) {
                // 0911 最后一页不显示删除按钮
                break;
            }else if(i == 0){
                scIndex = (4*rowCount-1)*(i+1);
            }
            [_bqStrArray insertObject:@"sc" atIndex:scIndex];
        }
    }
    return _bqStrArray;
}

@end
