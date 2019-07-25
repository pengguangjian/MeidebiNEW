//
//  ExchangeSubjectView.m
//  Meidebi
//
//  Created by mdb-admin on 2016/11/7.
//  Copyright © 2016年 meidebi. All rights reserved.
//

#import "ExchangeSubjectView.h"
#import "RecordTableViewCell.h"
#import <MJRefresh/MJRefresh.h>

@interface ExchangeSubjectView ()
<
UITableViewDelegate,
UITableViewDataSource
>
@property (nonatomic, strong) UIView *emptyWarnView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *recods;

@end

@implementation ExchangeSubjectView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupSubViews];
    }
    return self;
}

- (void)setupSubViews{
    UITableView *tableView = [UITableView new];
    [self addSubview:tableView];
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    UIView *footerView = [UIView new];
    footerView.backgroundColor = [UIColor whiteColor];
    [tableView setTableFooterView:footerView];
    tableView.delegate = self;
    tableView.dataSource = self;
    [tableView registerClass:[RecordTableViewCell class] forCellReuseIdentifier:@"cell"];
    tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        if ([self.delegate respondsToSelector:@selector(subjectsViewWithPullupTableview)]) {
            [self.delegate subjectsViewWithPullupTableview];
        }
    }];
    tableView.mj_header = [MJRefreshStateHeader headerWithRefreshingBlock:^{
        if ([self.delegate respondsToSelector:@selector(subjectsViewWithPullDownTableview)]) {
            [self.delegate subjectsViewWithPullDownTableview];
        }
    }];
    _tableView = tableView;
    
    _emptyWarnView = [UIView new];
    [self addSubview:_emptyWarnView];
    [_emptyWarnView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    _emptyWarnView.backgroundColor = [UIColor whiteColor];
    _emptyWarnView.hidden = YES;
    
    UIImageView *warnImageView = [UIImageView new];
    [_emptyWarnView addSubview:warnImageView];
    [warnImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(_emptyWarnView);
        make.size.mas_equalTo(CGSizeMake(100, 100));
    }];
    warnImageView.contentMode = UIViewContentModeScaleAspectFit;
    warnImageView.image = [UIImage imageNamed:@"img_no_reading"];
    
    UILabel *warnLabel = [UILabel new];
    [_emptyWarnView addSubview:warnLabel];
    [warnLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(warnImageView.mas_centerX);
        make.top.equalTo(warnImageView.mas_bottom).offset(24);
    }];
    warnLabel.font = [UIFont systemFontOfSize:16.f];
    warnLabel.textColor = [UIColor colorWithHexString:@"#666666"];
    warnLabel.text = @"您还没有兑换记录哦~";
}

- (void)bindDataWithModel:(NSArray *)model{
    [_tableView.mj_footer endRefreshing];
    [_tableView.mj_header endRefreshing];
    self.recods = model;
}

#pragma mark - UITableViewDelegate & UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.recods.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    RecordTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.recordDict = self.recods[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}

#pragma mark - setters
- (void)setRecods:(NSArray *)recods{
    _recods = recods;
    if (recods.count<=0) {
        _emptyWarnView.hidden = NO;
    }else{
        _emptyWarnView.hidden = YES;
        [_tableView reloadData];
    }
}
@end
