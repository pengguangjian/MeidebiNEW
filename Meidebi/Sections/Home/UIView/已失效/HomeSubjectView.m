//
//  HomeSubjectView.m
//  Meidebi
//  暂未使用
//  Created by mdb-admin on 2017/5/9.
//  Copyright © 2017年 meidebi. All rights reserved.
//

#import "HomeSubjectView.h"
#import "ImagePlayerView.h"
#import "MDB_UserDefault.h"
#import <MJRefresh/MJRefresh.h>
#import "HomeActivityPortalView.h"
#import "HomeHotView.h"
#import "HomeSepcialProtalView.h"
#import "HomeCheapFeaturedView.h"
#import "LatestNewsViewController.h"
#import "HomeBoutiqueViewController.h"
#import "HomeTableViewCell.h"
#import <UMAnalytics/MobClick.h>
static NSString * const kHotRecommendCellIdentifier = @"HotRecommend";
@interface RecognizeSimultaneousTableView : UITableView

@end

@implementation RecognizeSimultaneousTableView

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    // 解决比比活动、banner和NJScrollTableView左右滑动与TableView上下滑动手势冲突
    if ([NSStringFromClass([otherGestureRecognizer.view class])isEqualToString:@"UICollectionView"] ||
        [NSStringFromClass([otherGestureRecognizer.view.superview class])isEqualToString:@"ImagePlayerView"] ||
        [NSStringFromClass([otherGestureRecognizer.view.superview class])isEqualToString:@"NJScrollTableView"]) {
        return NO;
    }
    return YES;
}

@end
        
@interface HomeSubjectView ()
<
ImagePlayerViewDelegate,
HomeActivityPortalViewDelegate,
HomeSepcialProtalViewDelegate,
HomeHotViewDelegate,
HomeTableViewCellDelegate,
HomeCheapFeaturedViewDelegate,
LatestNewsViewControllerDelegate,
UITableViewDelegate,
UITableViewDataSource,
HomeBoutiqueViewControllerDelgate
>
@property (nonatomic, strong) RecognizeSimultaneousTableView *mainTableView;
@property (nonatomic, strong) ImagePlayerView *imagePlayerView;
@property (nonatomic, strong) HomeActivityPortalView *activityPortalView;
@property (nonatomic, strong) HomeHotView *homeHotView;
@property (nonatomic, strong) HomeSepcialProtalView *sepcialProtalView;
@property (nonatomic, strong) HomeCheapFeaturedView *cheapFeatureView;
@property (nonatomic, strong) UIView *contairView;
@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) NSArray *bannerImages;
@property (nonatomic, strong) NSArray *handleImages;
@property (nonatomic, strong) NSArray *handleItems;
@property (nonatomic, strong) NSArray *recommendContents;
@property (nonatomic, strong) NSArray *hotRecommends;
@property (nonatomic, strong) NSMutableArray *waresTables;
@property (nonatomic, assign) CGFloat dynamicHight;
@property (nonatomic, assign) NSInteger hotNewID;
@property (nonatomic, assign) NSInteger tableRowNumber;
@property (nonatomic, assign) BOOL canScroll;
@property (nonatomic, assign) BOOL isTopIsCanNotMoveTabView;
@property (nonatomic, assign) BOOL isTopIsCanNotMoveTabViewPre;
@end

