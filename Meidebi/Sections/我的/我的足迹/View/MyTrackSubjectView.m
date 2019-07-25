//
//  MyTrackSubjectView.m
//  Meidebi
//
//  Created by ZlJ_losaic on 2017/9/8.
//  Copyright © 2017年 meidebi. All rights reserved.
//

#import "MyTrackSubjectView.h"
#import "TYCyclePagerView.h"
#import "TYPageControl.h"
#import "BestShareCollectionViewCell.h"
#import "MDB_UserDefault.h"
#import <MJRefresh/MJRefresh.h>
#import "MDBEmptyView.h"
static NSString * const kTableViewCellIdentifier = @"TrackTableViewCell";
static NSString * const kColectionCellIdentifier = @"cellID";

@interface MyTrackSubjectView ()
<
UITableViewDelegate,
UITableViewDataSource,
TYCyclePagerViewDataSource,
TYCyclePagerViewDelegate
>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIImageView *avaterImageView;
@property (nonatomic, strong) UIView *bannerView;
@property (nonatomic, strong) UILabel *userNameLabel;
@property (nonatomic, strong) UILabel *userInfoDescribleLabel;
@property (nonatomic, strong) TYCyclePagerView *pagerView;
@property (nonatomic, strong) TYPageControl *pageControl;
@property (nonatomic, strong) MDBEmptyView *emptyView;
@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) NSArray *bestShares;
@property (nonatomic, strong) NSArray *tracks;
@end

@implementation MyTrackSubjectView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupSubviews];
    }
    return self;
}

- (void)setupSubviews{
    self.hidden = YES;
    _tableView = [UITableView new];
    [self addSubview:_tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    _tableView.backgroundColor = [UIColor colorWithHexString:@"#F7F7F7"];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_tableView registerClass:[TrackTableViewCell class] forCellReuseIdentifier:kTableViewCellIdentifier];
    _tableView.tableFooterView = [UIView new];
    _tableView.estimatedSectionHeaderHeight = 0;
    _tableView.estimatedSectionFooterHeight = 0;
    _tableView.estimatedRowHeight = 0;
    [self setupTableHeaderView];
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

- (void)setupTableHeaderView{
    UIView *headerView = [UIView new];
    headerView.backgroundColor = [UIColor colorWithHexString:@"#F7F7F7"];
    _tableView.tableHeaderView = headerView;
    _headerView = headerView;
    _headerView.hidden = YES;
    
    UIView *userInfoContainerView = [UIView new];
    [headerView addSubview:userInfoContainerView];
    [userInfoContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(headerView);
        make.height.offset(90*kScale);
    }];
    userInfoContainerView.backgroundColor = [UIColor colorWithHexString:@"#FFF7F2"];
    _avaterImageView = [UIImageView new];
    [userInfoContainerView addSubview:_avaterImageView];
    [_avaterImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(userInfoContainerView.mas_left).offset(20);
        make.centerY.equalTo(userInfoContainerView.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(60*kScale, 60*kScale));
    }];
    _avaterImageView.userInteractionEnabled = YES;
    _avaterImageView.layer.masksToBounds = YES;
    _avaterImageView.layer.cornerRadius = (60*kScale)/2;
    
    _userNameLabel = [UILabel new];
    [userInfoContainerView addSubview:_userNameLabel];
    [_userNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_avaterImageView.mas_right).offset(10);
        make.bottom.equalTo(userInfoContainerView.mas_centerY).offset(-4);
    }];
    _userNameLabel.textColor = [UIColor colorWithHexString:@"#333333"];
    _userNameLabel.font = [UIFont systemFontOfSize:14.f];
    
    _userInfoDescribleLabel = [UILabel new];
    [userInfoContainerView addSubview:_userInfoDescribleLabel];
    [_userInfoDescribleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_avaterImageView.mas_right).offset(10);
        make.top.equalTo(userInfoContainerView.mas_centerY).offset(4);
        make.right.equalTo(userInfoContainerView.mas_right).offset(-10);
    }];
    _userInfoDescribleLabel.numberOfLines = 0;
    _userInfoDescribleLabel.textColor = [UIColor colorWithHexString:@"#999999"];
    _userInfoDescribleLabel.font = [UIFont systemFontOfSize:14.f];
    
    UIView *lineView = [UIView new];
    [headerView addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(headerView);
        make.top.equalTo(userInfoContainerView.mas_bottom);
        make.height.offset(8);
    }];
    lineView.backgroundColor = [UIColor colorWithHexString:@"#EAEAEA"];
    
    UIView *bannerView = [UIView new];
    [headerView addSubview:bannerView];
    [bannerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lineView.mas_bottom);
        make.left.right.equalTo(headerView);
        make.height.offset(216);
    }];
    bannerView.backgroundColor = headerView.backgroundColor;
    bannerView.hidden = YES;
    _bannerView = bannerView;
    
    UILabel *titleLabel = [UILabel new];
    [bannerView addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(bannerView.mas_centerX);
        make.top.equalTo(bannerView.mas_top).offset(20);
    }];
    titleLabel.font = [UIFont systemFontOfSize:14.f];
    titleLabel.textColor = [UIColor colorWithHexString:@"#333333"];
    titleLabel.text = @"90%的比友都喜欢";
    
    UIView *leftLineView = [UIView new];
    [bannerView addSubview:leftLineView];
    [leftLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(titleLabel.mas_centerY);
        make.right.equalTo(titleLabel.mas_left).offset(-8);
        make.size.mas_equalTo(CGSizeMake(16, 1));
    }];
    leftLineView.backgroundColor = [UIColor colorWithHexString:@"#333333"];
    
    UIView *rightLineView = [UIView new];
    [bannerView addSubview:rightLineView];
    [rightLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(titleLabel.mas_centerY);
        make.left.equalTo(titleLabel.mas_right).offset(8);
        make.size.mas_equalTo(CGSizeMake(16, 1));
    }];
    rightLineView.backgroundColor = [UIColor colorWithHexString:@"#333333"];
    
    TYCyclePagerView *pagerView = [[TYCyclePagerView alloc]init];
    [bannerView addSubview:pagerView];
    [pagerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(bannerView);
        make.top.equalTo(titleLabel.mas_bottom).offset(20);
    }];
    pagerView.isInfiniteLoop = YES;
    pagerView.autoScrollInterval = 5.0;
    pagerView.dataSource = self;
    pagerView.delegate = self;
    [pagerView registerClass:[BestShareCollectionViewCell class] forCellWithReuseIdentifier:kColectionCellIdentifier];
    pagerView.backgroundColor = [UIColor clearColor];
    _pagerView = pagerView;
    [self addPageControl];
    
    UIView *line1View = [UIView new];
    [headerView addSubview:line1View];
    [line1View mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(headerView);
        make.top.equalTo(bannerView.mas_bottom);
        make.height.offset(8);
        make.bottom.equalTo(headerView.mas_bottom).offset(-10);
    }];
    line1View.backgroundColor = [UIColor colorWithHexString:@"#EAEAEA"];
    
    
    [self layoutIfNeeded];
    CGFloat height = [headerView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
    CGRect frame = headerView.frame;
    frame.size.height = height;
    headerView.frame =frame;
    _tableView.tableHeaderView = headerView;
}

