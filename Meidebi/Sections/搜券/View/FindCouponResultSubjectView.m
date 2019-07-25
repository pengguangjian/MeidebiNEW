
//
//  FindCouponResultSubjectView.m
//  Meidebi
//
//  Created by mdb-admin on 2017/7/10.
//  Copyright © 2017年 meidebi. All rights reserved.
//

#import "FindCouponResultSubjectView.h"
#import "NJScrollTableView.h"
#import "CouponResultViewController.h"
@interface FindCouponResultSubjectView ()
<
ScrollTabViewDataSource,
CouponResultViewControllerDelegate
>
@property (nonatomic, strong) NSArray *allVCs;

@end

@implementation FindCouponResultSubjectView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupSubviews];
    }
    return self;
}

- (void)setupSubviews{
    
    CouponResultViewController *salesVC = [[CouponResultViewController alloc] init];
    salesVC.title = @"销量";
    salesVC.type = @"sell";
    salesVC.delegate = self;
    CouponResultViewController *reducedVC = [[CouponResultViewController alloc] init];
    reducedVC.title = @"券后价";
    reducedVC.type = @"price";
    reducedVC.delegate = self;
    CouponResultViewController *denominationVC = [[CouponResultViewController alloc] init];
    denominationVC.title = @"面额价";
    denominationVC.type = @"coupon";
    denominationVC.delegate = self;
    _allVCs = @[salesVC,reducedVC,denominationVC];
    NJScrollTableView *scrollTableView = [[NJScrollTableView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenW,kMainScreenH-kTopHeight)];
    [self addSubview:scrollTableView];
    scrollTableView.backgroundColor = [UIColor whiteColor];
    scrollTableView.selectedLineWidth = 45;
    scrollTableView.tabButtonTitleColorForNormal = [UIColor colorWithHexString:@"#333333"];
    scrollTableView.dataSource = self;
    [scrollTableView buildUI];
    [scrollTableView selectTabWithIndex:0 animate:NO];
}

#pragma mark - ScrollTabViewDataSource
- (NSUInteger)numberOfPagers:(NJScrollTableView *)view{
    return _allVCs.count;
}

- (UITableViewController *)scrollTableViewOfPagers:(NJScrollTableView *)view
                                     indexOfPagers:(NSUInteger)index{
    return _allVCs[index];
}

#pragma mark - CouponResultViewControllerDelegate
- (void)couponResultViewDidClickDrawCouponBtnWithUrl:(NSString *)url{
    if ([self.delegate respondsToSelector:@selector(subjectViewDidClickDrawBtnWithUrl:)]) {
        [self.delegate subjectViewDidClickDrawBtnWithUrl:url];
    }
}

- (void)couponResultViewControllerDidScroll{
    if ([self.delegate respondsToSelector:@selector(subjectViewDidScroll)]) {
        [self.delegate subjectViewDidScroll];
    }
}

#pragma mark - setters and getters 
- (void)setSearhKeyword:(NSString *)searhKeyword{
    _searhKeyword = searhKeyword;
    for (CouponResultViewController *vc in self.allVCs) {
        vc.keyword = searhKeyword;
    }
}

@end