@implementation HomeSubjectView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        _tableRowNumber = 0;
        _waresTables = [NSMutableArray array];
        [self setupSubViews];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(acceptedMsg:) name:kLeaveTopNotificationName object:nil];
    }
    return self;
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)setupSubViews{
    _mainTableView = [RecognizeSimultaneousTableView new];
    [self addSubview:_mainTableView];
    [_mainTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    _mainTableView.delegate = self;
    _mainTableView.dataSource = self;
    _mainTableView.showsVerticalScrollIndicator = NO;
    _mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _mainTableView.estimatedRowHeight = 0;
    _mainTableView.estimatedSectionFooterHeight = 0;
    _mainTableView.estimatedSectionHeaderHeight = 0;
    [_mainTableView registerClass:[HomeTableViewCell class] forCellReuseIdentifier:kHotRecommendCellIdentifier];
    _mainTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self refreshHeader];
    }];
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenW, 100)];
    headerView.backgroundColor = [UIColor colorWithHexString:@"#F5F5F5"];
    _mainTableView.tableHeaderView = headerView;
    _headerView = headerView;

    _imagePlayerView=[[ImagePlayerView alloc]initWithFrame:CGRectMake(0, 0, kMainScreenW,self.dynamicHight)];
    [headerView addSubview:_imagePlayerView];
    _imagePlayerView.backgroundColor = [UIColor whiteColor];
    UIView *handleView = [UIView new];
    [headerView addSubview:handleView];
    [handleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_imagePlayerView.mas_bottom);
        make.left.right.equalTo(headerView);
    }];
    handleView.backgroundColor = [UIColor whiteColor];
    NSMutableArray *items = [NSMutableArray array];
    UIControl *lastHandleControl = nil;
    for (NSInteger i = 0; i < self.handleImages.count; i++) {
        BOOL isSelect = NO;
        UIControl *handleControl = [self setupHandleElementWithName:self.handleImages[i][@"name"] icon:self.handleImages[i][@"image"] isSelect:isSelect showBottomView:NO];
        [handleView addSubview:handleControl];
        handleControl.tag = i;
        [handleControl addTarget:self action:@selector(respondsToHandleControl:) forControlEvents:UIControlEventTouchUpInside];
        [items addObject:handleControl];
    }
    self.handleItems = items.mutableCopy;
    NSUInteger center = self.handleItems.count/2;
    NSArray *headArr = [self.handleItems subarrayWithRange:NSMakeRange(0, center)];
    [headArr mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedItemLength:(kMainScreenW-10)/5 leadSpacing:5 tailSpacing:5];
    [headArr mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(handleView.mas_top).offset(5*kScale);
    }];
    lastHandleControl = headArr.firstObject;
    NSArray *footArr = [self.handleItems subarrayWithRange:NSMakeRange(center, center)];
    [footArr mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedItemLength:(kMainScreenW-10)/5 leadSpacing:5 tailSpacing:5];
    [footArr mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lastHandleControl.mas_bottom).offset(5*kScale);
        make.bottom.equalTo(handleView.mas_bottom).offset(-10*kScale);
    }];
    
    // 推荐活动
    _activityPortalView = [HomeActivityPortalView new];
    [headerView addSubview:_activityPortalView];
    [_activityPortalView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(headerView);
        make.top.equalTo(handleView.mas_bottom).offset(8);
        make.height.offset(kMainScreenW*.6);
    }];
    _activityPortalView.activityTitle = @"比比活动";
    _activityPortalView.delegate = self;

    _homeHotView = [HomeHotView new];
    [headerView addSubview:_homeHotView];
    [_homeHotView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(headerView);
        make.top.equalTo(_activityPortalView.mas_bottom).offset(8);
        make.height.offset(45);
    }];
    _homeHotView.delegate = self;
    
    _cheapFeatureView = [HomeCheapFeaturedView new];
    [headerView addSubview:_cheapFeatureView];
    [_cheapFeatureView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(headerView);
        make.top.equalTo(_homeHotView.mas_bottom).offset(8);
    }];
    _cheapFeatureView.delegate = self;
    
    _sepcialProtalView = [HomeSepcialProtalView new];
    [headerView addSubview:_sepcialProtalView];
    [_sepcialProtalView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(headerView);
        make.top.equalTo(_cheapFeatureView.mas_bottom).offset(8);
        make.bottom.equalTo(headerView.mas_bottom).offset(-8);
    }];
    _sepcialProtalView.delegate = self;
  
    [self layoutTableHeaderView];
}

