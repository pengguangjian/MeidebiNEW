//
//  TrendHomeViewController.m
//  Meidebi
//
//  Created by mdb-admin on 2017/11/30.
//  Copyright © 2017年 meidebi. All rights reserved.
//

#import "TrendHomeViewController.h"
#import "NJScrollTableView.h"
#import "TrendTableViewController.h"
#import "ProductInfoViewController.h"
#import <AlibcTradeSDK/AlibcTradeSDK/AlibcTradeSDK.h>

@interface TrendHomeViewController ()
<
ScrollTabViewDataSource,
TrendTableViewControllerDelegate
>
@property (nonatomic, strong) NSArray *vcs;
@end

@implementation TrendHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"排行榜";
    [self configureUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)configureUI{
    TrendTableViewController *couponVC = [[TrendTableViewController alloc] initWithType:TableViewTrendTypeCounpon];
    couponVC.title = @"优惠券";
    couponVC.delegate = self;
    TrendTableViewController *inlandVC = [[TrendTableViewController alloc] initWithType:TableViewTrendTypeInland];
    inlandVC.title = @"国内";
    inlandVC.delegate = self;
    TrendTableViewController *overseasVC = [[TrendTableViewController alloc] initWithType:TableViewTrendTypeOverseas];
    overseasVC.title = @"海淘";
    overseasVC.delegate = self;
    _vcs = @[couponVC,inlandVC,overseasVC];
    NJScrollTableView *mainScroll = [[NJScrollTableView alloc] initWithFrame:CGRectMake(0, kTopHeight, kMainScreenW, kMainScreenH-kTopHeight)];
    [self.view addSubview:mainScroll];
    mainScroll.dataSource = self;
    mainScroll.backgroundColor = [UIColor whiteColor];
    mainScroll.selectedLineWidth = 100;
    [mainScroll buildUI];
    [mainScroll selectTabWithIndex:0 animate:NO];
    
}

#pragma mark - TrendTableViewControllerDelegate
- (void)tableViewCellDidSelectWithID:(NSString *)discountID{
    ProductInfoViewController *vc = [[ProductInfoViewController alloc] init];
    vc.productId = discountID;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)openCouponWithUrl:(NSString *)url{
    if ([@"" isEqualToString:url]) return;
    id<AlibcTradePage> page = [AlibcTradePageFactory page:url];
    id<AlibcTradeService> service = [AlibcTradeSDK sharedInstance].tradeService;
    AlibcTradeShowParams *showParams = [[AlibcTradeShowParams alloc] init];
    showParams.openType = AlibcOpenTypeNative;
    showParams.linkKey = @"taobao";
    [service show:self
             page:page
       showParams:showParams
      taoKeParams:nil
       trackParam:nil
    tradeProcessSuccessCallback:^(AlibcTradeResult * _Nullable result) {
    } tradeProcessFailedCallback:^(NSError * _Nullable error) {
    }];
}

#pragma mark - ScrollTabViewDataSource
- (NSUInteger)numberOfPagers:(NJScrollTableView *)view{
    return _vcs.count;
}

- (UITableViewController *)scrollTableViewOfPagers:(NJScrollTableView *)view
                                     indexOfPagers:(NSUInteger)index{
    return _vcs[index];
}

@end
