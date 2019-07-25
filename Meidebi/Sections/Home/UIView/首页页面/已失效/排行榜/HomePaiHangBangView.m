//
//  HomePaiHangBangView.m
//  Meidebi
//
//  Created by mdb-losaic on 2018/3/23.
//  Copyright © 2018年 meidebi. All rights reserved.
//

#import "HomePaiHangBangView.h"
#import "NJScrollTableView.h"
#import "TrendTableViewController.h"
#import "ProductInfoViewController.h"
#import <AlibcTradeSDK/AlibcTradeSDK/AlibcTradeSDK.h>

#import "ProductInfoViewController.h"


#import "TrendTableViewCell.h"
#import "TrendDataController.h"
#import "MDBEmptyView.h"
#import "MDB_UserDefault.h"
#import <MJRefresh.h>
static NSString * const kTableViewCellIdentifier = @"cell";

@interface HomePaiHangBangView ()
<
TrendTableViewCellDelegate,
UITableViewDelegate,
UITableViewDataSource

>

@property (nonatomic, strong) NSArray *vcs;
@property (nonatomic , retain)UITableView *tabView;
@property (nonatomic, assign) TableViewTrendType trendType;
@property (nonatomic, strong) NSArray *contents;
@property (nonatomic, strong) TrendDataController *dataController;
@property (nonatomic, strong) MDBEmptyView *emptyView;


@end

@implementation HomePaiHangBangView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self setupSubViews];
        
    }
    return self;
}

- (void)setupSubViews{
    self.tabView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height)];
    [self.tabView setDelegate:self];
    [self.tabView setDataSource:self];
    self.tabView.estimatedRowHeight = 0;
    self.tabView.estimatedSectionFooterHeight = 0;
    self.tabView.estimatedSectionHeaderHeight = 0;
    [self.tabView registerClass:[TrendTableViewCell class] forCellReuseIdentifier:kTableViewCellIdentifier];
    self.tabView.tableFooterView = [UIView new];
    [self loadData];
    self.tabView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self loadData];
    }];
    
    [self addSubview:self.tabView];
    
}

- (void)loadData{
    if(self.dataController == nil)
    {
        self.dataController = [[TrendDataController alloc] init];
    }
    [self.dataController requestTrendListInView:self
                                           type:[NSString stringWithFormat:@"%@",@(4)]
                                       callback:^(NSError *error, BOOL state, NSString *describle) {
                                           [self.tabView.mj_header endRefreshing];
                                           if (state) {
                                               if (self.dataController.requestResults.count > 0) {
                                                   self.emptyView.hidden = YES;
                                                   [self renderSubjectView];
                                               }else{
                                                   self.emptyView.hidden = NO;
                                               }
                                           }else{
                                               self.emptyView.hidden = NO;
                                               [MDB_UserDefault showNotifyHUDwithtext:describle inView:self];
                                           }
                                       }];
}

- (void)renderSubjectView{
    NSMutableArray *results = [NSMutableArray array];
    for (NSDictionary *dict in self.dataController.requestResults) {
        NSMutableDictionary *mutableDict = [NSMutableDictionary dictionaryWithDictionary:dict];
//        [mutableDict setObject:[NSString stringWithFormat:@"%@",@(4)] forKey:@"type"];
        [mutableDict setObject:[NSNumber numberWithBool:NO] forKey:@"isSelect"];
        [results addObject:mutableDict.mutableCopy];
    }
    _contents = results.mutableCopy;
    [self.tabView reloadData];
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
    
    ProductInfoViewController *vc = [[ProductInfoViewController alloc] init];
    vc.productId = [NSString nullToString:_contents[indexPath.row][@"id"]];
    [self.viewController.navigationController pushViewController:vc animated:YES];
    [tableView reloadData];
}

- (void)tableViewCellDidHandleCouponWithCell:(TrendTableViewCell *)cell
{
    NSIndexPath *path = [self.tabView indexPathForCell:cell];
    [self openCouponWithUrl:[NSString nullToString:_contents[path.row][@"url"]]];
}

- (void)openCouponWithUrl:(NSString *)url{
    if ([@"" isEqualToString:url]) return;
    id<AlibcTradePage> page = [AlibcTradePageFactory page:url];
    id<AlibcTradeService> service = [AlibcTradeSDK sharedInstance].tradeService;
    AlibcTradeShowParams *showParams = [[AlibcTradeShowParams alloc] init];
    showParams.openType = AlibcOpenTypeNative;
    showParams.linkKey = @"taobao";
    [service show:self.viewController
             page:page
       showParams:showParams
      taoKeParams:nil
       trackParam:nil
tradeProcessSuccessCallback:^(AlibcTradeResult * _Nullable result) {
} tradeProcessFailedCallback:^(NSError * _Nullable error) {
}];
}

#pragma mark - getter / setter

- (MDBEmptyView *)emptyView{
    if (!_emptyView) {
        _emptyView = [[MDBEmptyView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenW, kMainScreenH-50)];
        [self.tabView addSubview:_emptyView];
        _emptyView.remindStr = @"暂时还没有数据哦～";
        _emptyView.hidden = YES;
    }
    return _emptyView;
}

@end