- (UIControl *)setupHandleElementWithName:(NSString *)name
                                     icon:(UIImage *)icon
                                 isSelect:(BOOL)select
                           showBottomView:(BOOL)isShow{
    UIControl *control = [UIControl new];
    control.backgroundColor = [UIColor whiteColor];
    UIImageView *imageView = [UIImageView new];
    [control addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.equalTo(control).insets(UIEdgeInsetsMake(10*kScale, 10, 20, 10));
        make.centerX.equalTo(control.mas_centerX);
        make.top.equalTo(control.mas_top).offset(10*kScale);
        make.width.equalTo(control.mas_width).multipliedBy(0.6);
        make.height.equalTo(imageView.mas_width);
    }];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.image = icon;
    
    UILabel *nameLabel = [UILabel new];
    [control addSubview:nameLabel];
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(imageView.mas_bottom).offset(10);
        make.centerX.equalTo(control.mas_centerX);
        make.height.offset(13);
        make.bottom.equalTo(control.mas_bottom).offset(-5);
    }];
//    [nameLabel setContentHuggingPriority:1000 forAxis:UILayoutConstraintAxisVertical];
//    [nameLabel setContentCompressionResistancePriority:1000 forAxis:UILayoutConstraintAxisVertical];
    nameLabel.textAlignment = NSTextAlignmentCenter;
    nameLabel.font = [UIFont systemFontOfSize:11.f];
    nameLabel.textColor = [UIColor colorWithHexString:@"#666666"];
    nameLabel.text = name;
    
    UIView *bottomLineView = [UIView new];
    [control addSubview:bottomLineView];
    [bottomLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(nameLabel.mas_bottom);
        make.left.equalTo(nameLabel.mas_left).offset(-3);
        make.right.equalTo(nameLabel.mas_right).offset(3);
        make.height.offset(1);
    }];
    bottomLineView.backgroundColor = [UIColor colorWithHexString:@"#CF6A21"];
    bottomLineView.hidden = YES;
    
    UIImageView *bottomIconImageView = [UIImageView new];
    [control addSubview:bottomIconImageView];
    [bottomIconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(bottomLineView.mas_right).offset(-1);
        make.bottom.equalTo(bottomLineView.mas_bottom);
        make.size.mas_equalTo(CGSizeMake(10, 14));
    }];
    bottomIconImageView.tag = 10000;
    bottomIconImageView.image = [UIImage imageNamed:@"home_attendance_bottom_icon"];
    bottomIconImageView.hidden = YES;
    if (isShow) {
        bottomIconImageView.hidden = NO;
        bottomLineView.hidden = NO;
    }
    
    return control;
}




- (void)animationWithView:(UIView *)view
{
//    if (view.layer.position.y <= 0) return;
//    [view.layer removeAnimationForKey:@"move-layer"];
//    // 设定为缩放
//    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"point"];
//    // 动画选项设定
//    animation.duration = 4; // 动画持续时间
//    animation.repeatCount = HUGE_VALF; // 重复次数(无限)
//    animation.autoreverses = YES; // 动画结束时执行逆动画
//    // 起始帧和终了帧
//    animation.toValue = [NSNumber numberWithFloat: M_PI * 4.0 ];
////    animation.fromValue = [NSValue valueWithCGPoint:view.layer.position]; // 起始帧
////    animation.toValue = [NSValue valueWithCGPoint:CGPointMake(view.layer.position.x, view.layer.position.y-7)]; // 终了帧
//    // 动画先加速后减速
//    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
//    // 添加动画
//    [view.layer addAnimation:animation forKey:@"move-layer"];
    
    // 执行动画
    [UIView animateWithDuration:5.f
                          delay:0
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{
                         view.transform = CGAffineTransformRotate(view.transform, M_2_PI*2);
                     }
                     completion:^(BOOL finished){
                         dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                             [self beginImageAnimation];
                         });
                     }];
}

#pragma mark - Event

- (void)beginImageAnimation{
//    if (self.handleItems.count > 0) {
//        [self animationWithView:[self.handleItems.lastObject viewWithTag:111111]];
//    }
}

