//
//  WelfareHomeSubjectView.m
//  Meidebi
//
//  Created by mdb-admin on 2016/10/24.
//  Copyright © 2016年 meidebi. All rights reserved.
//

#import "WelfareHomeSubjectView.h"
#import "MDB_UserDefault.h"
#import "ZLJNavMenusSwipeView.h"
#import "WelfareDynamicViewController.h"
#import "ConversionViewController.h"
@interface WelfareHomeSubjectView ()
<
ZLJNavMenusSwipViewDataSource,
WelfareStrategyViewControllerDelegate,
WelfareDynamicViewControllerDelegate,
ConversionViewControllerDelegate
>
@property (nonatomic, strong) NSArray *allVCs;
@property (nonatomic, strong) UINavigationController *currentNaVC;
@property (nonatomic, strong) ZLJNavMenusSwipeView *subView;
@end

@implementation WelfareHomeSubjectView

- (instancetype)initWithCurrentNavigationController:(UINavigationController *)nav{
    _currentNaVC = nav;
    return [self initWithFrame:CGRectZero];
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupSubViews];
    }
    return self;
}

- (void)setupSubViews{
    ConversionViewController *conversionVC = [[ConversionViewController alloc] init];
    conversionVC.isSubViewController = YES;
    conversionVC.delegate = self;
    WelfareStrategyViewController *welfareStrategyVC = [[WelfareStrategyViewController alloc] init];
    welfareStrategyVC.title = @"攻略";
    welfareStrategyVC.delegate = self;
    _allVCs = @[welfareStrategyVC,conversionVC];
    ZLJNavMenusSwipeView *subView = [[ZLJNavMenusSwipeView alloc] initWithCurrentNavigationController:self.currentNaVC];
    [self addSubview:subView];
    [subView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    subView.dataSource = self;
    [subView setupSubviews];
    _subView = subView;
}

- (void)bindAttendenceDataWithModel:(NSDictionary *)model{
   
}

- (void)bindWaresDataWithModel:(NSArray *)model{
 
}

- (void)update{
//    if (self.didComplete) {
//        self.didComplete(_subView.navigationBarView);
//    }
    [self.delegate welfareHomeSubjectViewDidNAv:_subView.navigationBarView];

}

#pragma mark - ZLJNavMenusSwipViewDataSource
- (NSInteger)numberOfPages:(ZLJNavMenusSwipeView *)swipeViewController{
    return _allVCs.count;
}

- (UIViewController *)scrollTableViewOfPagers:(ZLJNavMenusSwipeView *)swipeView indexOfPagers:(NSUInteger)index{
    return _allVCs[index];
}

#pragma mark - WelfareStrategyViewControllerDelegate
- (void)welfareStrategyViewControllerDidSelectCellWithType:(WelfareStrategyJumpType)type{
    if ([self.delegate respondsToSelector:@selector(welfareHomeSubjectViewDidSelectCellWithType:)]) {
        [self.delegate welfareHomeSubjectViewDidSelectCellWithType:type];
    }
}

- (void)welfareStrategyViewControllerDidClickMyWelfareBtn{
    if ([self.delegate respondsToSelector:@selector(welfareHomeSubjectViewDidClickMyWelfareBtn)]) {
        [self.delegate welfareHomeSubjectViewDidClickMyWelfareBtn];
    }
}

- (void)welfareStrategyViewControllerDidClickMyWelfareAd:(NSDictionary *)adInfo{
    if ([self.delegate respondsToSelector:@selector(welfareHomeSubjectViewDidClickAd:)]) {
        [self.delegate welfareHomeSubjectViewDidClickAd:adInfo];
    }
}

#pragma mark - WelfareDynamicViewControllerDelegate
- (void)welfareDynamicViewControllerDidClickAvater:(NSString *)userid{
    if ([self.delegate respondsToSelector:@selector(welfareHomeSubjectViewDidClickAvater:)]) {
        [self.delegate welfareHomeSubjectViewDidClickAvater:userid];
    }
}

- (void)welfareDynamicViewControllerDidClickAd:(NSDictionary *)adInfo{
    if ([self.delegate respondsToSelector:@selector(welfareHomeSubjectViewDidClickAd:)]) {
        [self.delegate welfareHomeSubjectViewDidClickAd:adInfo];
    }
}

#pragma mark - ConversionViewControllerDelegate
- (void)conversionCouponWithID:(NSString *)couponID{
    if ([self.delegate respondsToSelector:@selector(welfareHomeSubjectViewConversionCouponWithID:)]) {
        [self.delegate welfareHomeSubjectViewConversionCouponWithID:couponID];
    }
}
- (void)welfareHomeSubjectViewReferLogisticsAddress:(void (^)(void))complete{
    if ([self.delegate respondsToSelector:@selector(welfareHomeSubjectViewReferLogisticsAddress:)]) {
        [self.delegate welfareHomeSubjectViewReferLogisticsAddress:^{
            complete();
        }];
    }
}
- (void)welfareHomeSubjectViewDidSelectWaresWithItemId:(NSString *)waresId waresType:(NSString *)type haveto:(NSString *)haveto{
    if ([self.delegate respondsToSelector:@selector(welfareHomeSubjectViewDidSelectWaresWithItemId:waresType:haveto:)]) {
        [self.delegate welfareHomeSubjectViewDidSelectWaresWithItemId:waresId waresType:type haveto:haveto];
    }
}
- (void)welfareHomeSubjectViewReferCopperRule{
    if ([self.delegate respondsToSelector:@selector(welfareHomeSubjectViewReferCopperRule)]) {
        [self.delegate welfareHomeSubjectViewReferCopperRule];
    }
}
- (void)jumpLoginVc{
    if ([self.delegate respondsToSelector:@selector(welfareHomeSubjectViewJumpLoginVc)]) {
        [self.delegate welfareHomeSubjectViewJumpLoginVc];
    }
}

@end