- (void)addPageControl {
    TYPageControl *pageControl = [[TYPageControl alloc]init];
    [_pagerView addSubview:pageControl];
    [pageControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_pagerView.mas_bottom).offset(-10);
        make.left.right.equalTo(_pagerView);
        make.height.offset(26);
    }];
    pageControl.currentPageIndicatorSize = CGSizeMake(8, 8);
    pageControl.currentPageIndicatorTintColor = [UIColor colorWithHexString:@"#FF6A03"];
    pageControl.pageIndicatorTintColor = [UIColor colorWithHexString:@"#515151"];
    _pageControl = pageControl;
}

- (void)bindBannerDataWithModel:(NSDictionary *)model{
    if (![model isKindOfClass:[NSDictionary class]]) return;
    self.hidden = NO;
    _bannerView.hidden = NO;
    _headerView.hidden = NO;
    [[MDB_UserDefault defaultInstance] setViewWithImage:_avaterImageView url:[NSString nullToString:model[@"photo"]]];
    _userNameLabel.text = [NSString nullToString:model[@"username"]];
    _userInfoDescribleLabel.text = [NSString stringWithFormat:@"使用没得比%@天，积累足迹%@条",[NSString nullToString:model[@"regDay"] preset:@"0"],[NSString nullToString:model[@"count"] preset:@"0"]];
    _bestShares = model[@"bestShare"];
    _pageControl.numberOfPages = _bestShares.count;
    [_pagerView reloadData];
    [_pagerView setNeedUpdateLayout];
}

