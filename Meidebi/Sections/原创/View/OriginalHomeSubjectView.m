//
//  OriginalHomeSubjectView.m
//  Meidebi
//
//  Created by ZlJ_losaic on 2017/9/21.
//  Copyright © 2017年 meidebi. All rights reserved.
//

#import "OriginalHomeSubjectView.h"
#import "ImagePlayerView.h"
#import "RecommendedAttentionView.h"
#import "OriginalFlagView.h"
#import "OriginalTableViewCell.h"
#import "MDB_UserDefault.h"
#import <MJRefresh/MJRefresh.h>
#import "UITableView+FDTemplateLayoutCell.h"
static NSString * const kTableViewCellIdentifier = @"cell";
@interface OriginalHomeSubjectView ()
<
UITableViewDelegate,
UITableViewDataSource,
ImagePlayerViewDelegate,
OriginalFlagViewDelegate,
OriginalTableViewCellDelegate,
RecommendedAttentionViewDelegate
>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) ImagePlayerView *imagePlayerView;
@property (nonatomic, strong) RecommendedAttentionView *attentionView;
@property (nonatomic, strong) OriginalFlagView *flageView;
@property (nonatomic, strong) UIView *tableHeaderView;
@property (nonatomic, strong) UIView *typeSwitchView;
@property (nonatomic, strong) NSArray *banners;
@property (nonatomic, strong) NSArray *followUsers;
@property (nonatomic, strong) NSArray *originals;
@property (nonatomic, assign) CGFloat dynamicHight;
@property (nonatomic, assign) NSInteger pa;
@end

@implementation OriginalHomeSubjectView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupSubviews];
    }
    return self;
}

- (void)setupSubviews{
    _tableView = [UITableView new];
    [self addSubview:_tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    _tableView.estimatedRowHeight = 0;
    _tableView.estimatedSectionFooterHeight = 0;
    _tableView.estimatedSectionHeaderHeight = 0;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [_tableView registerClass:[OriginalTableViewCell class] forCellReuseIdentifier:kTableViewCellIdentifier];
    _tableView.tableFooterView = [UIView new];
    _tableView.scrollEnabled = NO;
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
    UIView *tableHeaderView = [UIView new];
    tableHeaderView.backgroundColor = [UIColor whiteColor];
    _tableHeaderView = tableHeaderView;
    _tableView.tableHeaderView = tableHeaderView;
    
    _imagePlayerView=[[ImagePlayerView alloc]initWithFrame:CGRectMake(0, 0, kMainScreenW,0)];
    [tableHeaderView addSubview:_imagePlayerView];
    _imagePlayerView.backgroundColor = [UIColor whiteColor];
    
    _attentionView = [RecommendedAttentionView new];
    [tableHeaderView addSubview:_attentionView];
    [_attentionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_imagePlayerView.mas_bottom);
        make.left.right.equalTo(tableHeaderView);
        make.height.offset(145);
    }];
    _attentionView.hidden = YES;
    _attentionView.backgroundColor = [UIColor colorWithHexString:@"#FAFAFA"];
    _attentionView.delegate = self;
    
//    _flageView = [OriginalFlagView new];
//    [tableHeaderView addSubview:_flageView];
//    [_flageView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(_attentionView.mas_bottom).offset(8);
//        make.left.right.equalTo(tableHeaderView);
//        make.height.offset(106);
//    }];
//    _flageView.backgroundColor = [UIColor whiteColor];
//    _flageView.delegate = self;
//    _flageView.hidden = YES;
    
    UIView *typeSwitchView = [UIView new];
    typeSwitchView.backgroundColor = [UIColor colorWithHexString:@"#FAFAFA"];
    [tableHeaderView addSubview:typeSwitchView];
    [typeSwitchView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_attentionView.mas_bottom);
        make.left.right.equalTo(tableHeaderView);
        make.height.offset(51);
        make.bottom.equalTo(tableHeaderView.mas_bottom);
    }];
    typeSwitchView.hidden = YES;
    _typeSwitchView = typeSwitchView;
    UISegmentedControl *segementControl=[[UISegmentedControl alloc]initWithItems:@[@"最新",@"精华"]];
    [typeSwitchView addSubview:segementControl];
    [segementControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(typeSwitchView.mas_right).offset(-15);
        make.centerY.equalTo(typeSwitchView.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(100, 28));
    }];
    [segementControl setTintColor:RadMenuColor];
    [segementControl.layer setMasksToBounds:YES];
    [segementControl.layer setCornerRadius:4.0];
    [segementControl.layer setBorderWidth:1.0];
    [segementControl.layer setBorderColor:RadMenuColor.CGColor];
     segementControl.selectedSegmentIndex=1;
    [segementControl addTarget:self action:@selector(segementValueChanged:) forControlEvents:UIControlEventValueChanged];
    [self setupTableHeaderViewLayout];
}

