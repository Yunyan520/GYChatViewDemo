//
//  GYPicView.m
//  GYChatTextFieldDemo
//
//  Created by lidianchao on 2017/8/30.
//  Copyright © 2017年 lidianchao. All rights reserved.
//

#import "GYPicView.h"
#import "GYScreen.h"
#define kHomeDic [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES) objectAtIndex:0]
#define kGetCachesPath [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject]
#define kSDCrashFileDirectory [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject]
@interface GYPicView()<UIScrollViewDelegate>

@end

@implementation FunctionButtonModel



@end

@implementation GYPicView
{
    NSMutableArray *_functionArray;
    UIScrollView *_bgScrollview;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        [self addFunctionItem];
        [self configUI];
    }
    return self;
}
- (void)addFunctionItem
{
    _functionArray = [self getAllFunctionItems];
}
- (void)configUI
{
    [self configBgScrollView];
    [self configFunctionItemIcon];
}
- (void)configBgScrollView
{
    CGRect _baScrollRect = CGRectMake(kBgScrollViewX, kBgScrollViewY, self.frame.size.width, self.frame.size.height);
    _bgScrollview = [[UIScrollView alloc]initWithFrame:_baScrollRect];
    _bgScrollview.scrollsToTop = NO;
    _bgScrollview.pagingEnabled = YES;
    _bgScrollview.delegate = self;
    _bgScrollview.showsHorizontalScrollIndicator = NO;
    _bgScrollview.showsVerticalScrollIndicator = NO;
    _bgScrollview.backgroundColor = [UIColor clearColor];
    [self addSubview:_bgScrollview];
}
- (void)configFunctionItemIcon
{
    for (UIView *eachView in [_bgScrollview subviews])
    {
        [eachView removeFromSuperview];
    }//清空后再添加
    
    NSUInteger sumnum = _functionArray.count;
    
    int numberOfIconEachLine = kNumberOfIconEachLine;
    if ( IS_IPHONE_6P) {
        numberOfIconEachLine = kNumberOfIconEachLine_6p;
    }
    
//    float buttonSize = 60.0;
//    float labelHeight = 20.0;
    
    unsigned long page = sumnum / numberOfIconEachLine + (sumnum % numberOfIconEachLine ? 1 : 0);
    
    float paddingX = (_bgScrollview.frame.size.width - numberOfIconEachLine * kBtnSize) / (numberOfIconEachLine + 1);
//    float paddingY = 15;
    
    _bgScrollview.pagingEnabled = YES;
    _bgScrollview.scrollEnabled = YES;
    _bgScrollview.contentSize = CGSizeMake(_bgScrollview.frame.size.width, (kPaddingY + kBtnSize + kLabelHeight) * page);
    
    for (int i = 0; i < sumnum; i++) {
        
        FunctionButtonModel *model = [_functionArray objectAtIndex:i];
        
        int row = i / numberOfIconEachLine;
        int col = i % numberOfIconEachLine;
        
        UIButton *iconbutton=[[UIButton alloc]initWithFrame:CGRectMake(paddingX + (kBtnSize + paddingX) * col,kPaddingY + (kPaddingY + kBtnSize + kLabelHeight) * row ,kBtnSize,kBtnSize)];
        iconbutton.backgroundColor=[UIColor clearColor];
        iconbutton.tag = model.btnTag;
        [iconbutton addTarget:self action:@selector(functionItemBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        if (i + kFunctionItemTag == kFunctionItemTag_Picture) {
            [self addLongPressToButton:iconbutton];
        }
        if (i + kFunctionItemTag == kFunctionItemTag_Camera){
            [self addLongPressToButton:iconbutton];
        }
        if (i + kFunctionItemTag == kFunctionItemTag_Video){
            [self addLongPressToButton:iconbutton];
        }
        if (i + kFunctionItemTag == kFunctionItemTag_File){
            [self addLongPressToButton:iconbutton];
        }
        if (i + kFunctionItemTag == kFunctionItemTag_Receipt){
            [self addLongPressToButton:iconbutton];
        }
        [iconbutton setImage:[UIImage imageNamed:model.imageName]forState:UIControlStateNormal];
        [iconbutton setImage:[UIImage imageNamed:model.hlImageName] forState:UIControlStateSelected];
        [iconbutton setImage:[UIImage imageNamed:model.hlImageName] forState:UIControlStateHighlighted];
        [_bgScrollview addSubview:iconbutton];
        
        CGRect nameLabelRect = CGRectMake(kNameLabelRect, kBtnSize, kBtnSize, kLabelHeight);
        CGFloat nameLabelFont = kNameLabelFont;
        UILabel *nameLabel=[[UILabel alloc]initWithFrame:nameLabelRect];
        nameLabel.text = model.functionName;
        nameLabel.backgroundColor=[UIColor clearColor];
        nameLabel.font=[UIFont systemFontOfSize:nameLabelFont];
        nameLabel.textColor=[UIColor blackColor];
        nameLabel.textAlignment=NSTextAlignmentCenter;
        [iconbutton addSubview:nameLabel];
    }
}
#pragma -mark privateMethod
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

//添加长按手势
- (void)addLongPressToButton:(UIButton *)button
{
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] init];
    switch (button.tag) {
        case kFunctionItemTag_Picture:
            [longPress addTarget:self action:@selector(processLongPress1:)];
            break;
        case kFunctionItemTag_Camera:
            [longPress addTarget:self action:@selector(processLongPress2:)];
            break;
        case kFunctionItemTag_Video:
            [longPress addTarget:self action:@selector(processLongPress3:)];
            break;
        case kFunctionItemTag_File:
            [longPress addTarget:self action:@selector(processLongPress4:)];
            break;
        case kFunctionItemTag_Receipt:
            [longPress addTarget:self action:@selector(processLongPress5:)];
            break;
        default:
            break;
    }
    
    longPress.minimumPressDuration = 1; //1s 定义按的时间
    [button addGestureRecognizer:longPress];
}
/*
 功能说明
 获取当前异常日志文件的路径
 */
