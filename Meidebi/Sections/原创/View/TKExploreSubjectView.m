//
//  TKExploreSubjectView.m
//  TaokeSecretary
//
//  Created by mdb-losaic on 2018/1/12.
//  Copyright © 2018年 leecool. All rights reserved.
//

#import "TKExploreSubjectView.h"
#import "ImagePlayerView.h"
#import "TKExploreTableViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import <MJRefresh/MJRefresh.h>
#import "TKTopicClassifyView.h"
#import "RecommendedAttentionView.h"
static NSString * const kTabelViewCellIdentifier = @"cell";
@interface TKExploreSubjectView ()
<
UITableViewDelegate,
UITableViewDataSource,
ImagePlayerViewDelegate,
TKTopicClassifyViewDelegate,
TKExploreTableViewCellDelegate,
RecommendedAttentionViewDelegate
>
{
    float flastscroll;
}
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView *tableHeaderView;
@property (nonatomic, strong) ImagePlayerView *bannerView;
@property (nonatomic, strong) TKTopicClassifyView *classifyView;
@property (nonatomic, strong) RecommendedAttentionView *attentionView;
@property (nonatomic, assign) CGFloat bannerViewHeight;
@property (nonatomic, strong) NSArray *banners;
@property (nonatomic, strong) NSArray *topics;
@property (nonatomic, strong) NSArray *followUsers;
@property (nonatomic, strong) UIButton *btzhiding;
@end

@implementation TKExploreSubjectView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self configurUI];
    }
    return self;
}

- (void)configurUI{
    [self addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    [self configurTableHeaderView];
    
    _btzhiding = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50*kScale, 50*kScale)];
    [_btzhiding.layer setMasksToBounds:YES];
    [_btzhiding.layer setCornerRadius:_btzhiding.height/2.0];
    [_btzhiding setRight:BOUNDS_WIDTH-10];
    [_btzhiding setBottom:BOUNDS_HEIGHT+60];
    [_btzhiding setImage:[UIImage imageNamed:@"zhiding_list"] forState:UIControlStateNormal];
    [_btzhiding setBackgroundColor:RGB(248, 248, 248)];
    [self addSubview:_btzhiding];
    [_btzhiding addTarget:self action:@selector(topScrollAction) forControlEvents:UIControlEventTouchUpInside];
    
    
//    UIView *viewpushback = [[UIView alloc] init];
//    [self addSubview:viewpushback];
//    [viewpushback mas_makeConstraints:^(MASConstraintMaker *make) {
//        
//        make.size.sizeOffset(CGSizeMake(BOUNDS_WIDTH*0.45, 45*kScale));
//        make.centerX.equalTo(self.tableView.mas_centerX);
//        make.bottom.equalTo(self.tableView.mas_bottom).offset(-30);
//        
//    }];
//    viewpushback.layer.shadowColor = [UIColor blackColor].CGColor;
//    viewpushback.layer.shadowOffset = CGSizeMake(0, 0);
//    viewpushback.layer.shadowOpacity = 0.5;
//    viewpushback.layer.shadowRadius = 3;
//    viewpushback.clipsToBounds = NO;
//    
//    UIButton *btpushyc = [[UIButton alloc] init];
//    [viewpushback addSubview:btpushyc];
//    [btpushyc mas_makeConstraints:^(MASConstraintMaker *make) {
//       
//        make.edges.equalTo(viewpushback);
//        
//    }];
//    
//    [btpushyc setBackgroundColor:RadMenuColor];
//    [btpushyc setTitle:@"发布原创" forState:UIControlStateNormal];
//    [btpushyc.titleLabel setFont:[UIFont systemFontOfSize:15]];
//    [btpushyc setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    [btpushyc.layer setMasksToBounds:YES];
//    [btpushyc.layer setCornerRadius:2];
//    [btpushyc addTarget:self action:@selector(pushYuanChuanAction) forControlEvents:UIControlEventTouchUpInside];
    
    
    
}

- (void)configurTableHeaderView{
    self.hidden = YES;
    UIView *tableHeaderView = [UIView new];
    self.tableView.tableHeaderView = tableHeaderView;
    _tableHeaderView = tableHeaderView;
    
    _bannerView = [[ImagePlayerView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 0)];
    [tableHeaderView addSubview:_bannerView];
    
//    _attentionView = [RecommendedAttentionView new];
//    [tableHeaderView addSubview:_attentionView];
//    [_attentionView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(_bannerView.mas_bottom);
//        make.left.right.equalTo(tableHeaderView);
//        make.height.offset(145);
//    }];
//    _attentionView.hidden = YES;
//    _attentionView.backgroundColor = [UIColor colorWithHexString:@"#FAFAFA"];
//    _attentionView.delegate = self;
    
    _classifyView = [TKTopicClassifyView new];
    [tableHeaderView addSubview:_classifyView];
    [_classifyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_bannerView.mas_bottom);
        make.left.right.equalTo(tableHeaderView);
        make.height.offset(105*kScale);
    }];
    _classifyView.delegate = self;
    
    UIView *lineView = [UIView new];
    [tableHeaderView addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_classifyView.mas_bottom);
        make.left.right.equalTo(tableHeaderView);
        make.height.offset(10);
        make.bottom.equalTo(tableHeaderView.mas_bottom);
    }];
    lineView.backgroundColor = [UIColor colorWithHexString:@"#f3f3f3"];
    [self layoutTableHeaderView];
}

