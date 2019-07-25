//
//  CouponSearchResultViewController.m
//  Meidebi
//
//  Created by mdb-admin on 2017/6/30.
//  Copyright © 2017年 meidebi. All rights reserved.
//

#import "CouponSearchResultViewController.h"
#import "CouponLiveSubjectView.h"
#import "ProductInfoViewController.h"
@interface CouponSearchResultViewController ()
<
CouponLiveSubjectViewDelegate
>
@property (nonatomic, strong) CouponLiveSubjectView *subjectView;
@property (nonatomic, strong) NSString *searchStr;
@end

@implementation CouponSearchResultViewController

- (instancetype)initWithSearchStr:(NSString *)searchStr{
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        _searchStr = searchStr;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = _searchStr;
    [self setupSubviews];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)setupSubviews{
    _subjectView = [[CouponLiveSubjectView alloc] initWithType:CouponSubViewTypeReult];
    [self.view addSubview:_subjectView];
    [_subjectView mas_makeConstraints:^(MASConstraintMaker *make) {
        if (@available(iOS 11.0, *)) {
            make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop);
            make.left.equalTo(self.view.mas_safeAreaLayoutGuideLeft);
            make.right.equalTo(self.view.mas_safeAreaLayoutGuideRight);
            make.bottom.equalTo(self.view.mas_bottom);
        }else{
            make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(kTopHeight, 0, 0, 0));
        }
    }];
    _subjectView.delegate = self;
    _subjectView.searchKey = _searchStr;
}

#pragma mark - CouponLiveSubjectViewDelegate
- (void)couponLiveSubjectViewDidSelectProduct:(NSString *)ProductID{
    ProductInfoViewController *productInfoVC = [[ProductInfoViewController alloc] init];
    productInfoVC.productId = ProductID;
    [self.navigationController pushViewController:productInfoVC animated:YES];
}

@end