- (void)refreshHeader{
    if ([self.delegate respondsToSelector:@selector(subjectViewRefreshHeader)]) {
        [self.delegate subjectViewRefreshHeader];
    }
}

-(void)acceptedMsg:(NSNotification *)notification{
    NSDictionary *userInfo = notification.userInfo;
    NSString *canScroll = userInfo[@"canScroll"];
    if ([canScroll isEqualToString:@"1"]) {
        _canScroll = YES;
    }
}


- (void)respondsToHandleControl:(UIControl *)sender{
    HandleElementType type;
    switch (sender.tag) {
        case HandleElementTypeLowPrice:
            type = HandleElementTypeLowPrice;
            break;
        case HandleElementTypeCoupon:
            type = HandleElementTypeCoupon;
            break;
        case HandleElementTypeHaitao:
            type = HandleElementTypeHaitao;
            break;
        case HandleElementTypeDistribute:
            type = HandleElementTypeDistribute;
            break;
        case HandleElementTypeLotto:
            type = HandleElementTypeLotto;
            break;
        case HandleElementTypeTrend:
            type = HandleElementTypeTrend;
            break;
        case HandleElementTypeJHS:
            type = HandleElementTypeJHS;
            break;
        case HandleElementTypeFJSL:
            type = HandleElementTypeFJSL;
            break;
        case HandleElementTypeTopic:
            type = HandleElementTypeTopic;
            break;
        case HandleElementTypeSignIn:
            type = HandleElementTypeSignIn;
            break;
    
        default:
            type = HandleElementTypeSignIn;
            break;
    }
    if ([self.delegate respondsToSelector:@selector(subjectViewClickHandleViewElementWith:)]) {
        [self.delegate subjectViewClickHandleViewElementWith:type];
    }
}

#pragma mark - Bind Date && Layout view

- (void)layoutTableHeaderView{
    [self layoutIfNeeded];
    CGFloat height = [_headerView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
    CGRect frame = _headerView.frame;
    frame.size.height = height;
    _headerView.frame =frame;
    _mainTableView.tableHeaderView = _headerView;
}

- (void)layoutSubviews{
    [self beginImageAnimation];
}

- (void)bindBannerData:(NSArray *)models{
    if (models.count <= 0) return;
    _bannerImages = models;
    [_imagePlayerView setDelagateCount:models.count delegate:self];
}

- (void)bindDataWithViewModel:(HomeViewModel *)model{
    _hotRecommends = model.shares;
    _recommendContents = model.activities;
    [self layoutSpecial];
    [_mainTableView reloadData];
    if (_recommendContents.count>0) {
        _activityPortalView.hidden = NO;
        [_activityPortalView bindDataWithModels:_recommendContents];
    }else{
        _activityPortalView.hidden = YES;
        [_activityPortalView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.offset(0);
        }];
        [_homeHotView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_activityPortalView.mas_bottom);
        }];
    }
    if (model.hotSticks.count > 0) {
        [_homeHotView bindDataWithModel:model.hotSticks];
        _homeHotView.hidden = NO;
    }else{
        _homeHotView.hidden = YES;
        [_homeHotView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.offset(0);
        }];
        [_cheapFeatureView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_homeHotView.mas_bottom);
        }];
    }
    [_cheapFeatureView bindDataWithModel:model.cheaps];
    if (model.cheaps.count <= 0) {
        [_sepcialProtalView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_cheapFeatureView.mas_bottom);
        }];
    }
    if (model.homeSpecials.count <= 0) {
        [_sepcialProtalView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(_headerView.mas_bottom);
        }];
    }
    [_sepcialProtalView bindDataWithModel:model.homeSpecials];
    [self layoutTableHeaderView];
}

