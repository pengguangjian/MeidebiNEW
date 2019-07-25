//
//  ZlJTextBannerView.m
//  Meidebi
//
//  Created by ZlJ_losaic on 2017/8/31.
//  Copyright © 2017年 meidebi. All rights reserved.
//

#import "ZlJTextBannerView.h"
#import <YYKit/YYKit.h>
static NSString * const kAnimationKey = @"3dtransitionanimation";
@interface ZlJTextBannerView ()

@property (nonatomic, strong) UIScrollView *mainScrollView;
@property (nonatomic, strong) UIButton *firstDisplayBtn;
@property (nonatomic, strong) UIButton *nextDisplayBtn;
@property (nonatomic, strong) NSArray *pages;
@property (nonatomic, strong) NSTimer *loadNewsTimer;
@property (nonatomic, assign) NSInteger currentIndex;
@end

@implementation ZlJTextBannerView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupSubviews];
        [self initParameters];
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    _mainScrollView.frame = self.bounds;
    CGRect firstBtnFrame = _firstDisplayBtn.frame;
    firstBtnFrame.size = _mainScrollView.frame.size;
    _firstDisplayBtn.frame  = firstBtnFrame;
    
//    CGRect nextBtnFrame = _nextDisplayBtn.frame;
//    nextBtnFrame.size = _mainScrollView.frame.size;
//    nextBtnFrame.origin.x = CGRectGetMaxX(_firstDisplayBtn.frame);
//    _nextDisplayBtn.frame  = nextBtnFrame;
//    _mainScrollView.contentSize = _firstDisplayBtn.frame.size;
}

- (void)initParameters{
    _currentIndex = 0;
    _fontSize = 14.f;
    _textColor = [UIColor grayColor];
}

- (void)setupSubviews{
    _mainScrollView = [[UIScrollView alloc] init];
    [self addSubview:_mainScrollView];
    
    _firstDisplayBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_mainScrollView addSubview:_firstDisplayBtn];
    _firstDisplayBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [_firstDisplayBtn addTarget:self action:@selector(respondsToItemBtnEvent:) forControlEvents:UIControlEventTouchUpInside];
    
//    _nextDisplayBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    [_mainScrollView addSubview:_nextDisplayBtn];
//    _nextDisplayBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
}

- (void)addTimer {
    if (_loadNewsTimer) return;
    __weak typeof(self) weakSelf = self;
    _loadNewsTimer = [NSTimer scheduledTimerWithTimeInterval:15 block:^(NSTimer * _Nonnull timer) {
        __strong typeof(self) strongSelf = weakSelf;
        if (strongSelf) {
             _currentIndex += 1;
            [strongSelf starAnimation];
        }
    } repeats:YES];
}

- (void)textBannerPages:(NSArray *)pages{
    if (pages.count <= 0) return;
    _pages = pages;
    [_firstDisplayBtn setTitleColor:_textColor forState:UIControlStateNormal];
    [_firstDisplayBtn setTitleColor:_textColor forState:UIControlStateHighlighted];
    _firstDisplayBtn.titleLabel.font = [UIFont systemFontOfSize:_fontSize];
    _firstDisplayBtn.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    [_firstDisplayBtn setTitle:[(HomeHotSticksViewModel *)_pages.firstObject title] forState:UIControlStateNormal];
    if (pages.count > 1) {
        [self addTimer];
    }
}

- (void)starAnimation{
    [_firstDisplayBtn setTitle:nil forState:UIControlStateNormal];
    [_firstDisplayBtn.layer removeAnimationForKey:kAnimationKey];
    CATransition * transitionAnimation = [CATransition animation];
    transitionAnimation.duration = 1;
    transitionAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transitionAnimation.type = @"cube";
    transitionAnimation.subtype = kCATransitionFromTop;
    [_firstDisplayBtn.layer addAnimation:transitionAnimation forKey:kAnimationKey];
    [_firstDisplayBtn setTitle:[(HomeHotSticksViewModel *)_pages[_currentIndex%_pages.count] title] forState:UIControlStateNormal];
}


- (void)respondsToItemBtnEvent:(UIButton *)sender{
    if ([_delegate respondsToSelector:@selector(textBnnanerViewDidSelectItem:)]) {
        [self.delegate textBnnanerViewDidSelectItem:_pages[_currentIndex%_pages.count]];
    }
}

- (void)star{
    if (_pages.count <= 1) return;
    if (_loadNewsTimer) [_loadNewsTimer setFireDate:[NSDate distantPast]];
    [self addTimer];
}

- (void)stop{
    if (_pages.count <= 1) return;
    [_loadNewsTimer setFireDate:[NSDate distantFuture]];
}

-(void)dealloc
{
    [_loadNewsTimer invalidate];
}

@end
