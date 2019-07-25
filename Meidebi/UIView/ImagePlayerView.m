//
//  ImagePlayerView.m
//  Meidebi
//
//  Created by 杜非 on 15/1/7.
//  Copyright (c) 2015年 meidebi. All rights reserved.
//

#import "ImagePlayerView.h"
#import <YYKit/NSTimer+YYAdd.h>
#define kStartTag   1000
#define kDefaultScrollInterval  5

@interface ImagePlayerView() <UIScrollViewDelegate>

@property (nonatomic, assign) NSInteger count;
@property (nonatomic, strong) NSTimer *loadNewsTimer;

@end

@implementation ImagePlayerView{
    int    contTimer;

}
@synthesize scrollView=_scrollView;
@synthesize pageControl=_pageControl;
@synthesize count=_count;

- (id)initWithFrame:(CGRect)frame
{
    
    if (self) {
       self = [super initWithFrame:frame];
    }
    return self;
}

- (void)dealloc{
    [_loadNewsTimer setFireDate:[NSDate distantFuture]];
    [_loadNewsTimer invalidate];
}

- (void)setDelagateCount:(NSInteger)count delegate:(id<ImagePlayerViewDelegate>)delegate
{
    if (count == 0) return;
    if (_scrollView) {
        [_scrollView removeFromSuperview];
        [_pageControl removeFromSuperview];
        _scrollView = nil;
        _pageControl = nil;
        [_loadNewsTimer invalidate];
        _loadNewsTimer = nil;
    }
    contTimer=0;
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    
    _scrollView.translatesAutoresizingMaskIntoConstraints = NO;//自动缩放布局
    _scrollView.bounces = YES;
    _scrollView.pagingEnabled = YES;//是否翻页
    _scrollView.delegate = self;
    _scrollView.userInteractionEnabled=YES;
    _scrollView.showsHorizontalScrollIndicator = NO;//锤子方向滑动指示
  //  _scrollView.showsVerticalScrollIndicator = NO;//水平方向滑动
   // _scrollView.directionalLockEnabled = YES;//一个方向吗滚动
    [_scrollView setBackgroundColor:[UIColor clearColor]];
    [self addSubview:_scrollView];
    
    
    _pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake((self.frame.size.width-100.0)/2.0,self.frame.size.height-15,100,18)];
   // _pageControl.translatesAutoresizingMaskIntoConstraints = NO;
    [_pageControl setCurrentPageIndicatorTintColor:[UIColor colorWithRed:253.0/255.0 green:122.0/255.0 blue:15.0/255.0 alpha:0.8]];
    [_pageControl setPageIndicatorTintColor:[UIColor colorWithRed:253.0/255.0 green:253.0/255.0 blue:253.0/255.0 alpha:0.8]];
    if (count<2) {
        _pageControl.hidden = YES;
        _scrollView.scrollEnabled = NO;
    }else{
        _scrollView.scrollEnabled = YES;
        _pageControl.hidden = NO;
    }
    _pageControl.numberOfPages = count;
    _pageControl.currentPage = 0;
    [self addSubview:_pageControl];
    self.imagePlayerViewDelegate=delegate;
    _count=count;
    
    for (int i = 0;i<count;i++)
    {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.frame.size.width *(i+1), 0, self.frame.size.width, self.frame.size.height)];// 首页是第0页,默认从第1页开始的。所以+320。。。
        imageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *taps=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)];
        taps.numberOfTapsRequired=1;
        taps.numberOfTouchesRequired=1;
        [self.imagePlayerViewDelegate imagePlayerView:self loadImageForImageView:imageView index:i];
        [imageView addGestureRecognizer:taps];
        imageView.tag=kStartTag+i;
        [_scrollView addSubview:imageView];
    }
    // 取数组最后一张图片 放在第0页
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)]; // 添加最后1页在首页 循环
    [self.imagePlayerViewDelegate imagePlayerView:self loadImageForImageView:imageView index:3];
    [_scrollView addSubview:imageView];
    //[imageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)]];
    
    // 取数组第一张图片 放在最后1页
   UIImageView * imageView2 = [[UIImageView alloc] initWithFrame:CGRectMake(self.frame.size.width * (count+1) , 0, self.frame.size.width, self.frame.size.height)]; // 添加第1页在最后 循环
    
    [self.imagePlayerViewDelegate imagePlayerView:self loadImageForImageView:imageView2 index:0];
     [_scrollView addSubview:imageView2];
  //  [imageView2 addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)]];
   
    [_scrollView setContentSize:CGSizeMake(self.frame.size.width* (count + 2), self.frame.size.height)]; //  +上第1页和第4页  原理：4-[1-2-3-4]-1
    [_scrollView setContentOffset:CGPointMake(0, 0)];
    [self.scrollView scrollRectToVisible:CGRectMake(self.frame.size.width,0,self.frame.size.width,self.frame.size.height) animated:NO]; // 默认从序号1位置放第1页 ，序号0位置位置放第4页
  
    [self addTimer];
    [_loadNewsTimer setFireDate:[NSDate distantPast]];
}

