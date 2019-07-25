//
//  CouponLiveViewController.m
//  Meidebi
//
//  Created by mdb-admin on 2017/6/29.
//  Copyright © 2017年 meidebi. All rights reserved.
//

#import "CouponLiveViewController.h"
#import "CouponLiveSubjectView.h"
#import "ProductInfoViewController.h"
#import "CouponSearchResultViewController.h"
@interface CouponLiveViewController ()
<
CouponLiveSubjectViewDelegate
>
@property (nonatomic, strong) CouponLiveSubjectView *subjectView;

@end

@implementation CouponLiveViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"优惠券";
    [self setupSubviews];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)setupSubviews{
    _subjectView = [[CouponLiveSubjectView alloc] initWithType:CouponSubViewTypeList];
    [self.view addSubview:_subjectView];
    [_subjectView mas_makeConstraints:^(MASConstraintMaker *make) {
        if (@available(iOS 11.0, *)) {
            make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop);
            make.left.equalTo(self.view.mas_safeAreaLayoutGuideLeft);
            make.right.equalTo(self.view.mas_safeAreaLayoutGuideRight);
            make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom);
        }else{
            make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(kTopHeight, 0, 0, 0));
        }
    }];
    _subjectView.delegate = self;
    _subjectView.searchKey = @"";
}

#pragma mark - CouponLiveSubjectViewDelegate
- (void)couponLiveSubjectViewDidSelectProduct:(NSString *)ProductID{
    ProductInfoViewController *productInfoVC = [[ProductInfoViewController alloc] init];
    productInfoVC.productId = ProductID;
    [self.navigationController pushViewController:productInfoVC animated:YES];
}

- (void)couponLiveSubjectViewDidClickSearchBtn:(NSString *)searchStr{
    CouponSearchResultViewController *resuiltVC = [[CouponSearchResultViewController alloc] initWithSearchStr:searchStr];
    [self.navigationController pushViewController:resuiltVC animated:YES];
}

@end
