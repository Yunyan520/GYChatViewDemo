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
    NSMutableArray *_phraseArray;
    NSMutableArray *_bqStrArray;
    CGRect _scrollRect;
    CGRect _pageRect;
    CGRect _sendBtnRect;
    CGRect _lineRect;
    /** 表情容器 */
    UIScrollView *_motionScrollView;
    /** 分页控制器 */
    UIPageControl *_pageControl;
    //发送按钮
    UIButton *_sendBtn;
    UIView *_lineView;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        [self initEvent];
        [self configUI];
    }
    return self;
}
- (void)initEvent
{
    self.backgroundColor = kSelfBackgroundColor;
    _bqStrArray = [self loadFaceArray];
    _phraseArray = [self prepareFaceArray];
}
- (void)setUIFrame
{
    _scrollRect = CGRectMake(kMotionScrollViewX, kMotionScrollViewY, kScreenWidth, kMotionScrollViewHeight);
    _pageRect = CGRectMake(kPageControlX, kPageControlY, kPageControlWidth, kPageControlHeight);
    _sendBtnRect = CGRectMake(kSendBtnX, kSendBtnY, kSendBtnWidth, kSendBtnHeight);
    _lineRect = CGRectMake(kLineX, kLineX, self.frame.size.width, kLineHeight);
}
- (void)configUI
{
    [self setUIFrame];
    _motionScrollView = [[UIScrollView alloc]initWithFrame:_scrollRect];
    _motionScrollView.pagingEnabled = YES;
    _motionScrollView.delegate = self;
    _motionScrollView.scrollsToTop = NO;
    _motionScrollView.showsHorizontalScrollIndicator = NO;
    _motionScrollView.showsVerticalScrollIndicator = NO;
    _motionScrollView.backgroundColor = [UIColor clearColor];
    [self addSubview:_motionScrollView];
    
    _pageControl = [[UIPageControl alloc] initWithFrame:_pageRect];
    _pageControl.pageIndicatorTintColor = kPageIndicatorTintColor;
    _pageControl.currentPageIndicatorTintColor = kCurrentPageIndicatorTintColor;
    [_pageControl addTarget:self action:@selector(pageTurn:) forControlEvents:UIControlEventValueChanged];
    [self updateScrollview];
    [self addSubview:_pageControl];
    
    _sendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _sendBtn.frame = _sendBtnRect;
    [_sendBtn setTitle:@"发送" forState:UIControlStateNormal];
    _sendBtn.titleLabel.textAlignment = NSTextAlignmentRight;
    [_sendBtn setTitleColor:kSendBtnTitleColorCount forState:UIControlStateNormal];
    [_sendBtn addTarget:self action:@selector(sendVoiceMessage:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_sendBtn];
    
    _lineView = [[UIView alloc] initWithFrame:_lineRect];
    _lineView.backgroundColor = [UIColor grayColor];
    [self addSubview:_lineView];
}
#pragma -mark privateMethod
- (NSInteger)getRowCount
{
    int rowCount = kRowCount;   // 每行的个数
    if (IS_IPHONE_6P) {
        rowCount = kIS_IPHONE_6PRowCount;
    }
    if (IS_IPAD){
        //        竖屏显示10个；横屏一行显示14个
        if (kScreenWidth < kScreenHeight) {
            rowCount = kiPadVertical;
        }else{
            rowCount = kiPadHorizontal;
        }
    }
    return rowCount;
}
- (NSInteger)getRowNum:(NSInteger)bint
{
    NSInteger rowCount = [self getRowCount];
    NSInteger rownum = 0; //根据每行显示个数 计算出 显示所有表情需要多少行
    if (bint % rowCount != 0) {
        rownum = bint / rowCount+1;
    }else {
        rownum = bint / rowCount;
    }
    return rownum;
}
//表情适配
- (void)updateScrollview
{
    [self removeSubViewFromShowViewContext];
    // update 0805 by yanlei 表情的适配
    NSInteger bint = (NSInteger)[_phraseArray count]; //表情总数
    // 首先先计算一行能放置几个表情
    NSInteger rownum = [self getRowNum:bint];
    NSInteger rowCount = [self getRowCount];
    CGFloat y = 0.0;
    for (NSInteger r = 0; r < rownum; r++) {
        NSInteger row = r; //行数
        NSInteger arrayindex = row * rowCount; //表情对应的下标
        y = kFaceBtnHeight * (r % 4) + kFirstRowFaceBtnY; //表情的y值 第一行是10
        UIImageView *imgv;
        UIButton *iconBtn;
        for (int i = 0; i < rowCount; i++) {
            if (arrayindex < bint) {
                CGRect imageValueRect = CGRectMake(kScreenWidth * (r/4) + kFirstRowFaceBtnY + kFaceBtnWidth * i,y, kFaceBtnWidth,kFaceBtnHeight);
                
                iconBtn = [[UIButton alloc]initWithFrame:imageValueRect];
                [iconBtn addTarget:self action:@selector(choosefacePic:)  forControlEvents:UIControlEventTouchUpInside];
                iconBtn.titleLabel.text = @"0";
                iconBtn.tag = arrayindex;
                CGRect imageValueRect1 = CGRectMake((kFaceBtnWidth - 30) / 2, (kFaceBtnHeight - 30) / 2, 30, 30);
                imgv = [[UIImageView alloc]initWithFrame:imageValueRect1];
                NSMutableDictionary *tempdic = [_phraseArray objectAtIndex:arrayindex];
                
                UIImage *tempImage = [tempdic valueForKey:[NSString stringWithFormat:@"[/%@]",[_bqStrArray objectAtIndex:arrayindex]]];
                imgv.image = tempImage;
                [iconBtn addSubview:imgv];
                [_motionScrollView addSubview:iconBtn];
            }
            arrayindex++;
        }
    }
    NSInteger page = 0;
    if (rownum % 4 != 0) {
        page = rownum / 4 + 1;
    }else {
        page = rownum / 4;
    }
    [_motionScrollView setContentSize:CGSizeMake(page * kScreenWidth, y+10)];
    _pageControl.currentPage = 0;
    _pageControl.numberOfPages = page;
}
-(void)removeSubViewFromShowViewContext
{
    NSArray *viewsToRemove = [_motionScrollView subviews];
    for (UIView *v in viewsToRemove) {
        [v removeFromSuperview];
    }
}
//准备表情数组
- (NSMutableArray *)prepareFaceArray{
    //聊天表情相关
    NSMutableArray *temp = [[NSMutableArray alloc] init];
    NSString *faceName = @"";
    for (int i = 0; i < [_bqStrArray count]; i++){
        faceName = [NSString stringWithFormat:@"%@_%@", @"face",[_bqStrArray objectAtIndex:i]];
        NSString *path = [[NSBundle mainBundle] pathForResource:faceName ofType:@"png"];
        UIImage *face = [UIImage imageWithContentsOfFile:path];
        NSMutableDictionary *dicFace = [NSMutableDictionary dictionary];
        [dicFace setValue:face forKey:[NSString stringWithFormat:@"[/%@]",[_bqStrArray objectAtIndex:i]]];
        [temp addObject:dicFace];
        _phraseArray = temp;
    }
    return _phraseArray;
}
#pragma mark - 初始化表情集合
- (NSMutableArray *)loadFaceArray
{
    if (_bqStrArray != nil && _bqStrArray.count != 0) {
        return _bqStrArray;
    }
    // 加载表情数据
    _bqStrArray = faceAfterName;
    NSInteger rowCount = [self getRowCount];   // 一行显示的表情个数
    NSInteger pageCount = _bqStrArray.count/(rowCount * 4); // 表情的总的页数
    // 为表情的每一页的最后添加一个删除表情
    for (NSInteger i = 0; i < pageCount+1; i++)
    {
        NSInteger scIndex = 4*rowCount*(i+1)-1;
        if(i == 0)
        {
            scIndex = (4*rowCount-1)*(i+1);
        }
        if (i == pageCount)
        {
            // 0911 最后一页不显示删除按钮
            break;
        }
        [_bqStrArray insertObject:@"sc" atIndex:scIndex];
    }
    return _bqStrArray;
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
- (void)viewWillLayoutSubviews
{
    [self setUIFrame];
    _motionScrollView.frame = _scrollRect;
    _pageControl.frame = _pageRect;
    _sendBtn.frame = _sendBtnRect;
    _lineView.frame = _lineRect;
    [self updateScrollview];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
