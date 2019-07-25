//
//  NJScrollTableView.m
//  Meidebi
//
//  Created by mdb-admin on 16/5/30.
//  Copyright © 2016年 meidebi. All rights reserved.
//

#import "NJScrollTableView.h"
#import "ReminderButton.h"
@interface NJScrollTableScrollView : UIScrollView

@end

@implementation NJScrollTableScrollView

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    @try
    {
        [self.nextResponder touchesBegan:touches withEvent:event];
    }
    @finally
    {
        
    }
}

@end

@interface NJScrollTableView()
<
    UIScrollViewDelegate
>
@property (nonatomic, strong) NJScrollTableScrollView* bodyScrollView;
@property (nonatomic, strong) NSMutableArray* viewsArray;

@property (nonatomic, assign) NSUInteger continueDraggingNumber;
@property (nonatomic, assign) CGFloat startOffsetX;
@property (nonatomic, assign) NSUInteger currentTabSelected;


@property (nonatomic, assign) BOOL isUseDragging; //是否使用手拖动的，自动的就设置为NO
@property (nonatomic, assign) BOOL isEndDecelerating;

@property (nonatomic, strong) UIView* tabView;
@property (nonatomic, strong) UIView* tabSelectedLine;
@property (nonatomic, strong) NSMutableArray* tabButtons;
@property (nonatomic, strong) NSMutableArray* tabRedDots; //按钮上的红点
@property (nonatomic, strong) UIView* selectedLine;
@property (nonatomic, assign) CGFloat selectedLineOffsetXBeforeMoving;
@end

@implementation NJScrollTableView

- (void)buildUI {
    _isBuildUI = NO;
    _isUseDragging = NO;
    _isEndDecelerating = YES;
    _startOffsetX = 0;
    _continueDraggingNumber = 0;
    NSUInteger number = [self.dataSource numberOfPagers:self];
    for (int i = 0; i < number; i++) {
        //ScrollView部分
        UIViewController* vc = [self.dataSource scrollTableViewOfPagers:self indexOfPagers:i];
        [self.viewsArray addObject:vc];
        [self.bodyScrollView addSubview:vc.view];
        
         vc.view.frame = CGRectMake(CGRectGetWidth(self.bodyScrollView.frame) * i, self.tabFrameHeight, CGRectGetWidth(self.bodyScrollView.frame), CGRectGetHeight(self.frame)-self.tabFrameHeight);

        //tab上按钮
        ReminderButton* itemButton = [ReminderButton buttonWithType:UIButtonTypeCustom];
        CGFloat itemButtonWidth = (CGRectGetWidth(self.frame))/number;
        [itemButton setFrame:CGRectMake(itemButtonWidth*i, 0, itemButtonWidth, self.tabFrameHeight)];
        [itemButton.titleLabel setBaselineAdjustment:UIBaselineAdjustmentAlignCenters];
        [itemButton.titleLabel setFont:[UIFont systemFontOfSize:self.tabButtonFontSize]];
        [itemButton setTitle:vc.title forState:UIControlStateNormal];
        [itemButton setTitleColor:self.tabButtonTitleColorForNormal forState:UIControlStateNormal];
        [itemButton setTitleColor:self.tabButtonTitleColorForSelected forState:UIControlStateSelected];
        [itemButton addTarget:self action:@selector(onTabButtonSelected:) forControlEvents:UIControlEventTouchUpInside];
        itemButton.tag = i;
        [self.tabButtons addObject:itemButton];
        [self.tabView addSubview:itemButton];
    }
     self.bodyScrollView.contentSize = CGSizeMake(CGRectGetWidth(self.frame) * [self.viewsArray count], self.tabFrameHeight);
    //tabView
    [self.tabView setBackgroundColor:self.tabBackgroundColor];
    _isBuildUI = YES;
    [self setNeedsLayout];
}
- (CGSize)buttonTitleRealSize:(UIButton *)button {
    CGSize size = CGSizeZero;
    size = [button.titleLabel.text sizeWithAttributes:@{NSFontAttributeName: button.titleLabel.font}];
    return size;
}
- (void)layoutSubviews {
//    if (_isBuildUI) {
//        for (int i = 0; i < [self.viewsArray count]; i++) {
//            UITableViewController* vc = self.viewsArray[i];
//            vc.view.frame = CGRectMake(CGRectGetWidth(self.bodyScrollView.frame) * i, self.tabFrameHeight, CGRectGetWidth(self.bodyScrollView.frame), CGRectGetHeight(self.frame)-self.tabFrameHeight);
//        }
//    }
}

- (void)updateUI{
    
}