- (void)bindTrackDataWithModel:(NSArray *)models{
    self.hidden = NO;
    if (models.count <= 0) {
        self.emptyView.hidden = NO;
        return;
    }else{
        self.emptyView.hidden = YES;
    }
    _tracks = models;
    [_tableView reloadData];
}

- (void)updateTrackDataWithModel:(NSArray *)models{
    self.hidden = NO;
    [_tableView.mj_header endRefreshing];
    [_tableView.mj_footer endRefreshing];
    if (models.count <= 0) {
        self.emptyView.hidden = NO;
        return;
    }else{
        self.emptyView.hidden = YES;
    }
    _tracks = models;
    [_tableView reloadData];
}


- (void)lastPage{
    if ([self.delegate respondsToSelector:@selector(lastPage)]) {
        [self.delegate lastPage];
    }
}

- (void)nextPage{
    if ([self.delegate respondsToSelector:@selector(nextPage)]) {
        [self.delegate nextPage];
    }
}

#pragma mark - UITableView Datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _tracks.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [(TrackViewModel *)_tracks[section] events].count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TrackTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kTableViewCellIdentifier];
    cell.backgroundColor = [UIColor colorWithHexString:@"#F7F7F7"];
    TrackViewModel *model = (TrackViewModel *)_tracks[indexPath.section];
    if (indexPath.row == 0 ||
        [(TrackEventModel *)model.events[indexPath.row] type] == TrackEventTypeBeginUse) {
        [cell bindTimeDataWithContent:model.time];
    }else{
        [cell bindTimeDataWithContent:nil];
    }
    [cell bindDataWithModel:model.events[indexPath.row]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [(TrackEventModel *)[(TrackViewModel *)_tracks[indexPath.section] events][indexPath.row] height];
}
#pragma mark - UITableView Delegate methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    TrackEventModel *model = (TrackEventModel *)[(TrackViewModel *)_tracks[indexPath.section] events][indexPath.row];
    if (model.type == TrackEventTypeShowdan) {
        if ([self.delegate respondsToSelector:@selector(tableViewCellSelectShowdanRow:)]) {
            [self.delegate tableViewCellSelectShowdanRow:model.trackID];
        }
    }else if (model.type == TrackEventTypeDiscount ||
              model.type == TrackEventTypeHaveBy ||
              model.type == TrackEventTypeWantBy){
        if ([self.delegate respondsToSelector:@selector(tableViewCellSelectDiscountRow:)]) {
            [self.delegate tableViewCellSelectDiscountRow:model.trackID];
        }
    }
}

#pragma mark - TYCyclePagerViewDataSource

- (NSInteger)numberOfItemsInPagerView:(TYCyclePagerView *)pageView {
    return _bestShares.count;
}

- (UICollectionViewCell *)pagerView:(TYCyclePagerView *)pagerView cellForItemAtIndex:(NSInteger)index {
    BestShareCollectionViewCell *cell = [pagerView dequeueReusableCellWithReuseIdentifier:kColectionCellIdentifier forIndex:index];
    cell.backgroundColor = [UIColor clearColor];
    [cell bindDataWithModel:_bestShares[index]];
    return cell;
}

- (TYCyclePagerViewLayout *)layoutForPagerView:(TYCyclePagerView *)pageView {
    TYCyclePagerViewLayout *layout = [[TYCyclePagerViewLayout alloc]init];
    layout.itemSize = CGSizeMake(CGRectGetWidth(pageView.frame), CGRectGetHeight(pageView.frame));
    layout.itemHorizontalCenter = YES;
    return layout;
}

- (void)pagerView:(TYCyclePagerView *)pageView didScrollFromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex {
    _pageControl.currentPage = toIndex;
}

- (void)pagerView:(TYCyclePagerView *)pageView didSelectedItemCell:(__kindof UICollectionViewCell *)cell atIndex:(NSInteger)index{
    if ([self.delegate respondsToSelector:@selector(bannerTableViewCellSelectDiscountRow:)]) {
        [self.delegate bannerTableViewCellSelectDiscountRow:[NSString nullToString:_bestShares[index][@"id"]]];
    }
}

#pragma mark - setter and getter
- (MDBEmptyView *)emptyView{
    if (!_emptyView) {
        [self layoutIfNeeded];
        _emptyView = [[MDBEmptyView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(_headerView.frame)-10, kMainScreenW, kMainScreenH-CGRectGetHeight(_headerView.frame))];
        [self.tableView addSubview:_emptyView];
        _emptyView.remindStr = @"暂时还没有数据哦～";
        _emptyView.hidden = YES;
    }
    return _emptyView;
}
@end
