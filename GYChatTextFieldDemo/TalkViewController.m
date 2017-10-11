//
//  TalkViewController.m
//  GYChatTextFieldDemo
//
//  Created by lidianchao on 2017/9/11.
//  Copyright © 2017年 lidianchao. All rights reserved.
//

#import "TalkViewController.h"
#import "GYChatManager.h"
#import "ViewController.h"
@interface TalkViewController ()<GYChatManagerDelegate>

@end

@implementation TalkViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self configFooterView];
    [self addTapGesture];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStyleDone target:self action:@selector(back)];
    self.navigationItem.leftBarButtonItem = item;
    // Do any additional setup after loading the view.
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    NSString *draft = [GYChatManager sharedManager].draft;
    if(!([draft isEqualToString:@""] || draft == nil))
    {
        [[GYChatManager sharedManager] addDraft:draft];
    }
}
- (void)viewWillLayoutSubviews
{
    [[GYChatManager sharedManager] viewWillLayoutSubviews];
}
- (void)back
{
    NSString *draft = [[GYChatManager sharedManager] getCurrentTextViewMessage];
    [[GYChatManager sharedManager] setDraft:draft];
    NSLog(@"%@", draft);
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)configFooterView
{
    CGRect footerRect = kScreenRect;
    GYConfigChatViewItem *item = [[GYConfigChatViewItem alloc] init];
    item.inputViewFrame = footerRect;
    item.style = TypeChat1;
    item.type2footerBtnCount = 2;
    WS(ws);
    item.configViewCallback = ^(UIView *view) {
        __strong typeof(self) strongSelf = ws;
        if (strongSelf) {
            [self.view addSubview:view];
        }
    };
    //初始化manager
    GYChatManager *chatManager = [GYChatManager sharedManager];
    chatManager.delegate = self;
    [chatManager configChatRootView:item];
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
    [[GYChatManager sharedManager] atSomeone:@"personName1" isLongPressed:NO];
}
/** 收起键盘回调 */
- (void)keyboradHidden
{
    NSLog(@"键盘收起");
}
- (void)recordTouchUpInside:(id)sender
{
    
}
- (void)recordTouchUpOutside:(id)sender
{
    
}
- (void)recordTouchDown:(id)sender
{
    
}
- (void)recordTouchDragOutside:(id)sender
{
    
}
- (void)recordTouchDragIn:(id)sender
{
    
}

- (void)addTapGesture
{
    UIImageView *icon = [[UIImageView alloc] initWithFrame:CGRectMake(100, 100, 50, 50)];
    icon.backgroundColor = [UIColor redColor];
    icon.userInteractionEnabled = YES;
    [self.view addSubview:icon];
    
    UILongPressGestureRecognizer *longPress1 = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressAction1:)];
    [icon addGestureRecognizer:longPress1];
    
    UILabel *messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, 200, 200, 30)];
    messageLabel.backgroundColor = [UIColor greenColor];
    messageLabel.text = @"长按回复消息";
    messageLabel.userInteractionEnabled = YES;
    [self.view addSubview:messageLabel];
    
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressAction:)];
    [messageLabel addGestureRecognizer:longPress];
    
    UIButton *changeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    changeBtn.frame = CGRectMake(100, 170, 200, 30);
    changeBtn.backgroundColor = [UIColor yellowColor];
    [changeBtn addTarget:self action:@selector(changeAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:changeBtn];
}
- (void)changeAction
{
//    [[GYChatManager sharedManager] changeChatStyle:TypeChat2];
}
- (void)longPressAction:(id)sender
{
    UILongPressGestureRecognizer *gesture = (UILongPressGestureRecognizer *)sender;
    if(gesture.state == UIGestureRecognizerStateBegan)
    {
        [[GYChatManager sharedManager] orientateAnswer:@"定向回复" userName:@"username"];
    }
}
- (void)longPressAction1:(id)sender
{
    UILongPressGestureRecognizer *gesture = (UILongPressGestureRecognizer *)sender;
    if(gesture.state == UIGestureRecognizerStateBegan)
    {
        [[GYChatManager sharedManager] atSomeone:@"personName" isLongPressed:YES];
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
