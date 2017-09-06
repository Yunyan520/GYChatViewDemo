//
//  GYChatManager.m
//  GYChatTextFieldDemo
//
//  Created by lidianchao on 2017/9/1.
//  Copyright © 2017年 lidianchao. All rights reserved.
//

#import "GYChatManager.h"
#import "GYChatView.h"
@implementation GYConfigChatViewItem
@end

static GYChatManager *instance = nil;
@implementation GYChatManager
{
    GYChatInputCustomView *_chatInputCustomView;
    UIView *_motionView;
    UIView *_picView;
}
+ (GYChatManager *)sharedManager
{
    static dispatch_once_t pred;
    dispatch_once(&pred, ^{
        instance = [[GYChatManager alloc] init];
    });
    return instance;
}
- (void)configChatRootView:(GYConfigChatViewItem *)item
{
    GYChatView *footerView=[[GYChatView alloc]initWithFrame:item];
    item.configViewCallback(footerView);
    _chatInputCustomView = [footerView getChatInputCustomView];
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
- (void)keyboardIsShow:(BOOL)isShow
{
    [_chatInputCustomView keyBoardIsShow:isShow];
}
- (void)orientateAnswer:(NSString *)personName isLongPressed:(BOOL)isLongPressed
{
    [_chatInputCustomView orientateAnswer:personName isLongPressed:isLongPressed];
}
- (void)addDraft:(NSString *)draft
{
    [_chatInputCustomView addDraft:draft];
}
@end
