//
//  GYPicViewCount.h
//  GYChatTextFieldDemo
//
//  Created by lidianchao on 2017/9/6.
//  Copyright © 2017年 lidianchao. All rights reserved.
//

#ifndef GYPicViewCount_h
#define GYPicViewCount_h

#define kLineX 0
#define kLineY 0
#define kLineHeight 1

#define kBgScrollViewX 0
#define kBgScrollViewY 0
#define kNumberOfIconEachLine 4
#define kNumberOfIconEachLine_6p 5
#define kBtnSize 60
#define kLabelHeight 20
#define kPaddingY 15
#define kNameLabelFont 12
#define kCurrentTime [[NSDate date] timeIntervalSince1970]
#define kCurrentDayBefore(n) kCurrentTime - 60 * 60 * 24 * n
#define kNameLabelRect 0
#define kMinimumPressDuration 1
#define kFunctionItemBaseTag 1000
#define kFunctionItemBaseTitleTag 2000


#define kFunctionItemTag_Picture kFunctionItemBaseTag + 0
#define kFunctionItemTag_Camera kFunctionItemBaseTag + 1
#define kFunctionItemTag_Video kFunctionItemBaseTag + 2
#define kFunctionItemTag_File kFunctionItemBaseTag + 3
#define kFunctionItemTag_Receipt kFunctionItemBaseTag + 4
#define kFunctionItemTag_VoiceInput kFunctionItemBaseTag + 5
#define kFunction_NameArr [NSArray arrayWithObjects:@"照片",@"拍照",@"视频",@"文件",@"回执",@"语音",nil]

#define kFunction_NormalImageArr [NSArray arrayWithObjects:@"chat_picture_icon.png",@"chat_camera_icon.png",@"chat_video_icon.png",@"chat_file_icon.png",@"chat_receipt_icon.png",@"语音输入.png",nil]

#define kFunction_HlImageArr [NSArray arrayWithObjects:@"chat_picture_icon_hl.png",@"chat_camera_icon_hl.png",@"chat_video_icon_hl.png",@"chat_file_icon_hl.png",@"chat_receipt_icon_hl.png",@"voiceInput.png",nil]

#endif /* GYPicViewCount_h */
