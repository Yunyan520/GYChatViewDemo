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

@implementation GYFunctionButtonModel



@end

@implementation GYPicView
{
    NSMutableArray *_functionArray;
    UIScrollView *_bgScrollview;
    UIView *_lineView;
    CGRect _lineRect;
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
    [self setUIFrame];
    [self configBgScrollView];
    [self configFunctionItemIcon];
}
- (void)setUIFrame
{
    _lineRect = CGRectMake(kLineX, kLineX, self.frame.size.width, kLineHeight);
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
    
    _lineView = [[UIView alloc] initWithFrame:_lineRect];
    _lineView.backgroundColor = [UIColor grayColor];
    [self addSubview:_lineView];
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
    unsigned long page = sumnum / numberOfIconEachLine + (sumnum % numberOfIconEachLine ? 1 : 0);
    
    float paddingX = (_bgScrollview.frame.size.width - numberOfIconEachLine * kBtnSize) / (numberOfIconEachLine + 1);
    _bgScrollview.pagingEnabled = YES;
    _bgScrollview.scrollEnabled = YES;
    _bgScrollview.contentSize = CGSizeMake(_bgScrollview.frame.size.width, (kPaddingY + kBtnSize + kLabelHeight) * page);
    
    for (int i = 0; i < sumnum; i++) {
        
        GYFunctionButtonModel *model = [_functionArray objectAtIndex:i];
        
        int row = i / numberOfIconEachLine;
        int col = i % numberOfIconEachLine;
        
        UIButton *iconbutton=[[UIButton alloc]initWithFrame:CGRectMake(paddingX + (kBtnSize + paddingX) * col,kPaddingY + (kPaddingY + kBtnSize + kLabelHeight) * row ,kBtnSize,kBtnSize)];
        iconbutton.backgroundColor=[UIColor clearColor];
        iconbutton.tag = model.btnTag;
        [iconbutton addTarget:self action:@selector(functionItemBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        if (i + kFunctionItemBaseTag == kFunctionItemTag_Picture) {
            [self addLongPressToButton:iconbutton];
        }
        if (i + kFunctionItemBaseTag == kFunctionItemTag_Camera){
            [self addLongPressToButton:iconbutton];
        }
        if (i + kFunctionItemBaseTag == kFunctionItemTag_Video){
            [self addLongPressToButton:iconbutton];
        }
        if (i + kFunctionItemBaseTag == kFunctionItemTag_File){
            [self addLongPressToButton:iconbutton];
        }
        if (i + kFunctionItemBaseTag == kFunctionItemTag_Receipt){
            [self addLongPressToButton:iconbutton];
        }
        [iconbutton setImage:[UIImage imageNamed:model.imageName]forState:UIControlStateNormal];
        [iconbutton setImage:[UIImage imageNamed:model.hlImageName] forState:UIControlStateSelected];
        [iconbutton setImage:[UIImage imageNamed:model.hlImageName] forState:UIControlStateHighlighted];
        [_bgScrollview addSubview:iconbutton];
        
        CGRect nameLabelRect = CGRectMake(kNameLabelRect, kBtnSize, kBtnSize, kLabelHeight);
        CGFloat nameLabelFont = kNameLabelFont;
        UILabel *nameLabel = [[UILabel alloc]initWithFrame:nameLabelRect];
        nameLabel.tag = kFunctionItemBaseTitleTag + i;
        nameLabel.text = model.functionName;
        nameLabel.backgroundColor = [UIColor clearColor];
        nameLabel.font = [UIFont systemFontOfSize:nameLabelFont];
        nameLabel.textColor = [UIColor blackColor];
        nameLabel.textAlignment = NSTextAlignmentCenter;
        [iconbutton addSubview:nameLabel];
    }
}
#pragma -mark privateMethod
- (NSMutableArray *)getAllFunctionItems
{
    NSMutableArray *functionArray = [[NSMutableArray alloc]init];
    for (NSInteger i = 0; i < kFunction_NameArr.count; i++) {
        GYFunctionButtonModel *button = [[GYFunctionButtonModel alloc]init];
        button.functionName = kFunction_NameArr[i];
        button.imageName = kFunction_NormalImageArr[i];
        button.hlImageName = kFunction_HlImageArr[i];
        button.btnTag = kFunctionItemBaseTag + i;
        [functionArray addObject:button];
    }
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
    
    longPress.minimumPressDuration = kMinimumPressDuration; //1s 定义按的时间
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
- (void)viewWillLayoutSubviews
{
    [self setUIFrame];
    _lineView.frame = _lineRect;
    _bgScrollview.frame = CGRectMake(kBgScrollViewX, kBgScrollViewY, self.frame.size.width, self.frame.size.height);
    NSUInteger sumnum = _functionArray.count;
    int numberOfIconEachLine = kNumberOfIconEachLine;
    if ( IS_IPHONE_6P) {
        numberOfIconEachLine = kNumberOfIconEachLine_6p;
    }
    unsigned long page = sumnum / numberOfIconEachLine + (sumnum % numberOfIconEachLine ? 1 : 0);
    float paddingX = (_bgScrollview.frame.size.width - numberOfIconEachLine * kBtnSize) / (numberOfIconEachLine + 1);
    _bgScrollview.contentSize = CGSizeMake(_bgScrollview.frame.size.width, (kPaddingY + kBtnSize + kLabelHeight) * page);
    
    for (int i = 0; i < sumnum; i++) {
        int row = i / numberOfIconEachLine;
        int col = i % numberOfIconEachLine;
        UIButton *iconBtn = (UIButton *)[self viewWithTag:kFunctionItemBaseTag + i];
        iconBtn.frame = CGRectMake(paddingX + (kBtnSize + paddingX) * col,kPaddingY + (kPaddingY + kBtnSize + kLabelHeight) * row ,kBtnSize,kBtnSize);
        UILabel *titleLabel = (UILabel *)[self viewWithTag:kFunctionItemBaseTitleTag + i];
        titleLabel.frame = CGRectMake(kNameLabelRect, kBtnSize, kBtnSize, kLabelHeight);
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
