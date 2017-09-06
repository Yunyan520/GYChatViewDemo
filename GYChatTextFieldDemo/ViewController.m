//
//  ViewController.m
//  GYChatTextFieldDemo
//
//  Created by lidianchao on 2017/8/30.
//  Copyright © 2017年 lidianchao. All rights reserved.
//

#import "ViewController.h"
#import "GYChatView.h"
#import "GYChatManager.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor greenColor];
    [self configFooterView];
    [self addTapGesture];
    // Do any additional setup after loading the view, typically from a nib.
}
- (void)configFooterView
{
    CGFloat footerHeight = 50;
    CGFloat footerY =self.view.frame.size.height - footerHeight -44;
    CGRect footerRect = CGRectMake(0, footerY, self.view.frame.size.width, footerHeight);
    GYConfigChatViewItem *item = [[GYConfigChatViewItem alloc] init];
    item.inputViewFrame = footerRect;
    item.style = TypeChat1;
    item.type2footerBtnCount = 2;
    __weak typeof(self) weakSelf = self;
    item.configViewCallback = ^(UIView *view) {
        __strong typeof(self) strongSelf = weakSelf;
        if (strongSelf) {
            [self.view addSubview:view];
        }
    };
    //初始化manager
    GYChatManager *chatManager = [GYChatManager sharedManager];
    [chatManager configChatRootView:item];
    
    chatManager.keyboardShownCallback = ^(CGSize keyboardSize) {
        NSLog(@"%f,%f",keyboardSize.width,keyboardSize.height);
    };
    chatManager.keyboradHiddenCallback = ^{
        NSLog(@"键盘收起");
    };
    chatManager.sendMessageCallback = ^(NSString *msg) {
        NSLog(@"%@", msg);
    };
    chatManager.sendFileCallback = ^(NSString *fileName) {
        NSLog(@"%@", fileName);
    };
    chatManager.functionClickedCallback = ^(UIView *functionItem) {
        //点击照片、拍照、视频等功能
        UIButton *functionBtn = (UIButton *)functionItem;
        NSLog(@"%ld", (long)functionBtn.tag);
        switch (functionBtn.tag) {
            case kFunctionItemTag_Picture:
                //do something
                break;
            case kFunctionItemTag_Camera:
                //do something
                break;
            case kFunctionItemTag_Video:
                //do something
                break;
            case kFunctionItemTag_File:
                //do something
                break;
            case kFunctionItemTag_Receipt:
                //do something
                break;
            case kFunctionItemTag_VoiceInput:
                //do something
                break;
            default:
                break;
        }
    };
    chatManager.clickedAtCallback = ^(NSString *msg) {
        NSLog(@"%@",msg);
        [[GYChatManager sharedManager] orientateAnswer:@"personName1" isLongPressed:NO];
    };
}
- (void)addTapGesture
{
    UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    [self.view addGestureRecognizer:recognizer];
    
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressAction:)];
    [self.view addGestureRecognizer:longPress];
}
- (void)tapAction:(id)sender
{
    [[GYChatManager sharedManager] keyboardIsShow:NO];
}
- (void)longPressAction:(id)sender
{
    UILongPressGestureRecognizer *gesture = (UILongPressGestureRecognizer *)sender;
    if(gesture.state == UIGestureRecognizerStateBegan)
    {
        [[GYChatManager sharedManager] orientateAnswer:@"personName" isLongPressed:YES];
    }
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
