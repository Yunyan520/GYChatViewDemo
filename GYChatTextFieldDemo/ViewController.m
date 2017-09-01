//
//  ViewController.m
//  GYChatTextFieldDemo
//
//  Created by lidianchao on 2017/8/30.
//  Copyright © 2017年 lidianchao. All rights reserved.
//

#import "ViewController.h"
#import "GYChatView.h"
#import "GYChatViewManager.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    CGFloat footerY =self.view.frame.size.height - 50 -44;
    GYChatView *footerView=[[GYChatView alloc]initWithFrame:CGRectMake(0, footerY, self.view.frame.size.width, 50)];
    footerView.sendMessageCallback = ^(NSString *msg) {
        NSLog(@"%@", msg);
    };
    footerView.functionClickedCallback = ^(UIView *functionItem) {
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
    footerView.sendFileCallback = ^(NSString *fileName) {
        NSLog(@"%@", fileName);
    };
    [self.view addSubview:footerView];
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