- (void)setupTableHeaderViewLayout{
    [self layoutIfNeeded];
    CGFloat height = [_tableHeaderView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
    CGRect frame = _tableHeaderView.frame;
    frame.size.height = height;
    _tableHeaderView.frame =frame;
    _tableView.tableHeaderView = _tableHeaderView;
}


- (void)segementValueChanged:(UISegmentedControl *)sender{
    BOOL state = NO;
    if (sender.selectedSegmentIndex == 1) {
        state = YES;
    }
    if ([self.delegate respondsToSelector:@selector(originalSubjectViewSwitchOriginalDataWithHot:)]) {
        [self.delegate originalSubjectViewSwitchOriginalDataWithHot:state];
    }
}

- (void)bindDataWithModel:(NSArray *)models{
    _tableView.scrollEnabled = YES;
    [_tableView.mj_header endRefreshing];
    [_tableView.mj_footer endRefreshing];
    if (models.count <= 0) return;
    _typeSwitchView.hidden = NO;
    _originals = models;
    [_tableView reloadData];
}

- (void)bindOriginalRelevanceDataWithModel:(NSDictionary *)model{
    _followUsers = model[@"users"];
    _banners = model[@"slides"];
    if (_banners.count>0) {
        _imagePlayerView.frame = CGRectMake(0, 0, kMainScreenW,self.dynamicHight);
        [_imagePlayerView setDelagateCount:_banners.count delegate:self];
        [_attentionView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_imagePlayerView.mas_bottom).offset(8);
        }];
    }else{
        _imagePlayerView.frame = CGRectMake(0, 0, kMainScreenW,0);
        [_attentionView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_imagePlayerView.mas_bottom);
        }];
    }
    if (_followUsers.count > 0) {
        _attentionView.hidden = NO;
        [_attentionView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.offset(145);
        }];
    }else{
        _attentionView.hidden = YES;
        [_attentionView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.offset(1);
        }];
    }
    _tableHeaderView.backgroundColor = [UIColor colorWithHexString:@"#F3F3F3"];
    [self setupTableHeaderViewLayout];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [_attentionView bindDataWithModel:_followUsers];
    });
}

- (void)lastPage{
    if ([self.delegate respondsToSelector:@selector(lastPage)]) {
        _tableView.scrollEnabled = NO;
        [self.delegate lastPage];
    }
}

- (void)nextPage{
    if ([self.delegate respondsToSelector:@selector(nextPage)]) {
        _tableView.scrollEnabled = NO;
        [self.delegate nextPage];
    }
}
#pragma mark - UITableView Datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _originals.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    OriginalTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kTableViewCellIdentifier];
    cell.delegate = self;
    [self configureCell:cell atIndexPath:indexPath];
    return cell;
}

- (void)configureCell:(OriginalTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    cell.fd_enforceFrameLayout = NO; // Enable to use "-sizeThatFits:"
    [cell bindDataWithModel:_originals[indexPath.row]];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    Sharecle *entity = _originals[indexPath.row];
    return [tableView fd_heightForCellWithIdentifier:kTableViewCellIdentifier cacheByKey:entity.identifier configuration:^(OriginalTableViewCell *cell) {
        [self configureCell:cell atIndexPath:indexPath];
    }];
}

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

#pragma mark - UITableView Delegate methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.delegate respondsToSelector:@selector(originalSubjectViewDidSelectRow:)]) {
        [self.delegate originalSubjectViewDidSelectRow:[NSString stringWithFormat:@"%@",[(Sharecle *)_originals[indexPath.row] shareid]]];
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

#pragma mark - OriginalFlagViewDelegate
- (void)flageCollectionViewDidSelectRow:(NSString *)flagID{
    if ([self.delegate respondsToSelector:@selector(originalSubjectViewDidClickFlage:)]) {
        [self.delegate originalSubjectViewDidClickFlage:flagID];
    }
}

#pragma mark - OriginalTableViewCellDelegate
- (void)tableViewCellDidClickFollowBtn:(OriginalTableViewCell *)cell{
    NSIndexPath *indexPath = [_tableView indexPathForCell:cell];
    if ([self.delegate respondsToSelector:@selector(originalSubjectViewDidClickFollowBtn:complete:)]) {
        [self.delegate originalSubjectViewDidClickFollowBtn:[NSString stringWithFormat:@"%@",[(Sharecle *)_originals[indexPath.row] userid]] complete:^(BOOL state) {
            if (state) {
                NSMutableArray *orginials = [NSMutableArray arrayWithArray:_originals];
                Sharecle *aSharecle = _originals[indexPath.row];
                aSharecle.isFllow = YES;
                [orginials replaceObjectAtIndex:indexPath.row withObject:aSharecle];
                _originals = orginials.mutableCopy;
                [_tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
            }
        }];
    }
}

- (void)tableViewCellDidClickAvaterImageView:(OriginalTableViewCell *)cell{
    NSIndexPath *indexPath = [_tableView indexPathForCell:cell];
    if ([self.delegate respondsToSelector:@selector(originalSubjectViewDidClickAvaterImageView:)]) {
        [self.delegate originalSubjectViewDidClickAvaterImageView:[NSString stringWithFormat:@"%@",[(Sharecle *)_originals[indexPath.row] userid]]];
    }
}

- (void)tableViewCellDidClickFlageWithItem:(NSDictionary *)item{
    if ([self.delegate respondsToSelector:@selector(originalSubjectViewDidClickFlage:)]) {
        [self.delegate originalSubjectViewDidClickFlage:[NSString nullToString:item[@"name"]]];
    }
}


#pragma mark - ImagePlayerViewDelegate
- (void)imagePlayerView:(ImagePlayerView *)imagePlayerView loadImageForImageView:(UIImageView *)imageView index:(NSInteger)index{
    if (_banners.count>index) {
        [[MDB_UserDefault defaultInstance]setViewImageWithURL:[NSURL URLWithString:[NSString nullToString:_banners[index][@"imgUrl"]]] placeholder:[UIImage imageNamed:@"Active.jpg"] UIimageview:imageView];
    }
}
- (void)imagePlayerView:(ImagePlayerView *)imagePlayerView didTapAtIndex:(NSInteger)index{
    if ([self.delegate respondsToSelector:@selector(originalSubjectViewDidClickBannerElement:)]) {
        [self.delegate originalSubjectViewDidClickBannerElement:_banners[index]];
    }
}
#pragma mark - setters and getters
- (CGFloat)dynamicHight{
    if (!_dynamicHight) {
        _dynamicHight = kMainScreenW*0.38;
    }
    return _dynamicHight;
}
@end
