//
//  JingXuanView.m
//  Meidebi
//
//  Created by mdb-losaic on 2018/3/21.
//  Copyright © 2018年 meidebi. All rights reserved.
//

#import "JingXuanView.h"

#import "ImagePlayerView.h"

#import "JingXuanDaiGouView.h"

#import "BiBiActivityView.h"

#import "HomeHotView.h"

#import "BaiCaiView.h"

#import "ReMenZhuanTiView.h"

#import "ContentCell.h"

#import "MDB_UserDefault.h"
#import <MJRefresh.h>

#import <UMAnalytics/MobClick.h>

#import "CheapOrOutsideViewController.h"

#import "DailyLottoViewController.h"

#import "InviteFriendViewController.h"

#import "VKLoginViewController.h"

#import "ConversionViewController.h"

#import "SendGiftViewController.h"

#import "SignInViewController.h"

#import "CouponLiveViewController.h"

#import "SVModalWebViewController.h"

#import "ProductInfoViewController.h"
#import "OriginalDetailViewController.h"

#import "CommentRewardsViewController.h"
#import "RecommendActivityViewController.h"
#import "BargainActivityViewController.h"

#import "SpecialInfoViewController.h"
#import "SpecicalIndexViewController.h"

#import "ShowActiveViewController.h"

#import "WelfareHomeViewController.h"

static NSString * const kTableViewCellIdentifier = @"jinxuancell";

@interface JingXuanView ()<
UITableViewDelegate,
UITableViewDataSource,
ImagePlayerViewDelegate,
BiBiActivityViewDelegate,
HomeHotViewDelegate,
ReMenZhuanTiViewDelegate,
BaiCaiViewDelegate,
UIAlertViewDelegate>
{
    HomeViewModel *jingxuanModel;
    
    BOOL isshowfooter;
}
@property (nonatomic , retain) UITableView *tabView;
@property (nonatomic , retain) ImagePlayerView *imagePlayerView;
@property (nonatomic, retain) NSArray *handleImages;
@property (nonatomic, retain) NSArray *handleItems;
@property (nonatomic, retain) JingXuanDaiGouView *dgView;
@property (nonatomic, retain) BiBiActivityView *bbView;
@property (nonatomic, retain) HomeHotView *homeHotView;
@property (nonatomic, retain) BaiCaiView *cheapFeatureView;
@property (nonatomic, retain) ReMenZhuanTiView *sepcialProtalView;
@property (nonatomic, retain) UIView *viewRQTJ;

@property (nonatomic , retain) NSArray *bannerImages;

@property (nonatomic, retain) NSMutableArray *tableRowNumber;

@property (nonatomic, retain) UIView *headerView;

@end

@implementation JingXuanView

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


-(void)setupSubViews
{
    _tabView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height)];
    [_tabView setDelegate:self];
    [_tabView setDataSource:self];
    [_tabView registerClass:[ContentCell class] forCellReuseIdentifier:kTableViewCellIdentifier];
    [self addSubview:_tabView];
    [self drawTabviewHeader];
    
    _tabView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self refreshHeader];
    }];
    _tabView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        if(isshowfooter==NO)
        {
            isshowfooter = YES;
            [self drawfooterview];
        }
        [_tabView.mj_footer endRefreshing];
    }];
    
    
}

-(void)drawfooterview
{
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenW, 50)];
    footerView.backgroundColor = [UIColor colorWithHexString:@"#EFEFEF"];
    
    UIButton *btbotom = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, footerView.width, footerView.height)];
    [btbotom setTitle:@"点击查看更多优惠" forState:UIControlStateNormal];
    [btbotom setTitleColor:RGB(120, 120, 120) forState:UIControlStateNormal];
    [btbotom.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [btbotom addTarget:self action:@selector(footerbottomAction) forControlEvents:UIControlEventTouchUpInside];
    [footerView addSubview:btbotom];
    
    
    [_tabView setTableFooterView:footerView];
}

