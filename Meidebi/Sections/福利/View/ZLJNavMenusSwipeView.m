//
//  ZLJNavigationSwipeView.m
//  ZLJNavigationSwipeView
//
//  Created by mdb-admin on 2017/6/23.
//  Copyright © 2017年 losaic. All rights reserved.
//

#import "ZLJNavMenusSwipeView.h"

@interface ZLJNavMenusSwipeView ()
<
UIScrollViewDelegate
>
@property (nonatomic, strong) UINavigationController *currentNavController;
@property (nonatomic, strong) NSMutableArray *allViewControllers;
@property (nonatomic, strong) UIView *navigationBarView;
@property (nonatomic, strong) UIScrollView *mainScrollView;
@property (nonatomic, strong) UIView *selectionLineView;
@property (nonatomic, strong) NSMutableArray *tabButtons;
@property (nonatomic, assign) NSInteger currentTabSelected;
@property (nonatomic, strong) UIColor *tabButtonTitleColorForNormal;
@property (nonatomic, strong) UIColor *tabButtonTitleColorForSelected;

@end

@implementation ZLJNavMenusSwipeView

- (instancetype)initWithCurrentNavigationController:(UINavigationController *)nav{
    _currentNavController = nav;
    return [self initWithFrame:CGRectZero];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _currentTabSelected = 0;
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    _mainScrollView.frame = CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame));
    _mainScrollView.contentSize = CGSizeMake(CGRectGetWidth(self.frame)*[self.allViewControllers count],0);
    for (NSInteger i = 0; i < self.allViewControllers.count; i++) {
        UIViewController *vc = self.allViewControllers[i];
        vc.view.frame = CGRectMake(CGRectGetWidth(self.mainScrollView.frame)*i, 0, CGRectGetWidth(self.mainScrollView.frame), CGRectGetHeight(self.mainScrollView.frame));
    }
}

- (void)setupSubviews{
    
    NSInteger number = [self.dataSource numberOfPages:self];
    for (NSInteger i = 0; i < number; i++) {
        UIViewController *vc = [self.dataSource scrollTableViewOfPagers:self indexOfPagers:i];
        [self.allViewControllers addObject:vc];
        vc.view.frame = CGRectMake(CGRectGetWidth(self.mainScrollView.frame)*i, 0, CGRectGetWidth(self.mainScrollView.frame), CGRectGetHeight(self.mainScrollView.frame));
        [self.mainScrollView addSubview:vc.view];
        UIButton* itemButton = [UIButton buttonWithType:UIButtonTypeCustom];
        CGFloat itemButtonWidth = CGRectGetWidth(self.navigationBarView.frame)/number;
        [itemButton setFrame:CGRectMake(itemButtonWidth*i, 7, itemButtonWidth, 30)];
        [itemButton.titleLabel setBaselineAdjustment:UIBaselineAdjustmentAlignCenters];
        [itemButton.titleLabel setFont:[UIFont systemFontOfSize:16]];
        [itemButton setTitle:vc.title forState:UIControlStateNormal];
        [itemButton setTitleColor:self.tabButtonTitleColorForNormal forState:UIControlStateNormal];
        [itemButton setTitleColor:self.tabButtonTitleColorForSelected forState:UIControlStateSelected];
        [itemButton addTarget:self action:@selector(onTabButtonSelected:) forControlEvents:UIControlEventTouchUpInside];
        itemButton.tag = i;
        [self.tabButtons addObject:itemButton];
        [self.navigationBarView addSubview:itemButton];
    }
    [self.navigationBarView addSubview:self.selectionLineView];
//    [self.currentNavController.navigationItem.titleView addSubview:self.navigationBarView];
    [self selectTabWithIndex:0 animate:YES];
    
}

- (void)onTabButtonSelected:(UIButton *)button {
    [self selectTabWithIndex:button.tag animate:YES];
}

- (void)selectTabWithIndex:(NSUInteger)index animate:(BOOL)isAnimate {
    UIButton *preButton = self.tabButtons[_currentTabSelected];
    preButton.selected = NO;
    UIButton *currentButton = self.tabButtons[index];
    currentButton.selected = YES;
    _currentTabSelected = index;
    [self switchWithIndex:index animate:isAnimate];
}

- (void)switchWithIndex:(NSUInteger)index animate:(BOOL)isAnimate {
    [self.mainScrollView setContentOffset:CGPointMake(index*CGRectGetWidth(self.frame), 0) animated:isAnimate];
}

#pragma mark - UISCrolldelegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat sacle = (CGRectGetWidth(self.navigationBarView.frame)/self.allViewControllers.count)/CGRectGetWidth(self.frame);
    self.selectionLineView.frame = CGRectMake((scrollView.contentOffset.x)*sacle, self.selectionLineView.frame.origin.y, self.selectionLineView.frame.size.width, self.selectionLineView.frame.size.height);
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (scrollView == self.mainScrollView) {
        [self selectTabWithIndex:(int)scrollView.contentOffset.x/self.bounds.size.width animate:YES];
    }
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    if (scrollView == self.mainScrollView) {
        [self selectTabWithIndex:(int)scrollView.contentOffset.x/self.bounds.size.width animate:YES];
    }
}

#pragma mark - setters and getters
- (UIScrollView*)mainScrollView {
    if (!_mainScrollView) {
        _mainScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame))];
        _mainScrollView.delegate = self;
        _mainScrollView.pagingEnabled = YES;
        _mainScrollView.userInteractionEnabled = YES;
        _mainScrollView.bounces = NO;
        _mainScrollView.showsHorizontalScrollIndicator = NO;
        _mainScrollView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleWidth;
        [self addSubview:_mainScrollView];
    }
    return _mainScrollView;
}

- (UIView *)navigationBarView{
    if (!_navigationBarView) {
        _navigationBarView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.currentNavController.navigationBar.bounds.size.width-80, self.currentNavController.navigationBar.bounds.size.height)];
        _navigationBarView.backgroundColor = self.currentNavController.navigationBar.backgroundColor;
    }
    return _navigationBarView;
}

- (UIView *)selectionLineView {
    if (!_selectionLineView) {
        _selectionLineView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.navigationBarView.frame) - 2, CGRectGetWidth(self.navigationBarView.frame)/self.allViewControllers.count, 2)];
        _selectionLineView.backgroundColor = [UIColor colorWithHexString:@"#F35D00"];
    }
    return _selectionLineView;
}
- (NSMutableArray *)allViewControllers{
    if (!_allViewControllers) {
        _allViewControllers = [NSMutableArray array];
    }
    return _allViewControllers;
}

- (NSMutableArray *)tabButtons{
    if (!_tabButtons) {
        _tabButtons = [NSMutableArray array];
    }
    return _tabButtons;
}

- (UIColor *)tabButtonTitleColorForNormal {
    if (!_tabButtonTitleColorForNormal) {
        self.tabButtonTitleColorForNormal = [UIColor colorWithHexString:@"#444444"];
    }
    return _tabButtonTitleColorForNormal;
}
- (UIColor *)tabButtonTitleColorForSelected {
    if (!_tabButtonTitleColorForSelected) {
        self.tabButtonTitleColorForSelected = [UIColor colorWithHexString:@"#F35D00"];
    }
    return _tabButtonTitleColorForSelected;
}

@end