- (void)layoutTableHeaderView{
    [_tableHeaderView layoutIfNeeded];
    CGFloat height = [_tableHeaderView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
    CGRect frame = _tableHeaderView.frame;
    frame.size.height = height;
    _tableHeaderView.frame =frame;
    self.tableView.tableHeaderView = _tableHeaderView;
}

- (void)bindeTopicData:(NSArray *)topics{
    if(topics == nil)
    {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        return;
    }
    self.hidden = NO;
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
    if (topics.count <= 0) return;
    NSMutableArray *temps = [NSMutableArray array];
    for (TKTopicListViewModel *model in topics) {
        TKTopicItemLayout *layout = [[TKTopicItemLayout alloc] initWithTopics:model];
        if (layout) {
            [temps addObject:layout];
        }
    }
    _topics = temps.mutableCopy;
    [self.tableView reloadData];
    [_classifyView starScroll];
}

- (void)bindOriginalRelevanceDataWithModel:(NSDictionary *)model{
    _followUsers = model[@"users"];
    _banners = model[@"slides"];
    if (_banners.count>0) {
        _bannerView.frame = CGRectMake(0, 0, kMainScreenW,self.bannerViewHeight);
        [_bannerView setDelagateCount:_banners.count delegate:self];
//        [_attentionView mas_updateConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(_bannerView.mas_bottom).offset(8);
//        }];
    }else{
        _bannerView.frame = CGRectMake(0, 0, kMainScreenW,0);
//        [_attentionView mas_updateConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(_bannerView.mas_bottom);
//        }];
    }
    if (_followUsers.count > 0) {
//        _attentionView.hidden = NO;
//        [_attentionView mas_updateConstraints:^(MASConstraintMaker *make) {
//            make.height.offset(145);
//        }];
    }else{
//        _attentionView.hidden = YES;
//        [_attentionView mas_updateConstraints:^(MASConstraintMaker *make) {
//            make.height.offset(1);
//        }];
    }
    _tableHeaderView.backgroundColor = [UIColor colorWithHexString:@"#F3F3F3"];
    [self layoutTableHeaderView];
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.09 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [_attentionView bindDataWithModel:_followUsers];
//    });
}

#pragma mark - 发布原创
-(void)pushYuanChuanAction
{
    [self.delegate originalSubjectViewpushYuanChuangAction];
}

#pragma mark - UITableView Datasource
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
    if(scrollView.contentOffset.y<flastscroll)
    {
        [_btzhiding setBottom:self.height-60];
    }
    else
    {
        [_btzhiding setBottom:self.height+60];
    }
    flastscroll = scrollView.contentOffset.y;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _topics.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TKExploreTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kTabelViewCellIdentifier];
    [cell setLayout:_topics[indexPath.row]];
    cell.delegate = self;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [(TKTopicItemLayout *)_topics[indexPath.row] height];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    
    [self.delegate scrollRollView];
}

#pragma mark - Table View Delegate methods
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


#pragma mark - ImagePlayerViewDelegate
- (void)imagePlayerView:(ImagePlayerView *)imagePlayerView loadImageForImageView:(UIImageView *)imageView index:(NSInteger)index{
    if (_banners.count>index) {
        [imageView sd_setImageWithURL:[NSURL URLWithString:[NSString nullToString:_banners[index][@"imgUrl"]]]];
    }
}
- (void)imagePlayerView:(ImagePlayerView *)imagePlayerView didTapAtIndex:(NSInteger)index{
    if ([self.delegate respondsToSelector:@selector(exploreSubjectViewDidClickBannerWithItem:)]) {
        [self.delegate exploreSubjectViewDidClickBannerWithItem:_banners[index]];
    }
}

#pragma mark - RecommendedAttentionViewDelegate
- (void)attentionViewDidSelectUser:(NSString *)userID complete:(void (^)(BOOL))callback{
    if ([self.delegate respondsToSelector:@selector(originalSubjectViewDidClickFollowBtn:complete:)]) {
        [self.delegate originalSubjectViewDidClickFollowBtn:userID complete:^(BOOL state) {
            callback(state);
        }];
    }
}

