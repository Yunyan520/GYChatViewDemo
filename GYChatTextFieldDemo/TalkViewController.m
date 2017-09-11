//
//  TalkViewController.m
//  GYChatTextFieldDemo
//
//  Created by lidianchao on 2017/9/11.
//  Copyright © 2017年 lidianchao. All rights reserved.
//

#import "TalkViewController.h"
#import "GYChatView.h"
#import "GYChatManager.h"
#import "GYVoiceInputPromptView.h"
#import "ViewController.h"
@interface TalkViewController ()<GYChatManagerDelegate>

@end

@implementation TalkViewController
{
    NSString *_draft;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor greenColor];
    [self configVoiceInputPromtUI];
    [self configFooterView];
    [self addTapGesture];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStyleDone target:self action:@selector(back)];
    self.navigationItem.leftBarButtonItem = item;
    // Do any additional setup after loading the view.
}
- (void)viewDidAppear:(BOOL)animated
{
    if(_draft)
    {
        [[GYChatManager sharedManager] addDraft:_draft];
    }
}
- (void)back
{
    NSString *draft = [[GYChatManager sharedManager] getCurrentTextViewMessage];
    NSLog(@"%@", draft);
    ViewController* vc= [self.navigationController.viewControllers objectAtIndex:self.navigationController.viewControllers.count-2];
    [vc getDraft:draft];
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)addDraft:(NSString *)draft
{
    _draft = draft;
}
- (void)configFooterView
{
    CGFloat footerHeight = 50;
    CGFloat footerY =self.view.frame.size.height - footerHeight -44;
    CGRect footerRect = CGRectMake(0, footerY, self.view.frame.size.width, footerHeight);
    GYConfigChatViewItem *item = [[GYConfigChatViewItem alloc] init];
    item.inputViewFrame = footerRect;
    item.style = TypeChat2;
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
    chatManager.delegate = self;
    [chatManager configChatRootView:item];
}
- (void)configVoiceInputPromtUI
{
    [[GYChatManager sharedManager] configVoiceInputPromtUI:self.view callback:^(UIView *view) {
        [self.view addSubview:view];
    }];
}
#pragma -mark GYChatManagerDelegate
/** 点击功能按钮回调 */
- (void)functionClicked:(UIView *)functionItem
{
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

}
/** 长按发送文件 */
- (void)longPressSendFile:(NSString *)fileName
{
    NSLog(@"%@", fileName);
}
/** 发送回调 */
- (void)sendMessage:(NSString *)msg
{
    NSLog(@"%@", msg);
}
/** 弹起键盘回调 */
- (void)keyboardShown:(CGSize)keyboardSize
{
    NSLog(@"%f,%f",keyboardSize.width,keyboardSize.height);
}
/** 点击键盘上@按钮键时回调 */
- (void)clickedAt:(NSString *)msg
{
    NSLog(@"%@",msg);
    [[GYChatManager sharedManager] orientateAnswer:@"personName1" isLongPressed:NO];
}
/** 收起键盘回调 */
- (void)keyboradHidden
{
    NSLog(@"键盘收起");
}
- (void)recordTouchUpInside:(id)sender
{
    [[GYChatManager sharedManager] InputPromptViewStatus:PromptStatus_End];
}
- (void)recordTouchUpOutside:(id)sender
{
    [[GYChatManager sharedManager] InputPromptViewStatus:PromptStatus_End];
}
- (void)recordTouchDown:(id)sender
{
    [[GYChatManager sharedManager] InputPromptViewStatus:PromptStatus_IsTalking];
}
- (void)recordTouchDragOutside:(id)sender
{
    [[GYChatManager sharedManager] InputPromptViewStatus:PromptStatus_WarnningCancle];
}
- (void)recordTouchDragIn:(id)sender
{
    [[GYChatManager sharedManager] InputPromptViewStatus:PromptStatus_IsTalking];
}

- (void)addTapGesture
{
    UIImageView *icon = [[UIImageView alloc] initWithFrame:CGRectMake(100, 300, 50, 50)];
    icon.backgroundColor = [UIColor redColor];
    icon.userInteractionEnabled = YES;
    [self.view addSubview:icon];
    
    UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    [self.view addGestureRecognizer:recognizer];
    
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressAction:)];
    [icon addGestureRecognizer:longPress];
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
