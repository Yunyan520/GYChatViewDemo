//
//  GYChatManager.m
//  GYChatTextFieldDemo
//
//  Created by lidianchao on 2017/9/1.
//  Copyright © 2017年 lidianchao. All rights reserved.
//

#import "GYChatManager.h"

static GYChatManager *instance = nil;
@implementation GYChatManager

+ (GYChatManager *)sharedManager
{
    static dispatch_once_t pred;
    dispatch_once(&pred, ^{
        instance = [[GYChatManager alloc] init];
    });
    return instance;
}
- (void)configChatRootView:(CGRect)viewFrame callback:(ConfigViewCallback)callback
{
    GYChatView *footerView=[[GYChatView alloc]initWithFrame:viewFrame];
    callback(footerView);
}
- (void)configMotionView:(CGRect)inputViewFrame callback:(ConfigViewCallback)callback
{
    CGFloat motionViewHeight = 205;
    CGRect motionRect =  CGRectMake(0, inputViewFrame.size.height, inputViewFrame.size.width, motionViewHeight);
    GYMotionView *motionView = [[GYMotionView alloc] initWithFrame:motionRect];
    callback(motionView);
}

- (void)configPicView:(CGRect)inputViewFrame callback:(ConfigViewCallback)callback
{
    CGFloat picViewHeight = 205;
    CGRect picRect =  CGRectMake(0, inputViewFrame.size.height, inputViewFrame.size.width, picViewHeight);
    GYPicView *picView = [[GYPicView alloc] initWithFrame:picRect];
    __weak typeof(self) weakSelf = self;
    picView.functionClickedCallback = ^(UIView *functionItem) {
        __strong typeof(self) strongSelf = weakSelf;
        if (!strongSelf) {
            return;
        }
        if(strongSelf.functionClickedCallback)
        {
            strongSelf.functionClickedCallback(functionItem);
        }
    };
    picView.sendFileCallback = ^(NSString *fileName) {
        __strong typeof(self) strongSelf = weakSelf;
        if (!strongSelf) {
            return;
        }
        if(strongSelf.sendFileCallback)
        {
            strongSelf.sendFileCallback(fileName);
        }
    };
    callback(picView);
}
@end
