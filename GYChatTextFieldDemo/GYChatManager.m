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
    GYVoiceInputPromptView *_promt;
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
- (void)configVoiceInputPromtUI:(UIView *)superView callback:(ConfigViewCallback)callback
{
    _promt = [[GYVoiceInputPromptView alloc] initWithFrame:superView.frame];
    callback(_promt);
}
- (void)InputPromptViewStatus:(PromptStatus)status
{
    [_promt InputPromptViewStatus:status];
}
- (void)configMotionView:(CGRect)inputViewFrame callback:(ConfigViewCallback)callback
{
    CGRect motionRect =  CGRectMake(kMotionViewX, inputViewFrame.size.height, inputViewFrame.size.width, kMotionViewHeight);
    GYMotionView *motionView = [[GYMotionView alloc] initWithFrame:motionRect];
    callback(motionView);
}

- (void)configPicView:(CGRect)inputViewFrame callback:(ConfigViewCallback)callback
{
    CGRect picRect =  CGRectMake(kPicViewX, inputViewFrame.size.height, inputViewFrame.size.width, kPicViewHeight);
    GYPicView *picView = [[GYPicView alloc] initWithFrame:picRect];
    __weak typeof(self) weakSelf = self;
    picView.functionClickedCallback = ^(UIView *functionItem) {
        __strong typeof(self) strongSelf = weakSelf;
        if (!strongSelf) {
            return;
        }
        if([strongSelf.delegate respondsToSelector:@selector(functionClicked:)])
        {
            [strongSelf.delegate functionClicked:functionItem];
        }
    };
    picView.sendFileCallback = ^(NSString *fileName) {
        __strong typeof(self) strongSelf = weakSelf;
        if (!strongSelf) {
            return;
        }
        if([strongSelf.delegate respondsToSelector:@selector(longPressSendFile:)])
        {
            [strongSelf.delegate longPressSendFile:fileName];
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
- (NSString *)getCurrentTextViewMessage
{
    NSString *currentMsg = @"";
    currentMsg = [_chatInputCustomView getCurrentTextViewMessage];
    return currentMsg;
}
- (void)addDraft:(NSString *)draft
{
    [_chatInputCustomView addDraft:draft];
}
@end