- (void)attentionViewDidSelectUserAvater:(NSString *)userID{
    if ([self.delegate respondsToSelector:@selector(originalSubjectViewDidClickAvaterImageView:)]) {
        [self.delegate originalSubjectViewDidClickAvaterImageView:userID];
    }
}

#pragma mark - TKTopicClassifyViewDelegate
- (void)topicClassifyViewDidSelectType:(TKTopicType)type{
    if ([self.delegate respondsToSelector:@selector(exploreSubjectViewDidSelectTopicType:)]) {
        [self.delegate exploreSubjectViewDidSelectTopicType:type];
    }
}

#pragma mark - TKExploreTableViewCellDelegate
- (void)cellDidClick:(TKExploreTableViewCell *)cell{
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    NSString *topicID = [[_topics[indexPath.row] topic] topicID];
    [_topics[indexPath.row] topic].isselectded = YES;
    TKTopicItemLayout *layout = _topics[indexPath.row];
    [layout layout];
    [self.tableView reloadData];
    
    @try
    {
        NSMutableArray *arrycdj = [[NSUserDefaults standardUserDefaults] objectForKey:@"yuanchuangyidianji"];
        NSMutableArray *arrtemp = [NSMutableArray new];
        [arrtemp addObjectsFromArray:arrycdj];
        BOOL isbool = [arrtemp containsObject: topicID];
        if(isbool==NO)
        {
            if(arrtemp.count>=50)
            {
                [arrtemp removeLastObject];
            }
            [arrtemp insertObject:[NSString stringWithFormat:@"%@",topicID] atIndex:0];
        }
        [[NSUserDefaults standardUserDefaults] setObject:arrtemp forKey:@"yuanchuangyidianji"];
        
        
        if ([self.delegate respondsToSelector:@selector(exploreSubjectViewDidSelectItemID:)]) {
            [self.delegate exploreSubjectViewDidSelectItemID:topicID];
        }
    }
    @catch (NSException *exc)
    {
        
    }
    @finally
    {
        
    }
    
}

- (void)cell:(TKExploreTableViewCell *)cell didClickImageAtIndex:(NSInteger)index{
    if (!cell.statusView.layout.topic.topicID) return;
    UIView *fromView = nil;
    NSMutableArray *items = [NSMutableArray new];
    TKTopicListViewModel *topic = cell.statusView.layout.topic;
    NSArray *pics = topic.images;
    for (NSUInteger i = 0, max = pics.count; i < max; i++) {
        YYPhotoGroupItem *item = [YYPhotoGroupItem new];
        if (i >= cell.statusView.picViews.count)
        {
            item.thumbView = nil;
        }
        else
        {
            UIView *imgView = cell.statusView.picViews[i];
            item.thumbView = imgView;
        }
        item.largeImageURL = [NSURL URLWithString:[NSString nullToString:pics[i]]];
        //        item.largeImageSize = CGSizeMake(meta.width, meta.height);
        [items addObject:item];
        if (i == index) {
            UIView *imgView = cell.statusView.picViews[i];
            fromView = imgView;
        }
        
    }
    YYPhotoGroupView *photoGroupView = [[YYPhotoGroupView alloc] initWithGroupItems:items];
    if ([self.delegate respondsToSelector:@selector(photoGroupView:didClickImageView:)]) {
        [self.delegate photoGroupView:photoGroupView didClickImageView:fromView];
    }
}

- (void)cell:(TKExploreTableViewCell *)cell didClickUser:(NSString *)userid{
    if (TKTopicTypeSpitslot == cell.statusView.layout.topic.topicType) return;
    if ([self.delegate respondsToSelector:@selector(exploreSubjectViewDidCickAvaterViewWithUserid:)]) {
        [self.delegate exploreSubjectViewDidCickAvaterViewWithUserid:userid];
    }
}

#pragma mark - setters and getters
- (CGFloat)bannerViewHeight{
    return kScreenWidth*(308/750.f);
}

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [UITableView new];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerClass:[TKExploreTableViewCell class] forCellReuseIdentifier:kTabelViewCellIdentifier];
        _tableView.separatorColor = [UIColor colorWithHexString:@"#E6E6E6"];
        _tableView.tableFooterView = [UIView new];
        _tableView.estimatedRowHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            if ([self.delegate respondsToSelector:@selector(lastPage)]) {
                [self.delegate lastPage];
            }
        }];
        _tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            if ([self.delegate respondsToSelector:@selector(nextPage)]) {
                [self.delegate nextPage];
            }
        }];
    }
    return _tableView;
}

-(void)topScrollAction
{
    [_tableView setContentOffset:CGPointMake(0, 0) animated:YES];
}

@end
