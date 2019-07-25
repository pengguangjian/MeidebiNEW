//
//  HomeGuanZhuDongTaiView.m
//  Meidebi
//
//  Created by mdb-losaic on 2018/3/23.
//  Copyright © 2018年 meidebi. All rights reserved.
//

#import "HomeGuanZhuDongTaiView.h"
#import "LastNewsTableViewCell.h"
#import "LastOriginalNewsTableViewCell.h"
#import <MJRefresh/MJRefresh.h>
#import "HomeDataController.h"
#import "MDBEmptyView.h"
#import "MDB_UserDefault.h"

#import "ProductInfoViewController.h"

#import "SpecialInfoViewController.h"

#import "OriginalDetailViewController.h"

#import "GMDCircleLoader.h"

static NSString * const kTableViewCellIdentifier = @"cell";
static NSString * const kTableViewOriginalCellIdentifier = @"originalcell";

@interface HomeGuanZhuDongTaiView ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, assign) BOOL canScroll;
@property (nonatomic, assign) BOOL isCanCallback;
@property (nonatomic, assign) CGFloat tableContentMaxSetOff;
@property (nonatomic, assign) CGFloat lastContentOffSet;
@property (nonatomic, strong) NSArray *models;
@property (nonatomic, strong) HomeDataController *datacontroller;
@property (nonatomic, strong) MDBEmptyView *emptyView;
@end


@implementation HomeGuanZhuDongTaiView

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
        [self emptyView];
        _datacontroller = [[HomeDataController alloc] init];
        _isCanCallback = YES;
        [self loadData];
        
    }
    return self;
}
-(void)loadrefdata
{
    if(_models.count<1)
    {
        [self loadData];
    }
}
- (void)setupSubViews
{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height)];
    [self.tableView setDelegate:self];
    [self.tableView setDataSource:self];
    [self addSubview:self.tableView];
    [self.tableView registerClass:[LastNewsTableViewCell class] forCellReuseIdentifier:kTableViewCellIdentifier];
    [self.tableView registerClass:[LastOriginalNewsTableViewCell class] forCellReuseIdentifier:kTableViewOriginalCellIdentifier];
    self.tableView.tableFooterView = [UIView new];
    self.tableView.separatorColor = [UIColor colorWithHexString:@"#E7E7E7"];
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        _isCanCallback = NO;
        [self nextPage];
    }];
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        _isCanCallback = NO;
        [self loadData];
    }];
}

- (void)loadData{
    
    [GMDCircleLoader setOnView:self withTitle:nil animated:YES];
    [self.datacontroller requestMainTranisListCallback:^(NSError *error, BOOL state, NSString *describle) {
        if (state) {
            [self renderTableView:NO];
        }
        else
        {
            if (_models.count > 0) {
                self.emptyView.hidden = YES;
                [self.tableView reloadData];
            }else{
                self.emptyView.hidden = NO;
            }
        }
        [self.tableView.mj_header endRefreshing];
        [GMDCircleLoader hideFromView:self animated:YES];
    }];
}

- (void)renderTableView:(BOOL)isRefresh{
    NSMutableArray *temps = [NSMutableArray array];
    @try
    {
        for (NSDictionary *dict in self.datacontroller.requestResults) {
            LastNewsModel *model = [LastNewsModel viewModelWithSubject:dict];
            if (model) {
                [temps addObject:model];
            }
        }
    }
    @finally
    {
        
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
    if(_models.count>0)
    {
        if (_isCanCallback) {
            [self.delegate latesNewsTableViewWihtFirstRow:[(LastNewsModel *)_models.firstObject newsID]];
            NSLog(@"未知");
        }else{
            [MDB_UserDefault setHotLastNewID:[(LastNewsModel *)_models.firstObject newsID].integerValue];
        }
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    LastNewsModel *model = _models[indexPath.row];
    model.isSelect = YES;
    [tableView reloadData];
    if ([(LastNewsModel *)_models[indexPath.row] style] == NewsTypeDiscount) {
        ProductInfoViewController *productInfoVc = [[ProductInfoViewController alloc] init];
        productInfoVc.productId = [NSString nullToString:[(LastNewsModel *)_models[indexPath.row] newsID]];
        [self.viewController.navigationController pushViewController:productInfoVc animated:YES];
        
    }else if ([(LastNewsModel *)_models[indexPath.row] style] == NewsTypeSpecial) {
        SpecialInfoViewController *specialInfoVc = [[SpecialInfoViewController alloc] initWithSpecialInfo:[(LastNewsModel *)_models[indexPath.row] newsID]];
        [self.viewController.navigationController pushViewController:specialInfoVc animated:YES];
        
    }else if ([(LastNewsModel *)_models[indexPath.row] style] == NewsTypeOriginal) {
        OriginalDetailViewController *vc = [[OriginalDetailViewController alloc] initWithOriginalID:[(LastNewsModel *)_models[indexPath.row] newsID]];
        [self.viewController.navigationController pushViewController:vc animated:YES];
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [(LastNewsModel *)_models[indexPath.row] rowHeight];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat offsetY = scrollView.contentOffset.y;
    if (offsetY<0) {
        [[NSNotificationCenter defaultCenter] postNotificationName:kLeaveTopNotificationName object:nil userInfo:@{@"canScroll":@"1"}];
    }
}

#pragma mark - getter / setter

- (MDBEmptyView *)emptyView{
    if (!_emptyView) {
        _emptyView = [[MDBEmptyView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenW, kMainScreenH-50)];
        [_tableView addSubview:_emptyView];
        _emptyView.remindStr = @"暂时还没有数据哦～";
        _emptyView.hidden = YES;
    }
    return _emptyView;
}


@end
