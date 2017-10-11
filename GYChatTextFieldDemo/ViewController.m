//
//  ViewController.m
//  GYChatTextFieldDemo
//
//  Created by lidianchao on 2017/8/30.
//  Copyright © 2017年 lidianchao. All rights reserved.
//

#import "ViewController.h"
#import "TalkViewController.h"
#import "GYChatManager.h"
@interface ViewController ()

@end

@implementation ViewController
{
    UILabel *_draftLabel;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(100, 100, 200, 50);
    btn.backgroundColor = [UIColor blueColor];
    [btn setTitle:@"按钮测试" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(btnAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    _draftLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, 200, 200, 50)];
    _draftLabel.backgroundColor = [UIColor grayColor];
    [self.view addSubview:_draftLabel];
    // Do any additional setup after loading the view, typically from a nib.
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    _draftLabel.text = [GYChatManager sharedManager].draft;
}
- (void)btnAction
{
    TalkViewController *vc = [[TalkViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
