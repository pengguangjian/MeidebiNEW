//
//  MyZanAndCallMeViewController.m
//  Meidebi
//
//  Created by ZlJ_losaic on 2017/9/7.
//  Copyright © 2017年 meidebi. All rights reserved.
//

#import "MyZanAndCallMeViewController.h"
#import "MyZanAndCallMeTableViewCell.h"
#import "MDB_UserDefault.h"
#import "PersonalInfoDataController.h"
#import <MJRefresh/MJRefresh.h>
#import "PersonalInfoIndexViewController.h"
#import "ProductInfoViewController.h"
#import "ActivityDetailViewController.h"
#import "MDBEmptyView.h"
static NSString * const kTableViewCellIdentifier = @"cell";
@interface MyZanAndCallMeViewController ()
<
MyZanAndCallMeTableViewCellDelegate
>
@property (nonatomic, assign) ViewControllerType type;
@property (nonatomic, strong) NSArray *results;
@property (nonatomic, strong) MDBEmptyView *emptyView;
@property (nonatomic, strong) PersonalInfoDataController *datacontroller;
@end

@implementation MyZanAndCallMeViewController

#pragma mark - def

#pragma mark - override

- (instancetype)initWithType:(ViewControllerType)type{
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        _type = type;
    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    if (_type == ViewControllerTypeZan) {
        self.title = @"赞";
    }else{
        self.title = @"@我的";
    }
    [self setupSubviews];
    [self loadData];
}

#pragma mark - private method
- (void)setupSubviews{
    self.tableView.separatorColor = [UIColor colorWithHexString:@"#E2E2E2"];
    [self.tableView registerClass:[MyZanAndCallMeTableViewCell class] forCellReuseIdentifier:kTableViewCellIdentifier];
    self.tableView.tableFooterView = [UIView new];
    __weak __typeof__(self) weakself = self;
    weakself.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        __strong __typeof__(weakself) strongSelf = weakself;
        [strongSelf lastPage];
    }];
    weakself.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        __strong __typeof__(weakself) strongSelf = weakself;
        [strongSelf nextPage];
    }];

}

- (void)loadData{
    if (_type == ViewControllerTypeZan) {
        [self.datacontroller requestNewsMyZanInView:self.view callback:^(NSError *error, BOOL state, NSString *describle) {
            if (state) {
                _results = self.datacontroller.resultArr;
                if (_results.count > 0) {
                    self.emptyView.hidden = YES;
                    [self.tableView reloadData];
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"MyInformViewIsZanRemind" object:nil];
                }else{
                    self.emptyView.hidden = NO;
                }
            }else{
                self.emptyView.hidden = NO;
            }
        }];
    }
}

#pragma mark - events
- (void)lastPage{
    [self.datacontroller lastNewPageDataWithCallback:^(NSError *error, BOOL state, NSString *describle) {
        _results = self.datacontroller.resultArr;
        [self.tableView.mj_header endRefreshing];
        [self.tableView reloadData];
    }];
}

- (void)nextPage{
    [self.datacontroller nextPageDataWithCallback:^(NSError *error, BOOL state, NSString *describle) {
        _results = self.datacontroller.resultArr;
        [self.tableView.mj_footer endRefreshing];
        [self.tableView reloadData];
    }];
}

#pragma mark - UITableView Datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _results.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MyZanAndCallMeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kTableViewCellIdentifier];
    [cell bindDataWithModel:_results[indexPath.row]];
    cell.delegate = self;
    return cell;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 调整Separator位置
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 126;
}

#pragma mark - UITableView Delegate methods
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([@"5" isEqualToString:[NSString nullToString:_results[indexPath.row][@"type"]]]) {
        NSString *commityID = [NSString nullToString:_results[indexPath.row][@"linkid"]];
        ActivityDetailViewController *vc = [[ActivityDetailViewController alloc] init];
        vc.activityId = commityID;
        [self.navigationController pushViewController:vc animated:YES];
    }else if ([@"1" isEqualToString:[NSString nullToString:_results[indexPath.row][@"type"]]]) {
        NSString *commityID = [NSString nullToString:_results[indexPath.row][@"linkid"]];
        ProductInfoViewController *vc = [[ProductInfoViewController alloc] init];
        vc.productId = commityID;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark - MyZanAndCallMeTableViewCellDelegate
- (void)tableViewCellDidClickAvaterImageView:(MyZanAndCallMeTableViewCell *)cell{
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    NSString *userid = [NSString nullToString:_results[indexPath.row][@"userid"]];
    PersonalInfoIndexViewController *vc = [[PersonalInfoIndexViewController alloc] initWithUserID:userid];
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark - getter / setter
- (PersonalInfoDataController *)datacontroller{
    if (!_datacontroller) {
        _datacontroller = [[PersonalInfoDataController alloc] init];
    }
    return _datacontroller;
}

- (MDBEmptyView *)emptyView{
    if (!_emptyView) {
        _emptyView = [[MDBEmptyView alloc] initWithFrame:CGRectMake(0, kTopHeight, kMainScreenW, kMainScreenH-kTopHeight)];
        _emptyView.remindStr = @"暂时没有数据哦～";
        [self.view addSubview:_emptyView];
        _emptyView.hidden = YES;
    }
    return _emptyView;
}
@end