-(void)drawTabviewHeader
{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenW, 500)];
    headerView.backgroundColor = [UIColor colorWithHexString:@"#EFEFEF"];
    
    
    ///banner
    _imagePlayerView=[[ImagePlayerView alloc]initWithFrame:CGRectMake(0, 0, kMainScreenW,kMainScreenW*0.4)];
    [headerView addSubview:_imagePlayerView];
    _imagePlayerView.backgroundColor = [UIColor grayColor];
    
    ///单个小模块
    self.handleImages = [self handleImages];
    UIView *handleView = [[UIView alloc] initWithFrame:CGRectMake(0, _imagePlayerView.bottom, headerView.width, (kMainScreenW)/4.4)];
//    [handleView setBackgroundColor:[UIColor brownColor]];
    [headerView addSubview:handleView];
    handleView.backgroundColor = [UIColor whiteColor];
    NSMutableArray *items = [NSMutableArray array];
    for (NSInteger i = 0; i < self.handleImages.count; i++) {
        BOOL isSelect = NO;
        BOOL isShowBotImage = NO;
        UIColor *color = [UIColor colorWithHexString:@"#666666"];
        if(i == self.handleImages.count-1)
        {
            color = RGB(207,106,33);
            isShowBotImage = YES;
        }
        
        UIControl *handleControl = [self setupHandleElementWithName:self.handleImages[i][@"name"] icon:self.handleImages[i][@"image"] isSelect:isSelect showBottomView:isShowBotImage nameColor:color];
        [handleView addSubview:handleControl];
        handleControl.tag = i;
        [handleControl addTarget:self action:@selector(respondsToHandleControl:) forControlEvents:UIControlEventTouchUpInside];
        [items addObject:handleControl];
    }
    self.handleItems = items.mutableCopy;
    NSUInteger center = self.handleItems.count;
    NSArray *headArr = [self.handleItems subarrayWithRange:NSMakeRange(0, center)];
    [headArr mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedItemLength:(kMainScreenW-10)/6 leadSpacing:5 tailSpacing:5];
    [headArr mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(handleView.mas_top).offset(6*kScale);
    }];
    
    
    ////代购模块
    _dgView = [[JingXuanDaiGouView alloc] initWithFrame:CGRectMake(0, handleView.bottom+8, headerView.width, BOUNDS_WIDTH*0.36)];
    [_dgView setBackgroundColor:[UIColor whiteColor]];
    [headerView addSubview:_dgView];
    
    
    
    ///比比活动
    _bbView = [[BiBiActivityView alloc] initWithFrame:CGRectMake(0, _dgView.bottom+8, _dgView.width, BOUNDS_WIDTH*0.3+30)];
    [_bbView setBackgroundColor:[UIColor whiteColor]];
    [_bbView setDelegate:self];
    [_bbView setHidden:YES];
    [headerView addSubview:_bbView];
    
    ///热门推荐
    _homeHotView = [[HomeHotView alloc] initWithFrame:CGRectMake(0, _bbView.bottom+8, _bbView.width, 45)];
    [_homeHotView setDelegate:self];
    [_homeHotView setHidden:YES];
    [headerView addSubview:_homeHotView];
    
    ///白菜精选
    _cheapFeatureView = [[BaiCaiView alloc] initWithFrame:CGRectMake(0, _homeHotView.bottom+8, _bbView.width, 100)];
    [_cheapFeatureView setDelegate:self];
    [_cheapFeatureView setHidden:YES];
    [headerView addSubview:_cheapFeatureView];
    
    
    ///热门专题
    _sepcialProtalView = [[ReMenZhuanTiView alloc] initWithFrame:CGRectMake(0, _cheapFeatureView.bottom+8, _bbView.width, 100)];
    [_sepcialProtalView setDelegate:self];
    [_sepcialProtalView setHidden:YES];
    [headerView addSubview:_sepcialProtalView];
    
    
    ///人气推荐
    _viewRQTJ = [self drawRQTj:CGRectMake(0, _sepcialProtalView.bottom+8, _bbView.width, 50)];
    [headerView addSubview:_viewRQTJ];
    
    
    [headerView setHeight:_viewRQTJ.bottom];
    _headerView = headerView;
    
    [_tabView setTableHeaderView:_headerView];
}

