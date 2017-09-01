//
//  MotionView.m
//  eCloud
//
//  Created by lidianchao on 2017/7/28.
//  Copyright © 2017年 网信. All rights reserved.
//

#import "GYMotionView.h"
@interface GYMotionView()<UIScrollViewDelegate>

@end

@implementation GYMotionView
{
    NSArray *_phraseArray;
    NSArray *_bqStrArray;
    /** 表情容器 */
    UIScrollView *_motionScrollView;
    /** 分页控制器 */
    UIPageControl *_pageControl;
    //发送按钮
    UIButton *_sendBtn;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        _bqStrArray = [[GYChatViewManager sharedManager] loadFaceArray];
        _phraseArray = [[GYChatViewManager sharedManager] prepareFaceArray];
        [self initEvent];
        [self configUI];
    }
    return self;
}
- (void)initEvent
{
    
}
- (void)configUI
{
    CGRect scrollRect = CGRectMake(0, 0, kScreenWidth, 170);
    _motionScrollView=[[UIScrollView alloc]initWithFrame:scrollRect];
    _motionScrollView.pagingEnabled = YES;
    _motionScrollView.delegate = self;
    _motionScrollView.scrollsToTop = NO;
    _motionScrollView.showsHorizontalScrollIndicator = NO;
    _motionScrollView.showsVerticalScrollIndicator = NO;
    _motionScrollView.backgroundColor = [UIColor clearColor];
    [self addSubview:_motionScrollView];
    
    CGFloat pageWidth = 100;
    CGFloat pageX = (kScreenWidth - pageWidth)/2;
    CGRect pageRect = CGRectMake(pageX, 175, pageWidth, 40);
    _pageControl = [[UIPageControl alloc] initWithFrame:pageRect];
    _pageControl.pageIndicatorTintColor = [UIColor redColor];
    _pageControl.currentPageIndicatorTintColor = [UIColor greenColor];
    [_pageControl addTarget:self action:@selector(pageTurn:) forControlEvents:UIControlEventValueChanged];
    [self updateScrollview];
    [self addSubview:_pageControl];
    
    _sendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    CGRect sendBtnRect = CGRectMake(kScreenWidth - 60, 170, 40, 40);
    _sendBtn.frame = sendBtnRect;
    [_sendBtn setTitle:@"发送" forState:UIControlStateNormal];
    _sendBtn.titleLabel.textAlignment = NSTextAlignmentRight;
    [_sendBtn setTitleColor:kUIColorFromRGB(0x028be6) forState:UIControlStateNormal];
    [_sendBtn addTarget:self action:@selector(sendVoiceMessage:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_sendBtn];
}
//表情适配
- (void)updateScrollview
{
    [self removeSubViewFromShowViewContext];
    // update 0805 by yanlei 表情的适配
    // 首先先计算一行能放置几个表情
    int rowCount = 8;   // 每行的个数
    int spacing = 10;
    
    if (IS_IPHONE) {
        if (IS_IPHONE_6P) {
            rowCount = 9;
            spacing = 15;
        }else if (IS_IPHONE_6){
            spacing = 15;
        }
    }else if (IS_IPAD){
        //        竖屏显示10个；横屏一行显示14个
        if (kScreenWidth < kScreenHeight) {
            rowCount = 10;
        }else{
            rowCount = 14;
        }
        
        spacing = (kScreenWidth - 30 * rowCount) / (rowCount + 1);
    }
    int y=0;
    int bint=(int)[_phraseArray count]; //表情总数
    int rownum=0; //根据每行显示个数 计算出 显示所有表情需要多少行
    if (bint%rowCount!=0) {
        rownum=bint/rowCount+1;
    }else {
        rownum=bint/rowCount;
    }
    int sumindex=bint;//表情总数
    
    float faceBtnWidth = (kScreenWidth - 20.0) / rowCount;
    float faceBtnHeight = 40.0;

    for (int r=0; r<rownum; r++) {
        int row=r; //行数
        int arrayindex=row*rowCount; //表情对应的下标
        y=faceBtnHeight*(r%4)+10; //表情的y值 第一行是10
        UIImageView *imgv;
        UIButton *iconBtn;
        for (int i=0; i<rowCount; i++) {
            
            if (arrayindex<sumindex) {
                CGRect imageValueRect=CGRectMake(kScreenWidth * (r/4) + 10 + faceBtnWidth * i,y, faceBtnWidth,faceBtnHeight);
                
                iconBtn=[[UIButton alloc]initWithFrame:imageValueRect];
                [iconBtn addTarget:self action:@selector(choosefacePic:)  forControlEvents:UIControlEventTouchUpInside];
                iconBtn.titleLabel.text=@"0";
                iconBtn.tag=arrayindex;
                CGRect imageValueRect1=CGRectMake((faceBtnWidth - 30) / 2, (faceBtnHeight - 30) / 2, 30, 30);
                imgv=[[UIImageView alloc]initWithFrame:imageValueRect1];
                NSMutableDictionary *tempdic = [_phraseArray objectAtIndex:arrayindex];
                
                UIImage *tempImage = [tempdic valueForKey:[NSString stringWithFormat:@"[/%@]",[_bqStrArray objectAtIndex:arrayindex]]];
                imgv.image=tempImage;
                [iconBtn addSubview:imgv];
                [_motionScrollView addSubview:iconBtn];
            }
            arrayindex++;
        }
    }
    int page=0;
    if (rownum%4!=0) {
        page=rownum/4+1;
    }else {
        page=rownum/4;
    }
    [_motionScrollView setContentSize:CGSizeMake(page * kScreenWidth, y+10)];
    _pageControl.currentPage=0;
    _pageControl.numberOfPages=page;
}
-(void)removeSubViewFromShowViewContext
{
    NSArray *viewsToRemove = [_motionScrollView subviews];
    for (UIView *v in viewsToRemove) {
        [v removeFromSuperview];
    }
}
#pragma -mark faceBtnClickedAction
- (void)choosefacePic:(id)sender
{
    if(_chooseMotionCallback)
    {
        _chooseMotionCallback((UIButton *)sender,_phraseArray,_bqStrArray);
    }
}
- (void)sendVoiceMessage:(id)sender
{
    if(self.sendMessageCallback)
    {
        self.sendMessageCallback();
    }
}
#pragma -mark pageControlTurnAction
- (void)pageTurn:(UIPageControl *)pageControl
{
    int secondPage = (int)[pageControl currentPage];
    _motionScrollView.contentOffset = CGPointMake(kScreenWidth*secondPage, 0);
}
#pragma -mark scrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{//底部上拖
    _pageControl.currentPage = scrollView.contentOffset.x/self.frame.size.width;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
