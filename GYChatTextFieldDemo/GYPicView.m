//
//  GYPicView.m
//  GYChatTextFieldDemo
//
//  Created by lidianchao on 2017/8/30.
//  Copyright © 2017年 lidianchao. All rights reserved.
//

#import "GYPicView.h"

#import "GYScreen.h"
@interface GYPicView()<UIScrollViewDelegate>

@end

@implementation GYPicView
{
    NSMutableArray *_functionArray;
    UIScrollView *_bgScrollview;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        [self addFunctionItem];
        [self configUI];
    }
    return self;
}
- (void)addFunctionItem
{
    _functionArray = [[GYChatViewManager sharedManager] getAllFunctionItems];
}
- (void)configUI
{
    [self configBgScrollView];
    [self configFunctionItemIcon];
}
- (void)configBgScrollView
{
    _bgScrollview = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    _bgScrollview.scrollsToTop = NO;
    _bgScrollview.pagingEnabled = YES;
    _bgScrollview.delegate = self;
    _bgScrollview.showsHorizontalScrollIndicator = NO;
    _bgScrollview.showsVerticalScrollIndicator = NO;
    _bgScrollview.backgroundColor = [UIColor colorWithRed:250.0/255 green:250.0/255 blue:250.0/255 alpha:1.0];
    [self addSubview:_bgScrollview];
}
- (void)configFunctionItemIcon
{
    for (UIView *eachView in [_bgScrollview subviews])
    {
        [eachView removeFromSuperview];
    }//清空后再添加
    
    NSUInteger sumnum = _functionArray.count;
    
    int numberOfIconEachLine = 4;
    if ( IS_IPHONE_6P) {
        numberOfIconEachLine = 5;
    }
    
    float buttonSize = 60.0;
    float labelHeight = 20.0;
    
    unsigned long page = sumnum / numberOfIconEachLine + (sumnum % numberOfIconEachLine ? 1 : 0);
    
    float paddingX = (_bgScrollview.frame.size.width - numberOfIconEachLine * buttonSize) / (numberOfIconEachLine + 1);
    float paddingY = 15;
    
    _bgScrollview.pagingEnabled = YES;
    _bgScrollview.scrollEnabled = YES;
    _bgScrollview.contentSize = CGSizeMake(_bgScrollview.frame.size.width, (paddingY + buttonSize + labelHeight) * page);
    
    for (int i = 0; i < sumnum; i++) {
        
        FunctionButtonModel *model = [_functionArray objectAtIndex:i];
        
        int row = i / numberOfIconEachLine;
        int col = i % numberOfIconEachLine;
        
        UIButton *iconbutton=[[UIButton alloc]initWithFrame:CGRectMake(paddingX + (buttonSize + paddingX) * col,paddingY + (paddingY + buttonSize + labelHeight) * row ,buttonSize,buttonSize)];
        iconbutton.backgroundColor=[UIColor clearColor];
        iconbutton.tag = model.btnTag;
        [iconbutton addTarget:self action:@selector(functionItemBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
//        if (i == 0) {
//            [LogUtil addLongPressToButton1:iconbutton];
//        }else if (i == 1){
//            [LogUtil addLongPressToButton2:iconbutton];
//        }else if (i == 2){
//            [LogUtil addLongPressToButton3:iconbutton];
//        }else if (i == 3){
//            [LogUtil addLongPressToButton4:iconbutton];
//        }else if (i == 4){
//            [LogUtil addLongPressToButton5:iconbutton];
//        }
        [iconbutton setImage:[UIImage imageNamed:model.imageName]forState:UIControlStateNormal];
        [iconbutton setImage:[UIImage imageNamed:model.hlImageName] forState:UIControlStateSelected];
        [iconbutton setImage:[UIImage imageNamed:model.hlImageName] forState:UIControlStateHighlighted];
        [_bgScrollview addSubview:iconbutton];
        
        UILabel *nameLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, buttonSize, buttonSize, labelHeight)];
        nameLabel.text = model.functionName;
        nameLabel.backgroundColor=[UIColor clearColor];
        nameLabel.font=[UIFont systemFontOfSize:12];
        nameLabel.textColor=[UIColor blackColor];
        nameLabel.textAlignment=NSTextAlignmentCenter;
        [iconbutton addSubview:nameLabel];
    }
}
#pragma -mark
- (void)functionItemBtnClicked:(UIButton *)sender
{
    if(self.functionClickedCallback)
    {
        self.functionClickedCallback(sender);
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
