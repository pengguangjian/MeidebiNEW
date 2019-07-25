//
//  LatestNewsViewController.m
//  Meidebi
//  暂未使用
//  Created by ZlJ_losaic on 2017/8/22.
//  Copyright © 2017年 meidebi. All rights reserved.
//

#import "LatestNewsViewController.h"
#import "LastNewsTableViewCell.h"
#import "LastOriginalNewsTableViewCell.h"
#import <MJRefresh/MJRefresh.h>
#import "HomeDataController.h"
#import "MDBEmptyView.h"
#import "MDB_UserDefault.h"
static NSString * const kTableViewCellIdentifier = @"cell";
static NSString * const kTableViewOriginalCellIdentifier = @"originalcell";

@interface LatestNewsViewController ()
@property (nonatomic, assign) BOOL canScroll;
@property (nonatomic, assign) BOOL isCanCallback;
@property (nonatomic, assign) CGFloat tableContentMaxSetOff;
@property (nonatomic, assign) CGFloat lastContentOffSet;
@property (nonatomic, strong) NSArray *models;
@property (nonatomic, strong) HomeDataController *datacontroller;
@property (nonatomic, strong) MDBEmptyView *emptyView;
@end

@implementation LatestNewsViewController

#pragma mark - override

- (void)viewDidLoad{
    [super viewDidLoad];
    [self setupSubviews];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(acceptNotificationMsg:) name:kGoTopNotificationName object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(acceptNotificationMsg:) name:kLeaveTopNotificationName object:nil];//其中一个TAB离开顶部的时候，如果其他几个偏移量不为0的时候，要把他们都置为0
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)updateLatestNewsDataIsCallback:(BOOL)isCall{
    _isCanCallback = isCall;
    [self loadData];
}

#pragma mark - private method
- (void)setupSubviews{
    self.tableView.estimatedRowHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.showsHorizontalScrollIndicator = NO;
    [self.tableView registerClass:[LastNewsTableViewCell class] forCellReuseIdentifier:kTableViewCellIdentifier];
    [self.tableView registerClass:[LastOriginalNewsTableViewCell class] forCellReuseIdentifier:kTableViewOriginalCellIdentifier];
    self.tableView.tableFooterView = [UIView new];
    self.tableView.separatorColor = [UIColor colorWithHexString:@"#E7E7E7"];
    __weak __typeof__(self) weakself = self;
    weakself.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        __strong __typeof__(weakself) strongSelf = weakself;
        [strongSelf nextPage];
    }];
}

- (void)loadData{
    [self.datacontroller requestMainTranisListCallback:^(NSError *error, BOOL state, NSString *describle) {
        if (state) {
            [self renderTableView:NO];
        }
    }];
}

- (void)renderTableView:(BOOL)isRefresh{
    NSMutableArray *temps = [NSMutableArray array];
    for (NSDictionary *dict in self.datacontroller.requestResults) {
        LastNewsModel *model = [LastNewsModel viewModelWithSubject:dict];
        if (model) {
            [temps addObject:model];
        }
    }
    _models = temps.mutableCopy;
    if (isRefresh) {
        [self.tableView reloadData];
    }else{
        if (_models.count > 0) {
            self.emptyView.hidden = YES;
            [self.tableView reloadData];
        }else{
            self.emptyView.hidden = NO;
        }
    }
    if (_isCanCallback) {
        if ([self.delegate respondsToSelector:@selector(latesNewsTableViewWihtFirstRow:)]) {
            [self.delegate latesNewsTableViewWihtFirstRow:[(LastNewsModel *)_models.firstObject newsID]];
        }
    }else{
        [MDB_UserDefault setHotLastNewID:[(LastNewsModel *)_models.firstObject newsID].integerValue];
    }
    
}

-(void)acceptNotificationMsg:(NSNotification *)notification{
    NSString *notificationName = notification.name;
    
    if ([notificationName isEqualToString:kGoTopNotificationName]) {
        NSDictionary *userInfo = notification.userInfo;
        NSString *canScroll = userInfo[@"canScroll"];
        if ([canScroll isEqualToString:@"1"]) {
            self.canScroll = YES;
            self.tableView.showsVerticalScrollIndicator = YES;
        }
    }else if([notificationName isEqualToString:kLeaveTopNotificationName]){
        self.tableView.contentOffset = CGPointZero;
        self.canScroll = NO;
        self.tableView.showsVerticalScrollIndicator = NO;
    }
    
}

#pragma mark - events
- (void)nextPage{
   [self.datacontroller nextPageDataWithCallback:^(NSError *error, BOOL state, NSString *describle) {
       if (state) {
           [self renderTableView:YES];
       }
       [self.tableView.mj_footer endRefreshing];
   }];
}

#pragma mark - UITableView Datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _models.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([(LastNewsModel *)_models[indexPath.row] style] == NewsTypeDiscount) {
        LastNewsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kTableViewCellIdentifier];
        [cell bindDataWithModel:_models[indexPath.row]];
        return cell;
    }else{
        LastOriginalNewsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kTableViewOriginalCellIdentifier];
        [cell bindDataWithModel:_models[indexPath.row]];
        return cell;
    }
}

#pragma mark - UITableView Delegate methods
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([(LastNewsModel *)_models[indexPath.row] style] == NewsTypeDiscount) {
        if ([self.delegate respondsToSelector:@selector(latesDiscountNewsTableViewDidSelectRowWithItemID:)]) {
            [self.delegate latesDiscountNewsTableViewDidSelectRowWithItemID:[(LastNewsModel *)_models[indexPath.row] newsID]];
        }
    }else if ([(LastNewsModel *)_models[indexPath.row] style] == NewsTypeSpecial) {
        if ([self.delegate respondsToSelector:@selector(latesSpecialNewsTableViewDidSelectRowWithItemID:)]) {
            [self.delegate latesSpecialNewsTableViewDidSelectRowWithItemID:[(LastNewsModel *)_models[indexPath.row] newsID]];
        }
    }else if ([(LastNewsModel *)_models[indexPath.row] style] == NewsTypeOriginal) {
        if ([self.delegate respondsToSelector:@selector(latesOriginalNewsTableViewDidSelectRowWithItemID:)]) {
            [self.delegate latesOriginalNewsTableViewDidSelectRowWithItemID:[(LastNewsModel *)_models[indexPath.row] newsID]];
        }
    }
  
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [(LastNewsModel *)_models[indexPath.row] rowHeight];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (!self.canScroll) {
        [scrollView setContentOffset:CGPointZero];
    }
    CGFloat offsetY = scrollView.contentOffset.y;
    if (offsetY<0) {
        [[NSNotificationCenter defaultCenter] postNotificationName:kLeaveTopNotificationName object:nil userInfo:@{@"canScroll":@"1"}];
    }
}

#pragma mark - getter / setter
- (HomeDataController *)datacontroller{
    if (!_datacontroller) {
        _datacontroller = [[HomeDataController alloc] init];
    }
    return _datacontroller;
}

- (MDBEmptyView *)emptyView{
    if (!_emptyView) {
        _emptyView = [[MDBEmptyView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenW, kMainScreenH-50)];
        [self.view addSubview:_emptyView];
        _emptyView.remindStr = @"暂时还没有数据哦～";
        _emptyView.hidden = YES;
    }
    return _emptyView;
}
@end
