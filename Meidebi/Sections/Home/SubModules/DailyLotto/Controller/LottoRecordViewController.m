//
//  LottoRecordViewController.m
//  Meidebi
//
//  Created by ZlJ_losaic on 2017/8/30.
//  Copyright © 2017年 meidebi. All rights reserved.
//

#import "LottoRecordViewController.h"
#import "LottoRecordTableViewCell.h"
#import "DailyLottoDataController.h"
#import "MDB_UserDefault.h"
#import <MJRefresh/MJRefresh.h>
static NSString * kTableViewCellIdentifier = @"cell";
static CGFloat kTableViewSectionHeaderHeight = 85.f;
//static CGFloat kTableViewSectionFooterHeight = 13.f;
static CGFloat kTableViewSectionRowHeight = 51.f;

@interface LottoRecordViewController ()
@property (nonatomic, strong) DailyLottoDataController *datacontroller;
@property (nonatomic, strong) NSArray *records;
@end

@implementation LottoRecordViewController

#pragma mark - def

#pragma mark - override

- (void)viewDidLoad{
    [super viewDidLoad];
    self.navigationItem.title = @"抽奖记录";
    [self setupSubviews];
    [self loadData];
}

#pragma mark - private method
- (void)setupSubviews{
    [self.tableView registerClass:[LottoRecordTableViewCell class]
           forCellReuseIdentifier:kTableViewCellIdentifier];
    self.tableView.separatorColor = [UIColor colorWithHexString:@"#E4E4E4"];
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

- (UIView *)setupTableSectionHeaderViewWithSection:(NSInteger)section{
    UIView *tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenW, kTableViewSectionHeaderHeight)];
    tableHeaderView.backgroundColor = [UIColor whiteColor];
    
    UIImageView *iconImageView = [UIImageView new];
    [tableHeaderView addSubview:iconImageView];
    [iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(tableHeaderView.mas_left).offset(15);
        make.top.equalTo(tableHeaderView.mas_top).offset(13);
        make.size.mas_equalTo(CGSizeMake(15, 14));
    }];
    iconImageView.image = [UIImage imageNamed:@"lotto_record_calendar"];
    UILabel *dateLabel = [UILabel new];
    [tableHeaderView addSubview:dateLabel];
    [dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(iconImageView.mas_centerY);
        make.left.equalTo(iconImageView.mas_right).offset(6);
    }];
    dateLabel.font = [UIFont systemFontOfSize:12.f];
    dateLabel.textColor = [UIColor colorWithHexString:@"#999999"];
    dateLabel.text = [NSString nullToString:_records[section][@"time"]];
    
    UIView *topLineView = [UIView new];
    [tableHeaderView addSubview:topLineView];
    [topLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(tableHeaderView);
        make.top.equalTo(iconImageView.mas_bottom).offset(13);
        make.height.offset(1);
    }];
    topLineView.backgroundColor = [UIColor colorWithHexString:@"#D7D7D7"];
    
    UIView *titleBgView = [UIView new];
    [tableHeaderView addSubview:titleBgView];
    [titleBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(tableHeaderView);
        make.top.equalTo(topLineView.mas_bottom);
        make.bottom.equalTo(tableHeaderView.mas_bottom).offset(-1);
    }];
    titleBgView.backgroundColor = [UIColor colorWithHexString:@"#F7F7F7"];
    
    UIView *bottomLineView = [UIView new];
    [tableHeaderView addSubview:bottomLineView];
    [bottomLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(tableHeaderView);
        make.bottom.equalTo(tableHeaderView.mas_bottom);
        make.height.offset(1);
    }];
    bottomLineView.backgroundColor = [UIColor colorWithHexString:@"#D7D7D7"];
    
    UILabel *dateDetailTitleLabel = [UILabel new];
    [titleBgView addSubview:dateDetailTitleLabel];
    [dateDetailTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(titleBgView.mas_centerY);
        make.left.equalTo(titleBgView.mas_left).offset(45*kScale);
    }];
    dateDetailTitleLabel.textColor = [UIColor colorWithHexString:@"#333333"];
    dateDetailTitleLabel.font = [UIFont systemFontOfSize:12.f];
    dateDetailTitleLabel.text = @"时间";
    
    UILabel *prizeNameLabel = [UILabel new];
    [titleBgView addSubview:prizeNameLabel];
    [prizeNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(titleBgView);
    }];
    prizeNameLabel.textColor = [UIColor colorWithHexString:@"#333333"];
    prizeNameLabel.font = [UIFont systemFontOfSize:12.f];
    prizeNameLabel.text = @"奖品名称";
    
    UILabel *prizeStateLabel = [UILabel new];
    [titleBgView addSubview:prizeStateLabel];
    [prizeStateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(titleBgView.mas_centerY);
        make.right.equalTo(titleBgView.mas_right).offset(-45*kScale);
    }];
    prizeStateLabel.textColor = [UIColor colorWithHexString:@"#333333"];
    prizeStateLabel.font = [UIFont systemFontOfSize:12.f];
    prizeStateLabel.text = @"状态";
    
    return tableHeaderView;
}
- (void)loadData{
    [self.datacontroller requestLottoRecordListDataWithInView:self.view
                                                     callback:^(NSError *error, BOOL state, NSString *describle) {
                                                         if (state) {
                                                             _records = self.datacontroller.requestResults;
                                                             [self.tableView reloadData];
                                                         }else{
                                                             [MDB_UserDefault showNotifyHUDwithtext:describle inView:self.view];
                                                         }
    }];
}

