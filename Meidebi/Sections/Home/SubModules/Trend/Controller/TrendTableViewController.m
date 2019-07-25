//
//  TrendTableViewController.m
//  Meidebi
//
//  Created by mdb-admin on 2017/11/30.
//  Copyright © 2017年 meidebi. All rights reserved.
//

#import "TrendTableViewController.h"
#import "TrendTableViewCell.h"
#import "TrendDataController.h"
#import "MDBEmptyView.h"
#import "MDB_UserDefault.h"
#import <MJRefresh.h>
static NSString * const kTableViewCellIdentifier = @"cell";
@interface TrendTableViewController ()
<
TrendTableViewCellDelegate
>
@property (nonatomic, assign) TableViewTrendType trendType;
@property (nonatomic, strong) NSArray *contents;
@property (nonatomic, strong) TrendDataController *dataController;
@property (nonatomic, strong) MDBEmptyView *emptyView;
@end

@implementation TrendTableViewController
- (instancetype)initWithType:(TableViewTrendType)type{
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        _trendType = type;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.estimatedRowHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
    self.tableView.estimatedSectionHeaderHeight = 0;
    [self.tableView registerClass:[TrendTableViewCell class] forCellReuseIdentifier:kTableViewCellIdentifier];
    self.tableView.tableFooterView = [UIView new];
    [self loadData];
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self loadData];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)loadData{
    [self.dataController requestTrendListInView:self.view
                                           type:[NSString stringWithFormat:@"%@",@(_trendType)]
                                       callback:^(NSError *error, BOOL state, NSString *describle) {
                                           [self.tableView.mj_header endRefreshing];
                                           if (state) {
                                               if (self.dataController.requestResults.count > 0) {
                                                   self.emptyView.hidden = YES;
                                                   [self renderSubjectView];
                                               }else{
                                                   self.emptyView.hidden = NO;
                                               }
                                           }else{
                                               [MDB_UserDefault showNotifyHUDwithtext:describle inView:self.view];
                                           }
    }];
}

- (void)renderSubjectView{
    NSMutableArray *results = [NSMutableArray array];
    for (NSDictionary *dict in self.dataController.requestResults) {
        NSMutableDictionary *mutableDict = [NSMutableDictionary dictionaryWithDictionary:dict];
        [mutableDict setObject:[NSString stringWithFormat:@"%@",@(_trendType)] forKey:@"type"];
        [mutableDict setObject:[NSNumber numberWithBool:NO] forKey:@"isSelect"];
        [results addObject:mutableDict.mutableCopy];
    }
    _contents = results.mutableCopy;
    [self.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _contents.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TrendTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kTableViewCellIdentifier];
    [cell bindDataWithModel:_contents[indexPath.row] row:indexPath.row];
    cell.delegate = self;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 138;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSMutableDictionary *dic = _contents[indexPath.row];
    [dic setObject:[NSNumber numberWithBool:YES] forKey:@"isSelect"];
    if ([self.delegate respondsToSelector:@selector(tableViewCellDidSelectWithID:)]) {
        [self.delegate tableViewCellDidSelectWithID:[NSString nullToString:_contents[indexPath.row][@"id"]]];
    }
    [tableView reloadData];
}

#pragma mark - TrendTableViewCellDelegate
- (void)tableViewCellDidHandleCouponWithCell:(TrendTableViewCell *)cell{
    NSIndexPath *path = [self.tableView indexPathForCell:cell];
    if ([self.delegate respondsToSelector:@selector(openCouponWithUrl:)]) {
        [self.delegate openCouponWithUrl:[NSString nullToString:_contents[path.row][@"url"]]];
    }
}

#pragma mark - setters and getters
- (TrendDataController *)dataController{
    if (!_dataController) {
        _dataController = [[TrendDataController alloc] init];
    }
    return _dataController;
}

- (MDBEmptyView *)emptyView{
    if (!_emptyView) {
        _emptyView = [[MDBEmptyView alloc] initWithFrame:self.view.bounds];
        _emptyView.remindStr = @"暂时还没有数据哦！";
        [self.view addSubview:_emptyView];
    }
    return _emptyView;
}

@end