- (void)updateDataWithViewModel:(HomeViewModel *)model{
    [_mainTableView.mj_header endRefreshing];
    _hotRecommends = model.shares;
    [self layoutSpecial];
    _recommendContents = model.activities;
    [_mainTableView reloadData];
    [_activityPortalView bindDataWithModels:_recommendContents];
    if (_recommendContents.count>0) {
        [_activityPortalView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.offset(kMainScreenW*.6);
        }];
        [_homeHotView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_activityPortalView.mas_bottom).offset(8);
        }];
        _activityPortalView.hidden = NO;
    }else{
        [_activityPortalView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.offset(0);
        }];
        [_homeHotView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_activityPortalView.mas_bottom);
        }];
        _activityPortalView.hidden = YES;
    }
    if (model.hotSticks.count > 0) {
        [_homeHotView bindDataWithModel:model.hotSticks];
         _homeHotView.hidden = NO;
        [_homeHotView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.offset(45);
        }];
        [_cheapFeatureView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_homeHotView.mas_bottom).offset(8);
        }];
    }else{
        _homeHotView.hidden = YES;
        [_homeHotView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.offset(0);
        }];
        [_cheapFeatureView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_homeHotView.mas_bottom);
        }];
    }
    [_cheapFeatureView bindDataWithModel:model.cheaps];
    if (model.cheaps.count <= 0) {
        [_sepcialProtalView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_cheapFeatureView.mas_bottom);
        }];
    }else{
        [_sepcialProtalView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_cheapFeatureView.mas_bottom).offset(8);
        }];
    }
    if (model.homeSpecials.count <= 0) {
        [_sepcialProtalView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(_headerView.mas_bottom);
        }];
    }
    [_sepcialProtalView bindDataWithModel:model.homeSpecials];
    [self layoutTableHeaderView];
}

- (void)layoutSpecial{
    _tableRowNumber = 1;
    [_waresTables removeAllObjects];
    HomeBoutiqueViewController *recommendVC = [[HomeBoutiqueViewController alloc] initWithModels:_hotRecommends];
    recommendVC.title = @"人气推荐";
    recommendVC.delegate = self;
    [_waresTables addObject:recommendVC];
    LatestNewsViewController *latestNewsVC = [[LatestNewsViewController alloc] init];
    latestNewsVC.title = @"关注动态";
    latestNewsVC.delegate = self;
    [latestNewsVC updateLatestNewsDataIsCallback:YES];
    [_waresTables addObject:latestNewsVC];
}

#pragma mark - HomeCheapFeaturedViewDelegate
- (void)cheapFeaturedViewDidSelectFeature:(NSString *)featureID{
    if ([self.delegate respondsToSelector:@selector(subjectViewClickCheapFeatured:)]) {
        [self.delegate subjectViewClickCheapFeatured:featureID];
    }
}

#pragma mark - HomeHotViewDelegate
- (void)homeHotViewDidClichkCurrentHotWithItem:(HomeHotSticksViewModel *)item{
    if ([self.delegate respondsToSelector:@selector(subjectViewClickCurrentHotWithHotID:title:link:linkType:)]) {
        [self.delegate subjectViewClickCurrentHotWithHotID:item.linkId
                                                     title:item.title
                                                      link:item.link
                                                  linkType:item.linkType];
    }
}

#pragma mark - ImagePlayerViewDelegate
- (void)imagePlayerView:(ImagePlayerView *)imagePlayerView loadImageForImageView:(UIImageView *)imageView index:(NSInteger)index{
    if (_bannerImages.count>index) {
        [[MDB_UserDefault defaultInstance]setViewImageWithURL:[NSURL URLWithString:[NSString nullToString:_bannerImages[index][@"imgUrl"]]] placeholder:[UIImage imageNamed:@"Active.jpg"] UIimageview:imageView];
    }
}

-(void)imagePlayerView:(ImagePlayerView *)imagePlayerView didTapAtIndex:(NSInteger)index{
    if ([self.delegate respondsToSelector:@selector(subjectViewClickBannerElement:)]) {
        [self.delegate subjectViewClickBannerElement:_bannerImages[index]];
    }
}

