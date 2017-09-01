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
    [self configFooterView];
    // Do any additional setup after loading the view, typically from a nib.
}
- (void)configFooterView
{
    CGFloat footerY =self.view.frame.size.height - 50 -44;
    CGRect footerRect = CGRectMake(0, footerY, self.view.frame.size.width, 50);
    GYChatManager *chatManager = [GYChatManager sharedManager];
    __weak typeof(self) weakSelf = self;
    [chatManager configChatRootView:footerRect callback:^(UIView *view) {
        __strong typeof(self) strongSelf = weakSelf;
        if (strongSelf) {
            [self.view addSubview:view];
        }
    }];
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
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
