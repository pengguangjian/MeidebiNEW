//
//  ConVersionItemViewController.m
//  Meidebi
//
//  Created by mdb-admin on 2017/6/22.
//  Copyright © 2017年 meidebi. All rights reserved.
//

#import "ConVersionItemViewController.h"
#import "ConversionItemTableViewCell.h"
#import "ConversionDataController.h"
#import <MJRefresh/MJRefresh.h>
#import "MDBEmptyView.h"
static NSString * const kTableViewCellIdentifier = @"cell";

@interface ConVersionItemViewController ()
<
ConversionItemTableViewCellDelegate
>
@property (nonatomic, strong) NSArray *items;
@property (nonatomic, assign) ConVersionType type;
@property (nonatomic, strong) ConversionDataController *dataController;
@property (nonatomic, strong) MDBEmptyView *emptyView;
@end

@implementation ConVersionItemViewController

- (instancetype)initWithConVersionType:(ConVersionType)type{
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        _type = type;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView registerClass:[ConversionItemTableViewCell class]
           forCellReuseIdentifier:kTableViewCellIdentifier];
    self.tableView.tableFooterView = [UIView new];
    [self loadData];
    [self tableViewAddRefersh];
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

- (void)loadData{
    [self.dataController requestGiftInfoDataWithView:nil
                                                type:[NSString stringWithFormat:@"%@",@(_type)]
                                            callback:^(NSError *error, BOOL state, NSString *describle) {
                                                if (state) {
                                                    _items = self.dataController.resultArray;
                                                    if (_items.count > 0) {
                                                        [self.tableView reloadData];
                                                    }else{
                                                        self.emptyView.hidden = NO;
                                                    }
                                                }
                                            }];

}

- (void)reloadTableViewDataSource{
    [self.dataController lastNewPageDataWithCallback:^(NSError *error, BOOL state, NSString *describle) {
        if (state) {
            _items = self.dataController.resultArray;
            if (_items.count > 0) {
                [self.tableView reloadData];
            }else{
                self.emptyView.hidden = NO;
            }
        }
        [self.tableView.mj_header endRefreshing];
    }];
}

- (void)footReloadTableViewDateSource{
    [self.dataController nextPageDataWithCallback:^(NSError *error, BOOL state, NSString *describle) {
        if (state) {
            _items = self.dataController.resultArray;
            [self.tableView reloadData];
        }
        [self.tableView.mj_footer endRefreshing];
    }];
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ConversionItemTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kTableViewCellIdentifier];
    [cell bindDataWithModel:_items[indexPath.row]];
    cell.delegate = self;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 195;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 8.f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenW, 8)];
    headerView.backgroundColor = [UIColor colorWithHexString:@"#F7F7F7"];
    return headerView;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]) {
        [cell setPreservesSuperviewLayoutMargins:NO];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([self.delegate respondsToSelector:@selector(conversionTableViewDidSelectCellWithItem:)]) {
        [self.delegate conversionTableViewDidSelectCellWithItem:_items[indexPath.row]];
    }
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if ([scrollView isKindOfClass:[UITableView class]]) {
        //固定头部视图
        if (scrollView.contentOffset.y<=8&&scrollView.contentOffset.y>=0) {
            scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
        } else if (scrollView.contentOffset.y>=8) {
            scrollView.contentInset = UIEdgeInsetsMake(-8, 0, 0, 0);
        }
    }
}

#pragma mark - ConversionItemTableViewCellDelegate
- (void)tableViewCellDidClickConversionBtn:(ConversionItemTableViewCell *)cell type:(NSInteger)type
{
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    if ([self.delegate respondsToSelector:@selector(tableViewConfirmConversionItem:type:)]) {
        [self.delegate tableViewConfirmConversionItem:_items[indexPath.row] type:type];
    }
}
//- (void)tableViewCellDidClickConversionBtn:(ConversionItemTableViewCell *)cell{
//    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
//    if ([self.delegate respondsToSelector:@selector(tableViewConfirmConversionItem:)]) {
//        [self.delegate tableViewConfirmConversionItem:_items[indexPath.row]];
//    }
//}

#pragma mark - setters and getters
- (ConversionDataController *)dataController{
    if (!_dataController) {
        _dataController = [[ConversionDataController alloc] init];
    }
    return _dataController;
}

- (MDBEmptyView *)emptyView{
    if (!_emptyView) {
        _emptyView = [[MDBEmptyView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenW, CGRectGetHeight(self.view.frame))];
        [self.view addSubview:_emptyView];
        _emptyView.remindStr = @"暂时还没有数据哦～";
        _emptyView.hidden = YES;
    }
    return _emptyView;
}
@end
