//
//  GYChatInputStyle1View.h
//  GYChatTextFieldDemo
//
//  Created by lidianchao on 2017/9/5.
//  Copyright © 2017年 lidianchao. All rights reserved.
//

#import <UIKit/UIKit.h>
/**
 *创建类似微信公众号状态下输入框view
 *包含其他功能按钮
 */

@interface GYButtonItem : NSObject
@property(nonatomic, assign) NSInteger btnCount;
@property(nonatomic, strong) NSArray *btnTitles;
@end

@interface GYChatInputStyle1View : UIView
- (instancetype)initWithFrame:(CGRect)frame footeBtnItem:(GYButtonItem *)item;
//重新布局
- (void)viewWillLayoutSubviews;
@end