- (NSString *)getCurExpLogFilePath
{
    NSString *time = [[NSDate date] my_formattedDateWithFormat:@"yyyyMMdd" locale:[NSLocale currentLocale]];
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *crashname = [NSString stringWithFormat:@"%@_%@Crashlog.log",time,infoDictionary[@"CFBundleName"]];
    NSString *crashPath = [kGetCachesPath  stringByAppendingPathComponent:kSDCrashFileDirectory];
    NSString *filepath = [crashPath stringByAppendingPathComponent:crashname];
    return filepath;
}
#pragma -mark functionBtnClicked
- (void)functionItemBtnClicked:(UIButton *)sender
{
    if(self.functionClickedCallback)
    {
        self.functionClickedCallback(sender);
    }
}
//长按第一个功能按钮 可以 发送当天的日志文件
- (void)processLongPress1:(UILongPressGestureRecognizer *)gestureRecognizer{
    if ([gestureRecognizer state] == UIGestureRecognizerStateBegan) {
        //        找到当天的日志文件
        NSDateFormatter *formatter 	= [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd"];
        NSString *dateStr=[formatter stringFromDate:[NSDate date]];
        
        NSString *logFileName = [NSString stringWithFormat:@"client%@.log",dateStr];
        
        NSString *logFilePath = [kHomeDic stringByAppendingPathComponent:logFileName];
        if(self.sendFileCallback)
        {
            self.sendFileCallback(logFilePath);
        }
    }
}
//长按第一个功能按钮 可以 发送昨天的日志文件
- (void)processLongPress2:(UILongPressGestureRecognizer *)gestureRecognizer{
    if ([gestureRecognizer state] == UIGestureRecognizerStateBegan) {
        NSDate *yesterdayDate = [NSDate dateWithTimeIntervalSince1970:kCurrentDayBefore(1)];
        
        //        找到前一天的日志文件
        NSDateFormatter *formatter 	= [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd"];
        NSString *dateStr=[formatter stringFromDate:yesterdayDate];
        
        NSString *logFileName = [NSString stringWithFormat:@"client%@.log",dateStr];
        NSString *logFilePath = [kHomeDic stringByAppendingPathComponent:logFileName];
        if(self.sendFileCallback)
        {
            self.sendFileCallback(logFilePath);
        }
    }
}
//长按第一个功能按钮 可以 发送前天的日志文件
- (void)processLongPress3:(UILongPressGestureRecognizer *)gestureRecognizer{
    if ([gestureRecognizer state] == UIGestureRecognizerStateBegan) {
        NSDate *yesterdayDate = [NSDate dateWithTimeIntervalSince1970:kCurrentDayBefore(2)];
        
        //        找到前一天的日志文件
        NSDateFormatter *formatter 	= [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd"];
        NSString *dateStr=[formatter stringFromDate:yesterdayDate];
        
        NSString *logFileName = [NSString stringWithFormat:@"client%@.log",dateStr];
        NSString *logFilePath = [kHomeDic stringByAppendingPathComponent:logFileName];
        if(self.sendFileCallback)
        {
            self.sendFileCallback(logFilePath);
        }
    }
}
//长按第一个功能按钮 可以 发送eCloud.log
- (void)processLongPress4:(UILongPressGestureRecognizer *)gestureRecognizer{
    if ([gestureRecognizer state] == UIGestureRecognizerStateBegan) {
        
        NSString *logFileName = [NSString stringWithFormat:@"eCloud.log"];
        NSString *logFilePath = [kHomeDic stringByAppendingPathComponent:logFileName];
        if(self.sendFileCallback)
        {
            self.sendFileCallback(logFilePath);
        }
    }
}
//长按第五个功能按钮 可以 发送异常日志
- (void)processLongPress5:(UILongPressGestureRecognizer *)gestureRecognizer{
    if ([gestureRecognizer state] == UIGestureRecognizerStateBegan) {
        
        NSString *logFilePath = [self getCurExpLogFilePath];
        
        if(self.sendFileCallback)
        {
            self.sendFileCallback(logFilePath);
        }
    }
}
@end
#pragma mark - 增加NSDate的分类的一个方法
@implementation NSDate(myformatter)
- (NSString *)my_formattedDateWithFormat:(NSString *)format{
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:format];
    return [formatter stringFromDate:self];
}

- (NSString *)my_formattedDateWithFormat:(NSString *)format locale:(NSLocale *)locale{
    return [self my_formattedDateWithFormat:format timeZone:[NSTimeZone systemTimeZone] locale:locale];
}

- (NSString *)my_formattedDateWithFormat:(NSString *)format timeZone:(NSTimeZone *)timeZone locale:(NSLocale *)locale{
    static NSDateFormatter *formatter = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        formatter = [[NSDateFormatter alloc] init];
    });
    
    [formatter setDateFormat:format];
    [formatter setTimeZone:timeZone];
    [formatter setLocale:locale];
    return [formatter stringFromDate:self];
}
@end
