//
//  WelfareDynamicSubjectView.m
//  Meidebi
//
//  Created by mdb-admin on 2017/6/26.
//  Copyright © 2017年 meidebi. All rights reserved.
//

#import "WelfareDynamicSubjectView.h"
#import "WelfareDynamicTableViewCell.h"
#import "MDB_UserDefault.h"
#import "ScrollLabel.h"
#import <MJRefresh/MJRefresh.h>
static NSString * const kTabelViewCellIdentifier = @"cell";
@interface WelfareDynamicSubjectView ()
<
UITableViewDataSource,
UITableViewDelegate,
WelfareDynamicTableViewCellDelegate
>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UILabel *adLabel;
@property (nonatomic, strong) UIImageView *adImageView;
@property (nonatomic, strong) NSArray *models;
@property (nonatomic, strong) UIView *adLabelContainerView;
@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) ScrollLabel *paomaLabel;
@property (nonatomic, strong) NSDictionary *adInfoDict;
@end

@implementation WelfareDynamicSubjectView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupSubviews];
    }
    return self;
}

- (void)setupSubviews{
    self.backgroundColor = [UIColor colorWithHexString:@"#F7F7F7"];
    _tableView = [UITableView new];
    [self addSubview:_tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.tableHeaderView = [self setupTableHeaderView];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_tableView registerClass:[WelfareDynamicTableViewCell class] forCellReuseIdentifier:kTabelViewCellIdentifier];
    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        if ([self.delegate respondsToSelector:@selector(welfareDynamicSubjectViewDidRefreshHeader)]) {
            [self.delegate welfareDynamicSubjectViewDidRefreshHeader];
        }
    }];
}

- (UIView *)setupTableHeaderView{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenW, 0)];
    headerView.backgroundColor = [UIColor clearColor];
    _headerView = headerView;
    UIView *adLabelContainerView = [UIView new];
    [headerView addSubview:adLabelContainerView];
    [adLabelContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(headerView);
        make.top.equalTo(headerView.mas_top).offset(8);
        make.height.offset(43);
    }];
    adLabelContainerView.backgroundColor = [UIColor whiteColor];
    _adLabelContainerView = adLabelContainerView;
    _adLabelContainerView.hidden = YES;
    
    _paomaLabel = [[ScrollLabel alloc]initWithFrame:CGRectMake(15, 16, kMainScreenW-65, 14)];
    _paomaLabel.hyk_timeInterval = 20;
    _paomaLabel.hyk_direction = Horizontal;
    _paomaLabel.backgroundColor = [UIColor clearColor];
    [adLabelContainerView addSubview:_paomaLabel];
    
    UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_adLabelContainerView addSubview:closeBtn];
    [closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_paomaLabel.mas_right);
        make.right.top.bottom.equalTo(adLabelContainerView);
    }];
    [closeBtn setImage:[UIImage imageNamed:@"welfare_home_closead"] forState:UIControlStateNormal];
    [closeBtn addTarget:self action:@selector(respondsToBtnEvent:) forControlEvents:UIControlEventTouchUpInside];
    
    _adImageView = [UIImageView new];
    [headerView addSubview:_adImageView];
    [_adImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(headerView);
        make.top.equalTo(adLabelContainerView.mas_bottom);
    }];
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(adImageViewTap:)];
    [_adImageView addGestureRecognizer:tapGesture];
    
    return headerView;
}

- (void)respondsToBtnEvent:(UIButton *)sender{
    [_adLabelContainerView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.offset(0);
    }];
    _paomaLabel.hidden = YES;
    [_paomaLabel hyk_pause];
    CGRect frame = _headerView.frame;
    frame.size.height -= 43;
    _headerView.frame = frame;
    _tableView.tableHeaderView = _headerView;
}

- (void)bindAdDataWithModel:(NSDictionary *)dict{
    if (!dict) return;
    CGFloat headerViewHeight = 0.f;
    _adLabelContainerView.hidden = NO;
    _adImageView.userInteractionEnabled = YES;
    
    _adInfoDict = dict[@"advertise"];
    // 防止后台在没数据时给的数据类型不正常
    if ([[NSString nullToString:dict[@"notice"]] isKindOfClass:[NSString class]]) {
        if (![@"" isEqualToString:dict[@"notice"]]) {
            [_paomaLabel hyk_scrollTitle:[NSString nullToString:dict[@"notice"]]
                           andTitleColor:[UIColor colorWithHexString:@"#999999"]
                            andTitleSize:12];
            headerViewHeight += 43;
        }else{
            [_adLabelContainerView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.offset(0);
            }];
            _paomaLabel.hidden = YES;
            [_paomaLabel hyk_pause];
        }
    }else{
        [_adLabelContainerView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.offset(0);
        }];
        _paomaLabel.hidden = YES;
        [_paomaLabel hyk_pause];
    }
    // 防止后台在没数据时给的数据类型不正常
    if ([dict[@"advertise"] isKindOfClass:[NSDictionary class]]) {
        if (![@"" isEqualToString:[NSString nullToString:_adInfoDict[@"imgurl"]]]) {
            [[MDB_UserDefault defaultInstance] setViewWithImage:_adImageView url:[NSString nullToString:_adInfoDict[@"imgurl"]]];
            headerViewHeight += 149;
        }
    }
    CGRect frame = _headerView.frame;
    frame.size.height = headerViewHeight;
    _headerView.frame = frame;
    _tableView.tableHeaderView = _headerView;
}

- (void)bindDynamicWithModel:(NSArray *)models{
    if (models.count <= 0) return;
    _models = models;
    [_tableView reloadData];
    [_tableView.mj_header endRefreshing];
}

- (void)adImageViewTap:(UIGestureRecognizer *)gesture{
    if ([self.delegate respondsToSelector:@selector(welfareDynamicSubjectViewDidClickAd:)]) {
        [self.delegate welfareDynamicSubjectViewDidClickAd:_adInfoDict];
    }
}

#pragma mark - UITableView Datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _models.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WelfareDynamicTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kTabelViewCellIdentifier];
    [cell bindDataWithModel:_models[indexPath.row]];
    cell.delegate = self;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 77;
}


#pragma mark - UITableView Delegate methods
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

#pragma mark - WelfareDynamicTableViewCellDelegate
- (void)welfareDynamicTableViewDidClickAvaterWithCell:(WelfareDynamicTableViewCell *)cell{
    NSIndexPath *path = [_tableView indexPathForCell:cell];
    if ([self.delegate respondsToSelector:@selector(welfareDynamicSubjectViewDidClickAvater:)]) {
        [self.delegate welfareDynamicSubjectViewDidClickAvater:[NSString nullToString:_models[path.row][@"userid"]]];
    }
}
@end