- (void)showRemindView:(BOOL)isShow{
    ReminderButton *btn = self.tabButtons.lastObject;
    if (btn.selected == NO) {
        [btn showReminder:isShow];
    }
}
#pragma mark - Tab
- (void)onTabButtonSelected:(UIButton *)button {
    [self selectTabWithIndex:button.tag animate:YES];
}
- (void)selectTabWithIndex:(NSUInteger)index animate:(BOOL)isAnimate {
    if (self.tabButtons.count <= 0) return;
    ReminderButton *preButton = self.tabButtons[self.currentTabSelected];
    preButton.selected = NO;
    [preButton showReminder:NO];
    
    ReminderButton *currentButton = self.tabButtons[index];
    
    if(currentButton==nil)return;
    
    currentButton.selected = YES;
    [currentButton showReminder:NO];

    _currentTabSelected = index;
    
    void(^moveSelectedLine)(void) = ^(void) {
        self.selectedLine.center = CGPointMake(currentButton.center.x, self.selectedLine.center.y);
        self.selectedLineOffsetXBeforeMoving = self.selectedLine.frame.origin.x;
        //        self.selectedLineWidth = [self buttonTitleRealSize:currentButton].width;
    };
    //移动select line
    if (isAnimate) {
        [UIView animateWithDuration:0.3 animations:^{
            moveSelectedLine();
        }];
    } else {
        moveSelectedLine();
    }
    [self switchWithIndex:index animate:isAnimate];
    if ([self.dataSource respondsToSelector:@selector(whenSelectOnPager:)]) {
        [self.dataSource whenSelectOnPager:index];
    }
}

/*!
 * @brief Selected Line跟随移动
 */
- (void)moveSelectedLineByScrollWithOffsetX:(CGFloat)offsetX {
    CGFloat textGap = (CGRectGetWidth(self.frame) - CGRectGetWidth(self.selectedLine.frame) * self.tabButtons.count) / (self.tabButtons.count * 2);
    CGFloat speed = 50;
    //移动的距离
    CGFloat movedFloat = self.selectedLineOffsetXBeforeMoving + (offsetX * (textGap + CGRectGetWidth(self.selectedLine.frame) + speed)) / [UIScreen mainScreen].bounds.size.width;
    //最大右移值
    CGFloat selectedLineRightBarrier = _selectedLineOffsetXBeforeMoving + textGap * 2 + CGRectGetWidth(self.selectedLine.frame);
    //最大左移值
    CGFloat selectedLineLeftBarrier = _selectedLineOffsetXBeforeMoving - textGap * 2 - CGRectGetWidth(self.selectedLine.frame);
    CGFloat selectedLineNewX = 0;
    
    //连续拖动时的处理
    BOOL isContinueDragging = NO;
    if (_continueDraggingNumber > 1) {
        isContinueDragging = YES;
    }
    
    if (movedFloat > selectedLineRightBarrier && !isContinueDragging) {
        //右慢拖动设置拦截
        selectedLineNewX = selectedLineRightBarrier;
    } else if (movedFloat < selectedLineLeftBarrier && !isContinueDragging) {
        //左慢拖动设置的拦截
        selectedLineNewX = selectedLineLeftBarrier;
    } else {
        //连续拖动可能超过总长的情况需要拦截
        if (isContinueDragging) {
            if (movedFloat > CGRectGetWidth(self.frame) - (self.tabMargin + textGap + CGRectGetWidth(self.selectedLine.frame))) {
                selectedLineNewX = CGRectGetWidth(self.frame) - (self.tabMargin + textGap + CGRectGetWidth(self.selectedLine.frame));
            } else if (movedFloat < self.tabMargin + textGap) {
                selectedLineNewX = self.tabMargin + textGap;
            } else {
                selectedLineNewX = movedFloat;
            }
        } else {
            //无拦截移动
            selectedLineNewX = movedFloat;
        }
    }
    [self.selectedLine setFrame:CGRectMake(selectedLineNewX, self.selectedLine.frame.origin.y, self.selectedLine.frame.size.width, self.selectedLine.frame.size.height)];
    
}

#pragma mark - BodyScrollView
- (void)switchWithIndex:(NSUInteger)index animate:(BOOL)isAnimate {
    if (isAnimate) {
        [self.bodyScrollView setContentOffset:CGPointMake(index*CGRectGetWidth(self.frame), 0) animated:isAnimate];
    }else{
        self.bodyScrollView.contentOffset = CGPointMake(index*CGRectGetWidth(self.frame), 0);
    }
    _isUseDragging = NO;
}

#pragma mark - ScrollView Delegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    if (scrollView == self.bodyScrollView) {
        _continueDraggingNumber += 1;
        if (_isEndDecelerating) {
            _startOffsetX = scrollView.contentOffset.x;
        }
        _isUseDragging = YES;
        _isEndDecelerating = NO;
    }
}
/*!
 * @brief 对拖动过程中的处理
 */
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == self.bodyScrollView) {
        CGFloat movingOffsetX = scrollView.contentOffset.x - _startOffsetX;
        if (_isUseDragging) {
            //tab处理事件待完成
            [self moveSelectedLineByScrollWithOffsetX:movingOffsetX];
        }
    }
}
/*!
 * @brief 手释放后pager归位后的处理
 */
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (scrollView == self.bodyScrollView) {
        [self selectTabWithIndex:(int)scrollView.contentOffset.x/self.bounds.size.width animate:YES];
        _isUseDragging = YES;
        _isEndDecelerating = YES;
        _continueDraggingNumber = 0;
    }
}
/*!
 * @brief 自动停止
 */
//- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
//    if (scrollView == self.bodyScrollView) {
//        //tab处理事件待完成
//        [self selectTabWithIndex:(int)scrollView.contentOffset.x/self.bounds.size.width animate:YES];
//    }
//}



#pragma mark - Setter/Getter
/*!
 * @brief 头部tab
 */
- (UIView *)tabView {
    if (!_tabView) {
        self.tabView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame), _tabFrameHeight)];
        [self addSubview:_tabView];
        
        UIView *vies=[[UIView alloc]init];
        [vies setBackgroundColor:[UIColor colorWithRed:239.0/255.0 green:239.0/255.0 blue:239.0/255.0 alpha:1.0]];
        [self.tabView addSubview:vies];
        [vies mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(self.tabView);
            make.height.offset(1);
        }];
        
    }
    return _tabView;
}
- (NSMutableArray *)tabButtons {
    if (!_tabButtons) {
        self.tabButtons = [[NSMutableArray alloc] init];
    }
    return _tabButtons;
}
- (NSMutableArray *)tabRedDots {
    if (!_tabRedDots) {
        self.tabRedDots = [[NSMutableArray alloc] init];
    }
    return _tabRedDots;
}
- (CGFloat)tabFrameHeight {
    if (!_tabFrameHeight) {
        self.tabFrameHeight = 50;
    }
    return _tabFrameHeight;
}
- (CGFloat)tabMargin {
    if (!_tabMargin) {
        self.tabMargin = 38;
    }
    return _tabMargin;
}
- (NSUInteger)currentTabSelected {
    if (!_currentTabSelected) {
        self.currentTabSelected = 0;
    }
    return _currentTabSelected;
}
- (UIColor *)tabBackgroundColor {
    if (!_tabBackgroundColor) {
        self.tabBackgroundColor = [UIColor whiteColor];
    }
    return _tabBackgroundColor;
}
- (CGFloat)tabButtonFontSize {
    if (!_tabButtonFontSize) {
        self.tabButtonFontSize = 14;
    }
    return _tabButtonFontSize;
}
- (UIColor *)tabButtonTitleColorForNormal {
    if (!_tabButtonTitleColorForNormal) {
        self.tabButtonTitleColorForNormal = [UIColor colorWithHexString:@"#444444"];
    }
    return _tabButtonTitleColorForNormal;
}
- (UIColor *)tabButtonTitleColorForSelected {
    if (!_tabButtonTitleColorForSelected) {
        self.tabButtonTitleColorForSelected = RadMenuColor;
    }
    return _tabButtonTitleColorForSelected;
}
- (UIView *)selectedLine {
    if (!_selectedLine) {
        self.selectedLine = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.tabView.frame) - 2, self.selectedLineWidth, 2)];
        _selectedLine.backgroundColor = RadMenuColor;
        [self addSubview:_selectedLine];
    }
    return _selectedLine;
}
- (CGFloat)selectedLineWidth {
    if (!_selectedLineWidth) {
        self.selectedLineWidth = 42;
    }
    return _selectedLineWidth;
}
- (CGFloat)selectedLineOffsetXBeforeMoving {
    if (!_selectedLineOffsetXBeforeMoving) {
        self.selectedLineOffsetXBeforeMoving = 0;
    }
    return _selectedLineOffsetXBeforeMoving;
}


/*!
 * @brief 滑动pager主体
 */
- (UIScrollView*)bodyScrollView {
    if (!_bodyScrollView) {
        self.bodyScrollView = [[NJScrollTableScrollView alloc] initWithFrame:CGRectMake(0, _tabFrameHeight, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame) - _tabFrameHeight)];
        _bodyScrollView.delegate = self;
        _bodyScrollView.pagingEnabled = YES;
        _bodyScrollView.userInteractionEnabled = YES;
        _bodyScrollView.bounces = NO;
        _bodyScrollView.showsHorizontalScrollIndicator = NO;
        _bodyScrollView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleWidth;
        [self addSubview:_bodyScrollView];
    }
    return _bodyScrollView;
}
- (NSMutableArray *)viewsArray {
    if (!_viewsArray) {
        self.viewsArray = [[NSMutableArray alloc] init];
    }
    return _viewsArray;
}

- (void)setScrollEnable:(BOOL)scrollEnable{
    _scrollEnable = scrollEnable;
    _bodyScrollView.scrollEnabled = scrollEnable;
}

@end

