//
//  SendGiftViewController.m
//  Meidebi
//
//  Created by mdb-admin on 2017/11/30.
//  Copyright © 2017年 meidebi. All rights reserved.
//

#import "SendGiftViewController.h"
#import "GiftAndTopicTableViewCell.h"
#import "SendGiftDataController.h"
#import "MDBEmptyView.h"
#import "MDB_UserDefault.h"
#import <MJRefresh/MJRefresh.h>
#import "ProductInfoViewController.h"
static NSString * const kTableViewCellIdentifier = @"cell";

@interface SendGiftViewController ()
@property (nonatomic, strong) NSArray *contents;
@property (nonatomic, strong) SendGiftDataController *dataController;
@property (nonatomic, strong) MDBEmptyView *emptyView;
@end

@implementation SendGiftViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"逢节送礼";
    [self.tableView registerClass:[GiftAndTopicTableViewCell class] forCellReuseIdentifier:kTableViewCellIdentifier];
    self.tableView.tableFooterView = [UIView new];
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [self refreshFooter];
    }];
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self refreshHeader];
    }];
    [self loadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)loadData{
    [self.dataController requestSendGiftListInView:self.view
                                          callback:^(NSError *error, BOOL state, NSString *describle) {
                                              if (state) {
                                                  if (self.dataController.requestResults.count > 0) {
                                                      self.emptyView.hidden = YES;
                                                      _contents = self.dataController.requestResults;
                                                      [self.tableView reloadData];
                                                  }else{
                                                      self.emptyView.hidden = NO;
                                                  }
                                              }else{
                                                  [MDB_UserDefault showNotifyHUDwithtext:describle inView:self.view];
                                              }
    }];
}

- (void)refreshFooter{
    [self.dataController nextPageDataWithCallback:^(NSError *error, BOOL state, NSString *describle) {
        [self.tableView.mj_footer endRefreshing];
        if (state) {
            _contents = self.dataController.requestResults;
            [self.tableView reloadData];
            [self.tableView.mj_footer endRefreshing];
        }
    }];
}

- (void)refreshHeader{
    [self.dataController lastNewPageDataWithCallback:^(NSError *error, BOOL state, NSString *describle) {
        [self.tableView.mj_header endRefreshing];
        if (state) {
            _contents = self.dataController.requestResults;
            [self.tableView reloadData];
            [self.tableView.mj_header endRefreshing];
        }
    }];
}

#pragma mark - UItableViewDelegate && UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _contents.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    GiftAndTopicTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kTableViewCellIdentifier forIndexPath:indexPath];
    [cell bindDataWithModel:_contents[indexPath.row]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 138;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *discountID = [NSString nullToString:_contents[indexPath.row][@"id"]];
    if ([@"" isEqualToString:discountID]) return;
    ProductInfoViewController *vc = [[ProductInfoViewController alloc] init];
    vc.productId = discountID;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - setters and getters
- (SendGiftDataController *)dataController{
    if (!_dataController) {
        _dataController = [[SendGiftDataController alloc] init];
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