-(UIView *)drawRQTj:(CGRect)rect
{
    UIView *view = [[UIView alloc] initWithFrame:rect];
    [view setBackgroundColor:[UIColor whiteColor]];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 30)];
    [view addSubview:titleLabel];
    titleLabel.font = [UIFont systemFontOfSize:14.f];
    titleLabel.textColor = [UIColor colorWithHexString:@"#666666"];
    titleLabel.text = @"人气推荐";
    [titleLabel sizeToFit];
    [titleLabel setCenter:CGPointMake(self.width/2.0, 0)];
    [titleLabel setTop:10];
    [titleLabel setHeight:20];
    
    UIView *leftLineView = [[UIView alloc] initWithFrame:CGRectMake(titleLabel.left-16, titleLabel.center.y, 16, 1)];
    [view addSubview:leftLineView];
    leftLineView.backgroundColor = [UIColor colorWithHexString:@"#999999"];
    
    UIView *rightLineView = [[UIView alloc] initWithFrame:CGRectMake(titleLabel.right, titleLabel.center.y, 16, 1)];
    [view addSubview:rightLineView];
    rightLineView.backgroundColor = [UIColor colorWithHexString:@"#999999"];
    
//    UIView *viewline0 = [[UIView alloc] initWithFrame:CGRectMake(0, titleLabel.bottom+10, view.width, 1)];
//    [viewline0 setBackgroundColor:RGB(222,222,222)];
//    [view addSubview:viewline0];
    [view setHeight:titleLabel.bottom+10];
    return view;
}

-(void)refreshHeader
{
    [self.delegate jingxuanHeaderRefAction];
}

///精选下拉刷新数据
- (void)bindJinXuanRefData:(NSDictionary *)dicmodels
{
    [_tabView.mj_header endRefreshing];
    [self bindData:dicmodels];
    
}
#pragma mark - 得到数据
- (void)bindData:(NSDictionary *)dicmodel
{
    HomeViewModel *viewModel = [HomeViewModel viewModelWithSubject:dicmodel];
    jingxuanModel = viewModel;
    
    [_dgView binddaigouData:viewModel.helpshop];
    
    
    float ftemp = _dgView.bottom;
    ///比比活动
    [_bbView loadBiBiData:viewModel.activities];
    if(viewModel.activities == 0)
    {
        [_bbView setHidden:YES];
    }
    else
    {
        [_bbView setHidden:NO];
        
        ftemp = _bbView.bottom;
    }
    
    
    if(viewModel.hotSticks.count<1)
    {
        [_homeHotView setHidden:YES];
        
        
    }
    else
    {
        [_homeHotView setTop:ftemp+8];
        [_homeHotView setHidden:NO];
        ftemp = _homeHotView.bottom;
        
    }
    ///热门推荐
    [_homeHotView bindDataWithModel:viewModel.hotSticks];
    
    ///白菜精选
    float ftemp1 = [_cheapFeatureView bindDataWithModel:viewModel.cheaps];
    [_cheapFeatureView setHeight:ftemp1];
    if(viewModel.cheaps.count == 0)
    {
        [_cheapFeatureView setHidden:YES];
    }
    else
    {
        [_cheapFeatureView setTop:ftemp+8];
        [_cheapFeatureView setHidden:NO];
        ftemp = ftemp + ftemp1 +8;
    }
    
    ftemp1 = [_sepcialProtalView bindDataWithModel:viewModel.homeSpecials];
    [_sepcialProtalView setHeight:ftemp1];
    if(viewModel.homeSpecials.count == 0)
    {
        [_sepcialProtalView setHidden:YES];
    }
    else
    {
        ///热门专题
        [_sepcialProtalView setTop:ftemp+8];
        [_sepcialProtalView setHidden:NO];
        ftemp = ftemp + ftemp1+8;
    }
    
    
    
    [_viewRQTJ setTop:ftemp+8];
    
    [_headerView setHeight:_viewRQTJ.bottom];
    [_tabView setTableHeaderView:_headerView];
    
    ///精选 
    _tableRowNumber = (NSMutableArray *)viewModel.shares;
    
    [self.tabView.mj_header endRefreshing];
    [_tabView reloadData];
}
#pragma mark - bananer 数据
-(void)bindBanarData:(NSArray *)arrmodels
{
    _bannerImages = arrmodels;
    [_imagePlayerView setDelagateCount:arrmodels.count delegate:self];
    
}