#pragma mark - HomeHotRecommendSubjectViewDelegate
- (void)activityPortalViewDidSelectItemAtIndex:(NSInteger)index{
    RecommendType type;
    @try
    {
        if ([(HomeActivitieViewModel *)_recommendContents[index] activityType] == ActivityTypeNormal) {
            type = RecommendTypeComment;
        }else if ([(HomeActivitieViewModel *)_recommendContents[index] activityType] == ActivityTypeBargain) {
            type = RecommendTypeBargain;
        }else if ([(HomeActivitieViewModel *)_recommendContents[index] activityType] == ActivityTypeAccumulate){
            type = RecommendTypeAccumulate;
        }else{
            return;
        }
    }
    @catch(NSException *exc)
    {
        return;
    }
    @finally
    {
        
    }
    
    
    [self.delegate subjectViewClickRecommendElementWithType:type activityID:[(HomeActivitieViewModel *)self.recommendContents[index] activityID]];
}

#pragma mark - HomeSepcialProtalViewDelegate
- (void)sepcialProtalTableViewDidSelectSpecial:(NSString *)specialID{
    if ([self.delegate respondsToSelector:@selector(subjectViewClickSpcialElementID:)]) {
        [self.delegate subjectViewClickSpcialElementID:specialID];
    }
}
- (void)homeSepcialProtalViewDidClickMoreBtn{
    if ([self.delegate respondsToSelector:@selector(subjectViewClickMoreSpcialButton)]) {
        [self.delegate subjectViewClickMoreSpcialButton];
    }
}
- (void)sepcialProtalTableViewDidSelectTBSpecial:(NSString *)content{
    if ([self.delegate respondsToSelector:@selector(subjectViewClickTBSpecialElement:)]) {
        [self.delegate subjectViewClickTBSpecialElement:content];
    }
}


#pragma mark - LatestNewsViewControllerDelegate
- (void)latesDiscountNewsTableViewDidSelectRowWithItemID:(NSString *)itemID{
    if ([self.delegate respondsToSelector:@selector(subjectViewClickHotDiscountRecommendElement:)]) {
        [MobClick event:@"zhuye_guanzhu"];
        [self.delegate subjectViewClickHotDiscountRecommendElement:itemID];
    }
}

- (void)latesSpecialNewsTableViewDidSelectRowWithItemID:(NSString *)itemID{
    if ([self.delegate respondsToSelector:@selector(subjectViewClickHotSpecailRecommendElement:)]) {
        [MobClick event:@"zhuye_guanzhu"];
        [self.delegate subjectViewClickHotSpecailRecommendElement:itemID];
    }
}

- (void)latesOriginalNewsTableViewDidSelectRowWithItemID:(NSString *)itemID{
    if ([self.delegate respondsToSelector:@selector(subjectViewClickHotOriginalRecommendElement:)]) {
        [MobClick event:@"zhuye_guanzhu"];
        [self.delegate subjectViewClickHotOriginalRecommendElement:itemID];
    }
}

- (void)latesNewsTableViewWihtFirstRow:(NSString *)itemID{
    _hotNewID = itemID.integerValue;
//    HomeTableViewCell *cell = [_mainTableView cellForRowAtIndexPath: [NSIndexPath indexPathForRow:0 inSection:0]];
}

#pragma mark - HomeBoutiqueViewControllerDelgate
- (void)homeBoutiqueViewControllerDidSelectItem:(NSString *)itemID{
    if ([self.delegate respondsToSelector:@selector(subjectViewClickHotDiscountRecommendElement:)]) {
        [MobClick event:@"zhuye_renqi"];
        [self.delegate subjectViewClickHotDiscountRecommendElement:itemID];
    }
}