#pragma mark - events
- (void)lastPage{
    [self.datacontroller lastNewPageDataWithCallback:^(NSError *error, BOOL state, NSString *describle) {
        _records = self.datacontroller.requestResults;
        [self.tableView.mj_header endRefreshing];
        [self.tableView reloadData];
    }];
}

- (void)nextPage{
    [self.datacontroller nextPageDataWithCallback:^(NSError *error, BOOL state, NSString *describle) {
        _records = self.datacontroller.requestResults;
        [self.tableView.mj_footer endRefreshing];
        [self.tableView reloadData];
    }];
}

#pragma mark - UITableView Datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _records.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_records[section][@"record"] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LottoRecordTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kTableViewCellIdentifier];
    [cell bindDataWithModel:_records[indexPath.section][@"record"][indexPath.row]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return kTableViewSectionRowHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return kTableViewSectionHeaderHeight;
}

////- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
////    if (section == _records.count-1) {
////        return 0;
////    }
////    return kTableViewSectionFooterHeight;
////}
//
//- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
//    UIView *tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenW, kTableViewSectionFooterHeight)];
//    tableFooterView.backgroundColor = [UIColor colorWithHexString:@"#F5F5F5"];
//    return tableFooterView;
//}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return [self setupTableSectionHeaderViewWithSection:section];
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

#pragma mark - UIScrollViewDelegate

//- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
//    if ([scrollView isKindOfClass:[UITableView class]]) {
//        //固定头部视图
//        if (scrollView.contentOffset.y<=kTableViewSectionHeaderHeight&&scrollView.contentOffset.y>=0) {
//            scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
//        } else if (scrollView.contentOffset.y>=kTableViewSectionHeaderHeight) {
//            scrollView.contentInset = UIEdgeInsetsMake(-kTableViewSectionHeaderHeight, 0, 0, 0);
//        }
//    }
//    if ([scrollView isKindOfClass:[UITableView class]]) {
//        //固定头部和尾部视图
//        CGFloat sectionHeaderHeight = kTableViewSectionHeaderHeight;
//        CGFloat sectionFooterHeight = kTableViewSectionFooterHeight;
//        CGFloat offsetY = scrollView.contentOffset.y;
//        if (offsetY >= -50 && offsetY <= sectionHeaderHeight)
//        {
//            scrollView.contentInset = UIEdgeInsetsMake(-offsetY, 0, -sectionFooterHeight, 0);
//        }else if (offsetY >= sectionHeaderHeight && offsetY <= scrollView.contentSize.height - scrollView.frame.size.height - sectionFooterHeight)
//        {
//            scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, -sectionFooterHeight, 0);
//        }else if (offsetY >= scrollView.contentSize.height - scrollView.frame.size.height - sectionFooterHeight && offsetY <= scrollView.contentSize.height - scrollView.frame.size.height)
//        {
//            scrollView.contentInset = UIEdgeInsetsMake(-offsetY, 0, -(scrollView.contentSize.height - scrollView.frame.size.height - sectionFooterHeight), 0);
//        }
//    }
//}
//// 固定footer
//- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
//    if ([scrollView isKindOfClass:[UITableView class]]) {
//        CGFloat sectionFooterHeight = kTableViewSectionFooterHeight;
//        CGFloat ButtomHeight = scrollView.contentSize.height - self.tableView.frame.size.height;
//        if (ButtomHeight-sectionFooterHeight <= scrollView.contentOffset.y && scrollView.contentSize.height > -64) {
//            scrollView.contentInset = UIEdgeInsetsMake(64, 0, 0, 0);
//        } else  {
//            scrollView.contentInset = UIEdgeInsetsMake(64, 0, -(sectionFooterHeight), 0);
//        }
//    }
//}

#pragma mark - getter / setter
- (DailyLottoDataController *)datacontroller{
    if (!_datacontroller) {
        _datacontroller = [[DailyLottoDataController alloc] init];
    }
    return _datacontroller;
}

@end