#pragma mark - 单个小模块点击
-(void)respondsToHandleControl:(UIControl *)sender
{
    switch (sender.tag) {
        case 0:
        {///优惠券
            [MobClick event:@"zhuye_youhuiquan"];
            CouponLiveViewController *couponLiveVc = [[CouponLiveViewController alloc] init];
            [self.viewController.navigationController pushViewController:couponLiveVc animated:YES];
        }
            break;
        case 1:
        {///抽奖
            [MobClick event:@"zhuye_choujiang"];
            DailyLottoViewController *lottoVc = [[DailyLottoViewController alloc] init];
            [self.viewController.navigationController pushViewController:lottoVc animated:YES];
        }
            break;
        case 2:
        {///邀请好友
            if (![MDB_UserDefault getIsLogin]){
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                                    message:@"请登录后再试"
                                                                   delegate:self
                                                          cancelButtonTitle:nil
                                                          otherButtonTitles:@"登录",@"取消", nil];
                [alertView setTag:110];
                [alertView show];
                return;
            }
            [MobClick event:@"wode_yaoqing"];
            InviteFriendViewController *inviteFridendVc = [[InviteFriendViewController alloc] init];
            [self.viewController.navigationController pushViewController:inviteFridendVc animated:YES];
        }
            break;
        case 3:
        {///兑换
            if (![MDB_UserDefault getIsLogin]){
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                                    message:@"请登录后再试"
                                                                   delegate:self
                                                          cancelButtonTitle:nil
                                                          otherButtonTitles:@"登录",@"取消", nil];
                [alertView setTag:110];
                [alertView show];
                return;
            }
            [MobClick event:@"zhuye_fuli"];
            WelfareHomeViewController *welfareHomeVc = [[WelfareHomeViewController alloc] init];
            [self.viewController.navigationController pushViewController:welfareHomeVc animated:YES];
            
//            [MobClick event:@"wode_duihuan"];
//            ConversionViewController *conversionVc = [[ConversionViewController alloc] init];
//            [self.viewController.navigationController pushViewController:conversionVc animated:YES];
            
        }
            break;
        case 4:
        {///逢节送礼
            [MobClick event:@"zhuye_songli"];
            SendGiftViewController *vc = [[SendGiftViewController alloc] init];
            [self.viewController.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 5:
        {///签到
            [MobClick event:@"zhuye_qiandao"];
            SignInViewController *vc = [[SignInViewController alloc] init];
            [self.viewController.navigationController pushViewController:vc animated:YES];
        }
            break;
        default:
            break;
    }
}
#pragma mark -///比比活动点击
-(void)BiBiActivityViewAction:(NSInteger)index
{
    NSArray *recommendContents = jingxuanModel.activities;
    HomeActivitieViewModel *model = recommendContents[index];
    ActivityType type = model.activityType;
    
    @try
    {
        if(type != ActivityTypeNormal && type != ActivityTypeBargain && type != ActivityTypeAccumulate)
        {
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
    
    if (type == ActivityTypeNormal) {
        if(model.activityID == nil)
        {
            return;
        }
        CommentRewardsViewController *commentRewardsVc = [[CommentRewardsViewController alloc] init];
        commentRewardsVc.activityId = model.activityID;
        [self.viewController.navigationController pushViewController:commentRewardsVc animated:YES];
    }else if (type == ActivityTypeAccumulate){
        if(model.activityID == nil)
        {
            return;
        }
        RecommendActivityViewController *recommendActivity = [[RecommendActivityViewController alloc] init];
        recommendActivity.recommendId = model.activityID;
        [self.viewController.navigationController pushViewController:recommendActivity animated:YES];
    }else if (type == ActivityTypeBargain){
        BargainActivityViewController *vc = [[BargainActivityViewController alloc] initWithActivityID:model.activityID];
        [self.viewController.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark - 热门推荐点击
- (void)homeHotViewDidClichkCurrentHotWithItem:(HomeHotSticksViewModel *)item
{
    
    [MobClick event:@"zhuye_remen"];
    if ([[NSString nullToString:item.linkType] isEqualToString:@"0"]) {
        SVModalWebViewController  *svweb=[[SVModalWebViewController alloc] initWithAddress:[NSString nullToString:item.link]];
        svweb.modalTransitionStyle=UIModalTransitionStylePartialCurl;
        [self.viewController presentViewController:svweb animated:NO completion:nil];
    }else if([[NSString nullToString:item.linkType] isEqualToString:@"1"]){
        ProductInfoViewController *productInfoVc = [[ProductInfoViewController alloc] init];
        productInfoVc.productId = [NSString nullToString:item.linkId];
        [self.viewController.navigationController pushViewController:productInfoVc animated:YES];
    }else if([[NSString nullToString:item.linkType] isEqualToString:@"2"]){
        OriginalDetailViewController *shareContVc = [[OriginalDetailViewController alloc] initWithOriginalID:[NSString stringWithFormat:@"%@",item.linkId]];
        [self.viewController.navigationController pushViewController:shareContVc animated:YES];
    }
}

#pragma mark - 白菜精选
- (void)baiCaiDidClichkCurrentHotWithItem:(HomeCheapViewModel *)item
{
    ProductInfoViewController *productInfoVc = [[ProductInfoViewController alloc] init];
    productInfoVc.productId = [NSString nullToString:item.commodityID];
    [self.viewController.navigationController pushViewController:productInfoVc animated:YES];
}

#pragma mark - 热门专题
///热门专题
- (void)sepcialProtalTableViewDidSelectSpecial:(NSString *)specialID andtype:(int)type
{
    [MobClick event:@"zhuye_zhuanti"];
    if(type==1)
    {
        SpecialInfoViewController *specialInfoVc = [[SpecialInfoViewController alloc] initWithSpecialInfo:specialID];
        [self.viewController.navigationController pushViewController:specialInfoVc animated:YES];
    }
    else if (type == 2)
    {
        UIStoryboard *mainbord=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
        ShowActiveViewController *showAct=[mainbord instantiateViewControllerWithIdentifier:@"com.mbd.ShowActiveViewC"];
        showAct.url=[NSString nullToString:specialID];
        showAct.title= @"专题详情";
        showAct.external = YES;
        [self.viewController.navigationController pushViewController:showAct animated:YES];
    }
    
}
///更多
- (void)homeSepcialProtalViewDidClickMoreBtn
{
    [MobClick event:@"zhuye_gengduo"];
    SpecicalIndexViewController *indexVc = [[SpecicalIndexViewController alloc] init];
    [self.viewController.navigationController pushViewController:indexVc animated:YES];
}

#pragma mark - 点击查看更多优惠
-(void)footerbottomAction
{
    NSLog(@"sdfasdfds");
    [[NSNotificationCenter defaultCenter] postNotificationName:@"tabbarselectother" object:@"1"];
}

#pragma mark - banaer 设置
- (void)imagePlayerView:(ImagePlayerView *)imagePlayerView loadImageForImageView:(UIImageView *)imageView index:(NSInteger)index
{
    if (_bannerImages.count>index) {
        [[MDB_UserDefault defaultInstance]setViewImageWithURL:[NSURL URLWithString:[NSString nullToString:_bannerImages[index][@"imgUrl"]]] placeholder:[UIImage imageNamed:@"Active.jpg"] UIimageview:imageView];
    }
}
- (void)imagePlayerView:(ImagePlayerView *)imagePlayerView didTapAtIndex:(NSInteger)index
{
    [MobClick event:@"zhuye_banner"];
    NSDictionary *bannerInfoDict = _bannerImages[index];
    if ([[NSString nullToString:bannerInfoDict[@"linkType"]] isEqualToString:@"0"]) {
        SVModalWebViewController  *svweb=[[SVModalWebViewController alloc] initWithAddress:[NSString nullToString:bannerInfoDict[@"link"]]];
        svweb.modalTransitionStyle=UIModalTransitionStylePartialCurl;
        [self.viewController presentViewController:svweb animated:NO completion:nil];
    }else if([[NSString nullToString:bannerInfoDict[@"linkType"]] isEqualToString:@"1"]){
        ProductInfoViewController *productInfoVc = [[ProductInfoViewController alloc] init];
        productInfoVc.productId = [NSString nullToString:bannerInfoDict[@"linkId"]];
        [self.viewController.navigationController pushViewController:productInfoVc animated:YES];
    }else if([[NSString nullToString:bannerInfoDict[@"linkType"]] isEqualToString:@"2"]){
        OriginalDetailViewController *shareContVc = [[OriginalDetailViewController alloc] initWithOriginalID:[NSString stringWithFormat:@"%@",bannerInfoDict[@"linkId"]]];
        [self.viewController.navigationController pushViewController:shareContVc animated:YES];
    }
}

#pragma mark - UITableView Datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _tableRowNumber.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ContentCell *cell = [tableView dequeueReusableCellWithIdentifier:kTableViewCellIdentifier];
    [cell fetchCommodityData:_tableRowNumber[indexPath.row]];
    return cell;
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
//    [self.delegate jingxuanListCellSelectAction:_tableRowNumber[indexPath.row]];
    
    Commodity *model = _tableRowNumber[indexPath.row];
    model.isSelect = YES;
    
    [tableView reloadData];
    
    ProductInfoViewController *productInfoVc = [[ProductInfoViewController alloc] init];
    productInfoVc.productId = [NSString nullToString:model.commodityid];
    [self.viewController.navigationController pushViewController:productInfoVc animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 125;
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0 && alertView.tag == 110) {
        VKLoginViewController *vkVc = [[VKLoginViewController alloc] init];
        [self.viewController.navigationController pushViewController:vkVc animated:YES];
    }
}


- (UIControl *)setupHandleElementWithName:(NSString *)name
                                     icon:(UIImage *)icon
                                 isSelect:(BOOL)select
                           showBottomView:(BOOL)isShow
                                nameColor:(UIColor *)color{
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
    nameLabel.textColor = color;
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



- (NSArray *)handleImages{
    if (!_handleImages) {
        _handleImages = @[
                          @{@"image":[UIImage imageNamed:@"main_home_yhq"],
                            @"name":@"优惠券"},
                          @{@"image":[UIImage imageNamed:@"main_home_cj"],
                            @"name":@"抽奖"},
                          @{@"image":[UIImage imageNamed:@"main_home_yqhy"],
                            @"name":@"邀请好友"},
                          @{@"image":[UIImage imageNamed:@"main_home_dh"],
                            @"name":@"兑换"},
                          @{@"image":[UIImage imageNamed:@"main_home_fjsl"],
                            @"name":@"逢节送礼"},
                          @{@"image":[UIImage imageNamed:@"main_home_qd"],
                            @"name":@"签到"}
                          ];
    }
    return _handleImages;
}

@end