- (void)addTimer {
    if (_loadNewsTimer) return;
    __weak typeof(self) weakSelf = self;
    _loadNewsTimer = [NSTimer scheduledTimerWithTimeInterval:8 block:^(NSTimer * _Nonnull timer) {
        __strong typeof(self) strongSelf = weakSelf;
        if (strongSelf) {
            [strongSelf runTimePage];
        }
    } repeats:YES];
}

// scrollview 委托函数
- (void)scrollViewDidScroll:(UIScrollView *)sender
{
    CGFloat pagewidth = self.scrollView.frame.size.width;
    int page = floor((self.scrollView.contentOffset.x - pagewidth/(_count+2))/pagewidth)+1;
    page --;  // 默认从第二页开始
    _pagei=page;
    _pageControl.currentPage = page;
}
// scrollview 委托函数
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
     contTimer=0;
    CGFloat pagewidth = self.scrollView.frame.size.width;
    int currentPage = floor((self.scrollView.contentOffset.x - pagewidth/ (_count+2)) / pagewidth) + 1;
    //    int currentPage_ = (int)self.scrollView.contentOffset.x/320; // 和上面两行效果一样
    //    NSLog(@"currentPage_==%d",currentPage_);
    if (currentPage==0)
    {
        [self.scrollView scrollRectToVisible:CGRectMake(self.frame.size.width * _count,0,self.frame.size.width,self.frame.size.height) animated:NO]; // 序号0 最后1页
    }
    else if (currentPage==_count+1)
    {
        [self.scrollView scrollRectToVisible:CGRectMake(self.frame.size.width,0,self.frame.size.width,self.frame.size.height) animated:NO]; // 最后+1,循环第1页
    }
}
// pagecontrol 选择器的方法
- (void)turnPage
{
    NSInteger page = _pageControl.currentPage; // 获取当前的page
    if (page==0) {
         [self.scrollView scrollRectToVisible:CGRectMake(self.frame.size.width*(page+1),0,self.frame.size.width,self.frame.size.height) animated:NO]; // 触摸pagecontroller那个点点 往后翻一页 +1
    }else{
         [self.scrollView scrollRectToVisible:CGRectMake(self.frame.size.width*(page+1),0,self.frame.size.width,self.frame.size.height) animated:YES]; // 触摸pagecontroller那个点点 往后翻一页 +1
    }
   
}
// 定时器 绑定的方法
- (void)runTimePage
{
//    contTimer=contTimer+1;
//    if (contTimer%kDefaultScrollInterval==0) {
//        
//    }
//    if (contTimer>10000000) {
//        contTimer=0;
//    }
    
    NSInteger page = _pageControl.currentPage; // 获取当前的page
    page++;
    page = page > _count-1 ? 0 : page ;
    _pageControl.currentPage = page;
    [self turnPage];
}
- (void)handleTapGesture:(UIGestureRecognizer *)tapGesture
{
    UIImageView *imageView = (UIImageView *)tapGesture.view;
    NSInteger index = imageView.tag - kStartTag;
    if (self.imagePlayerViewDelegate && [self.imagePlayerViewDelegate respondsToSelector:@selector(imagePlayerView:didTapAtIndex:)]) {
        if (index<_count) {
            [self.imagePlayerViewDelegate imagePlayerView:self didTapAtIndex:index];
        }else if (index==_count){
            [self.imagePlayerViewDelegate imagePlayerView:self didTapAtIndex:_count-1];
        }else if (index==_count+1){
             [self.imagePlayerViewDelegate imagePlayerView:self didTapAtIndex:0];
        }
        
    }
}


@end
