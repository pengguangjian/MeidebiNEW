//
//  CheapOrOutsideSubjectsView.m
//  Meidebi
//
//  Created by mdb-admin on 16/5/5.
//  Copyright © 2016年 meidebi. All rights reserved.
//

#import "CheapOrOutsideSubjectsView.h"
#import "ContentCell.h"
#import <MJRefresh/MJRefresh.h>

#import "MDBEmptyView.h"

static NSString *cellIdentifier = @"cell";
@interface CheapOrOutsideSubjectsView ()
<
UITableViewDelegate,
UITableViewDataSource
>
@property (nonatomic, strong) NSArray *commoditys;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) MDBEmptyView *emptyView;

@end

@implementation CheapOrOutsideSubjectsView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupSubViews];
    }
    return self;
}

- (void)setupSubViews{
    [self addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
}

- (void)bindDataWithViewModel:(CheapOrOutsideSubjectsViewModel *)viewModel{
     _commoditys = viewModel.results;
    [_tableView.mj_footer endRefreshing];
    [_tableView.mj_header endRefreshing];
    [_tableView reloadData];
    if (_commoditys.count > 0) {
        self.emptyView.hidden = YES;
        [self.tableView reloadData];
    }else{
        self.emptyView.hidden = NO;
    }
}

- (void)setExtraCellLineHidden: (UITableView *)tableView{
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
}


#pragma mark - UITableView Datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _commoditys.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ContentCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell fetchCommodityData:_commoditys[indexPath.row]];
    return cell;
}

#pragma mark - UITableView Delegate methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.delegate respondsToSelector:@selector(subjectsView:didPressCellWithCommodity:)]) {
        [self.delegate subjectsView:self didPressCellWithCommodity:_commoditys[indexPath.row]];
    }
    [tableView reloadData];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 125;
}

#pragma mark - getters and setters
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerClass:[ContentCell class] forCellReuseIdentifier:cellIdentifier];
        _tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            if ([self.delegate respondsToSelector:@selector(subjectsViewWithPullupTableview)]) {
                [self.delegate subjectsViewWithPullupTableview];
            }
        }];
        _tableView.mj_header = [MJRefreshStateHeader headerWithRefreshingBlock:^{
            if ([self.delegate respondsToSelector:@selector(subjectsViewWithPullDownTableview)]) {
                [self.delegate subjectsViewWithPullDownTableview];
            }
        }];
        [self setExtraCellLineHidden:_tableView];
    }
    return _tableView;
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