#pragma mark - UITableView Datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _tableRowNumber;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HomeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kHotRecommendCellIdentifier];
    cell.delegate = self;
    if ([MDB_UserDefault hotLastNewID] == _hotNewID) {
        [cell showRemind:NO];
    }else{
        [cell showRemind:YES];
        [MDB_UserDefault setHotLastNewID:_hotNewID];
    }
    return cell;
}
#pragma mark - UITableView Delegate methods
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return CGRectGetHeight(self.frame);
}

#pragma mark - HomeTableViewCellDelegate
- (NSArray *)numberOfCellPages{
    return _waresTables.mutableCopy;
}

- (void)didWipeToHotNew{
    [(LatestNewsViewController *)_waresTables.lastObject updateLatestNewsDataIsCallback:NO];
}

#pragma mark - UIScrollViewDelegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if ([scrollView isKindOfClass:[UICollectionView class]]) return;
    CGFloat tabOffsetY = [_mainTableView rectForSection:0].origin.y;
    CGFloat offsetY = scrollView.contentOffset.y;
    _isTopIsCanNotMoveTabViewPre = _isTopIsCanNotMoveTabView;
    // 这里转换成NSInteger类型做比较，是避免tabOffsetY与offsetY在5s这种屏幕上出现小数位上的偏差
    if ((NSInteger)offsetY >= (NSInteger)tabOffsetY) {
        scrollView.contentOffset = CGPointMake(0, tabOffsetY);
        _isTopIsCanNotMoveTabView = YES;
    }else{
        _isTopIsCanNotMoveTabView = NO;
    }
    if (_isTopIsCanNotMoveTabView != _isTopIsCanNotMoveTabViewPre) {
        if (!_isTopIsCanNotMoveTabViewPre && _isTopIsCanNotMoveTabView) {
            //NSLog(@"滑动到顶端");
            [[NSNotificationCenter defaultCenter] postNotificationName:kGoTopNotificationName object:nil userInfo:@{@"canScroll":@"1"}];
            _canScroll = NO;
        }
        if(_isTopIsCanNotMoveTabViewPre && !_isTopIsCanNotMoveTabView){
            //NSLog(@"离开顶端");
            if (!_canScroll) {
                scrollView.contentOffset = CGPointMake(0, tabOffsetY);
            }
        }
    }
//    [NSObject cancelPreviousPerformRequestsWithTarget:self];
//    [self performSelector:@selector(scrollViewDidEndScrollingAnimation:) withObject:nil afterDelay:0.1];
}

//- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
//    [_homeHotView stopScroll];
//}
//
//-(void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
//{
//    [_homeHotView starScroll];
//    [NSObject cancelPreviousPerformRequestsWithTarget:self];
//}

#pragma mark - setters and getters
- (CGFloat)dynamicHight{
    if (!_dynamicHight) {
        _dynamicHight = kMainScreenW*0.40;
    }
    return _dynamicHight;
}

- (NSArray *)handleImages{
    if (!_handleImages) {
        _handleImages = @[@{@"image":[UIImage imageNamed:@"home_9.9"],
                            @"name":@"9.9包邮"},
                          @{@"image":[UIImage imageNamed:@"home_privilegel"],
                            @"name":@"优惠券"},
                          @{@"image":[UIImage imageNamed:@"home_ accesories"],
                            @"name":@"海淘直邮"},
                          @{@"image":[UIImage imageNamed:@"welfare_home"],
                            @"name":@"比友福利"},
                          @{@"image":[UIImage imageNamed:@"daily_lottery"],
                            @"name":@"每日抽奖"},
                          @{@"image":[UIImage imageNamed:@"rank_ico"],
                            @"name":@"排行榜"},
                          @{@"image":[UIImage imageNamed:@"ju_ico"],
                            @"name":@"聚划算"},
                          @{@"image":[UIImage imageNamed:@"songli_ico"],
                            @"name":@"逢节送礼"},
                          @{@"image":[UIImage imageNamed:@"topic_ico"],
                            @"name":@"话题"},
                          @{@"image":[UIImage imageNamed:@"home_ attendance"],
                            @"name":@"签到"}
                          ];
    }
    return _handleImages;
}
@end
