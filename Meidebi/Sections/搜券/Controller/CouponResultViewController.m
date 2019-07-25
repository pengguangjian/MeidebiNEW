//
//  CouponResultViewController.m
//  Meidebi
//
//  Created by mdb-admin on 2017/7/10.
//  Copyright © 2017年 meidebi. All rights reserved.
//

#import "CouponResultViewController.h"
#import "CouponResultSubjectView.h"
#import "FindCouponDataController.h"
@interface CouponResultViewController ()
<
CouponResultSubjectViewDelegate
>
@property (nonatomic, strong) CouponResultSubjectView *subjectView;
@property (nonatomic, strong) FindCouponDataController *datacontroller;
@end

@implementation CouponResultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupSubviews];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)setupSubviews{
    _subjectView = [CouponResultSubjectView new];
    [self.view addSubview:_subjectView];
    [_subjectView mas_makeConstraints:^(MASConstraintMaker *make) {
        if (@available(iOS 11.0, *)) {
            make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop);
            make.left.equalTo(self.view.mas_safeAreaLayoutGuideLeft);
            make.right.equalTo(self.view.mas_safeAreaLayoutGuideRight);
            make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom);
        }else{
            make.edges.equalTo(self.view);
        }
    }];
    _subjectView.delegate = self;
}

- (void)loadCouponWithKeyword:(NSString *)key{
    [self.datacontroller requestCouponSearchDataWithView:self.view keyword:key order:_type callback:^(NSError *error, BOOL state, NSString *describle) {
        if (state) {
            [_subjectView bindDataWithModel:self.datacontroller.resultArray];
        }
    }];
}

#pragma mark - CouponResultSubjectViewDelegate
- (void)reloadCollectionViewDataSource{
    [self.datacontroller lastNewPageDataWithCallback:^(NSError *error, BOOL state, NSString *describle) {
        [_subjectView updataDataWithModel:self.datacontroller.resultArray];
    }];
}

- (void)footReloadCollectionViewDataSource{
    [self.datacontroller nextPageDataWithCallback:^(NSError *error, BOOL state, NSString *describle) {
        [_subjectView updataDataWithModel:self.datacontroller.resultArray];
    }];
}

- (void)couponSimpleCollectionViewCellDidClickDrawBtnWithCouponURL:(NSString *)url{
    if ([self.delegate respondsToSelector:@selector(couponResultViewDidClickDrawCouponBtnWithUrl:)]) {
        [self.delegate couponResultViewDidClickDrawCouponBtnWithUrl:url];
    }
}

- (void)couponResultCollectionViewDidScroll{
    if ([self.delegate respondsToSelector:@selector(couponResultViewControllerDidScroll)]) {
        [self.delegate couponResultViewControllerDidScroll];
    }
}
#pragma mark - setters and getters
- (void)setKeyword:(NSString *)keyword{
    _keyword = keyword;
    _subjectView.searchKey = _keyword;
    [self loadCouponWithKeyword:keyword];
}

- (FindCouponDataController *)datacontroller{
    if (!_datacontroller) {
        _datacontroller = [[FindCouponDataController alloc] init];
    }
    return _datacontroller;
}

@end
