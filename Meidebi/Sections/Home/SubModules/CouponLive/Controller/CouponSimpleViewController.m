//
//  CouponSimpleViewController.m
//  Meidebi
//
//  Created by mdb-admin on 2017/6/29.
//  Copyright © 2017年 meidebi. All rights reserved.
//

#import "CouponSimpleViewController.h"
#import "CouponSimpleTableViewCell.h"
#import "CheapOrOutsideDataController.h"
#import "CouponLiveDataController.h"
#import "CheapOrOutsideSubjectsViewModel.h"
#import <MJRefresh/MJRefresh.h>
static NSString * const kTableviewCellIdentifier = @"cell";
@interface CouponSimpleViewController ()
@property (nonatomic, strong) CouponLiveDataController *dataController;
@property (nonatomic, strong) CheapOrOutsideSubjectsViewModel *viewModel;
@end

@implementation CouponSimpleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.tableFooterView = [UIView new];
    [self.tableView registerClass:[CouponSimpleTableViewCell class]
           forCellReuseIdentifier:kTableviewCellIdentifier];
    [self tableViewAddRefersh];
    [self setExtraCellLineHidden:self.tableView];
    self.tableView.estimatedRowHeight = 0;
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)tableViewAddRefersh{
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self reloadTableViewDataSource];
    }];
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [self footReloadTableViewDateSource];
    }];
    
}

- (void)setExtraCellLineHidden: (UITableView *)tableView{
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
}

- (void)reloadTableViewDataSource{
    [self.dataController lastNewPageDataWithCallback:^(NSError *error, BOOL state, NSString *describle) {
        if (!error) {
            [self renderSubjectView];
        }
        [self.tableView.mj_header endRefreshing];
    }];
}

- (void)footReloadTableViewDateSource{
    [self.dataController nextPageDataWithCallback:^(NSError *error, BOOL state, NSString *describle) {
        if (!error) {
            [self renderSubjectView];
        }
        [self.tableView.mj_footer endRefreshing];
    }];
}

- (void)fetchSubjectData{
    [self.dataController requestSubjectDataKeyword:_keyword
                                             order:_type
                                            InView:self.tableView callback:^(NSError *error, BOOL state, NSString *describle) {
                                                if (state) {
                                                    [self renderSubjectView];
                                                }
                                                [self updateView];
                                        }];
}

- (void)updateView{
    BOOL isEmpty = NO;
    if (self.dataController.requestResults.count > 0) {
        isEmpty = YES;
    }
    if ([self.delegate respondsToSelector:@selector(couponSimpleTableViewInquireResult:)]) {
        [self.delegate couponSimpleTableViewInquireResult:isEmpty];
    }
    
}

- (void)renderSubjectView{
    _viewModel = [CheapOrOutsideSubjectsViewModel viewModelWithSubjects:self.dataController.requestResults];
    [self.tableView reloadData];

}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _viewModel.results.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CouponSimpleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kTableviewCellIdentifier];
    [cell fetchCommodityData:_viewModel.results[indexPath.row]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 138;
}

#pragma mark - UITableView Delegate methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.delegate respondsToSelector:@selector(couponSimpleTableViewDidIndexRowWithProductID:)]) {
        Commodity *aCommodity = _viewModel.results[indexPath.row];
        [self.delegate couponSimpleTableViewDidIndexRowWithProductID:aCommodity.commodityid];
    }
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if ([self.delegate respondsToSelector:@selector(couponSimpleTableViewDidScroll)]) {
        [self.delegate couponSimpleTableViewDidScroll];
    }
}

#pragma mark - setters and getters

- (CouponLiveDataController *)dataController{
    if (!_dataController) {
        _dataController = [[CouponLiveDataController alloc] init];
    }
    return _dataController;
}

- (void)setKeyword:(NSString *)keyword{
    _keyword = keyword;
    [self fetchSubjectData];
}

@end
