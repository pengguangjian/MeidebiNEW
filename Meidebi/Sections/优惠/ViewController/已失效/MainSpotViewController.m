//
//  MainSpotViewController.m
//  mdb
//  暂未使用
//  Created by 杜非 on 14/12/19.
//  Copyright (c) 2014年 meidebi. All rights reserved.
//

#import "CheapOrOutsideViewController.h"
#import "HTTPManager.h"
#import "MDB_UserDefault.h"
#import "MainSpotViewController.h"
#import "NJCustomPushView.h"
#import "NJPushSetAlertView.h"
#import "NJScrollTableView.h"
#import "ProductInfoViewController.h"
#import "SearchViewController.h"
#import "ShowActiveViewController.h"
//#import "UMessage.h"
#import <UMPush/UMessage.h>
#import "WareTableViewController.h"
#import <CYLTabBarController/CYLTabBarController.h>
#import "UITabBar+badge.h"
#import "HandleAlertView.h"
#import "FMDBHelper.h"
#import "SearchHomeViewController.h"
#import "FilterTypeHomeViewController.h"
#import "ADHandleViewController.h"
#import "GMDCircleLoader.h"
#import "HomeNavTitleView.h"
#import <UMAnalytics/MobClick.h>

#import "Article.h"

static NSString * const kStatusBarTappedNotification = @"statusBarTappedNotification";
//static CGFloat const kTabBarTopPadding = 12;  // default 5
@interface MainSpotViewController ()
<
UIScrollViewDelegate,
NJCustomPushViewDelegate,
ScrollTabViewDataSource,
WaresTableViewDelegate,
HandleAlertViewDelegate,
HomeNavTitleViewDelegate
>

@property (nonatomic, assign) NSInteger currentIndex;
@property (nonatomic, assign) int          isHot;
@property (nonatomic, strong) NJScrollTableView *scrollTableView;
@property (nonatomic, strong) NSMutableArray *waresTables;
@property (nonatomic, strong) UISegmentedControl *segementControl;
@property (nonatomic, strong) HomeNavTitleView *homeTitleView;
@end

@implementation MainSpotViewController{
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _waresTables = [NSMutableArray array];
    _isHot=1;
    _currentIndex = 0;
    [self leftBarButton];
    [self rightBarButton];
    self.navigationItem.titleView = [self titleView];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [[FMDBHelper shareInstance] createArticleTable];
    [GMDCircleLoader setOnView:self.view withTitle:nil animated:YES];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [GMDCircleLoader hideFromView:self.view animated:YES];
    });
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(statusBarTappedAction:)
                                                 name:kStatusBarTappedNotification
                                               object:nil];
    [self loadSearchKeyword];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self setupSubViews];

}
- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:kStatusBarTappedNotification
                                                  object:nil];
   
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

//- (void)setNavgationStaue{
//    if (_scrollTableView.frame.origin.y == 20) {
//        [self.navigationController.navigationBar setCenter:CGPointMake(self.view.frame.size.width/2.0, -22)];
//        [self hiddenTabBarWithAnimation:NO];
//    }
//}

- (void)setupSubViews{
    if (_waresTables.count > 0) return;
    WareTableViewController *artTable = [[WareTableViewController alloc] init];
    artTable.title = @"全部";
    artTable.wareType = WareTypeAll;
    artTable.delegate = self;
    [_waresTables addObject:artTable];
    
    WareTableViewController *artGNTable = [[WareTableViewController alloc] init];
    artGNTable.title = @"国内";
    artGNTable.wareType = WareTypeGuoNei;
    artGNTable.delegate = self;
    [_waresTables addObject:artGNTable];
    
    WareTableViewController *artHTTable = [[WareTableViewController alloc] init];
    artHTTable.title = @"海淘";
    artHTTable.wareType = WareTypeHaiTao;
    artHTTable.delegate = self;
    [_waresTables addObject:artHTTable];
    
    WareTableViewController *artTMTable = [[WareTableViewController alloc] init];
    artTMTable.title = @"猫实惠";
    artTMTable.wareType = WareTypeTianMao;
    artTMTable.delegate = self;
    [_waresTables addObject:artTMTable];
    _scrollTableView = [[NJScrollTableView alloc] initWithFrame:CGRectMake(0, kTopHeight, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame)-(kTopHeight+kTabBarHeight)/* statueBar height + tabbar height*/)];
    _scrollTableView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_scrollTableView];
    _scrollTableView.dataSource = self;
    [_scrollTableView buildUI];
    [_scrollTableView selectTabWithIndex:0 animate:NO];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [[FMDBHelper shareInstance] clearArticleTable];
    });
}


//- (void)hiddenTabBarWithAnimation:(BOOL)isAnimation{
//    CGFloat durationTime = 0.00;
//    if (isAnimation) {
//        durationTime = 0.5;
//    }else{
//        durationTime = 0;
//    }
//    if ([self.parentViewController.parentViewController isKindOfClass:[CYLTabBarController class]]) {
//       CYLTabBarController *tabBarVc=(CYLTabBarController *)self.parentViewController.parentViewController;
//        [UIView animateWithDuration:durationTime animations:^{
//            tabBarVc.tabBar.frame = CGRectMake(0, CGRectGetHeight(self.view.frame)+kTabBarTopPadding, CGRectGetWidth(self.view.frame), CGRectGetHeight(tabBarVc.tabBar.frame));
//        } completion:^(BOOL finished) {
//            tabBarVc.tabBar.hidden = YES;
//        }];
//    }
//}
//
//- (void)showTabBarWithAnimation:(BOOL)isAnimation{
//    CGFloat durationTime = 0.00;
//    if (isAnimation) {
//        durationTime = 0.5;
//    }else{
//        durationTime = 0;
//    }
//    if ([self.parentViewController.parentViewController isKindOfClass:[CYLTabBarController class]]) {
//        CYLTabBarController *tabBarVc=(CYLTabBarController *)self.parentViewController.parentViewController;
//        __block CGRect barFrame = tabBarVc.tabBar.frame;
//        if (CGRectGetMinY(barFrame) == CGRectGetHeight(self.view.frame)-CGRectGetHeight(barFrame)) {
//            barFrame.origin.y = CGRectGetHeight(self.view.frame)+CGRectGetHeight(barFrame);
//            tabBarVc.tabBar.frame = barFrame;
//            tabBarVc.tabBar.hidden = YES;
//        }
//        [UIView animateWithDuration:durationTime animations:^{
//            barFrame.origin.y = CGRectGetHeight(self.view.frame)-CGRectGetHeight(barFrame);
//            tabBarVc.tabBar.frame = barFrame;
//            tabBarVc.tabBar.hidden = NO;
//        } completion:^(BOOL finished) {
//
//        }];
//
//    }
//}
-(void)setAppconfigU{
   
    [HTTPManager sendRequestUrlToService:URL_getcatgorys
                 withParametersDictionry:@{@"ismain":@"1"}
                                    view:nil
                          completeHandle:^(NSURLSessionTask *opration, id responceObjct, NSError *error) {
        if (responceObjct) {
            NSString *str=[[NSString alloc]initWithData:responceObjct encoding:NSUTF8StringEncoding];
            NSDictionary *dicAll=[str JSONValue];
            if ([[dicAll objectForKey:@"info"]isEqualToString:@"GET_DATA_SUCCESS"]&&[dicAll objectForKey:@"status"]) {
                NSArray *arr=[dicAll objectForKey:@"data"];
                if (arr&&arr.count>0) {
                    [self setArrCN:arr];
                }
            }
        }
    }];
}
-(void)setArrCN:(NSArray *)arrCn{
    NJCustomPushView *pushView = [[NJCustomPushView alloc] init];
    pushView.headerTitle = @"自定义推送，我的购物我做主！";
    pushView.delegate = self;
    pushView.contentArr = arrCn;
    [pushView show];
}


- (void)statusBarTappedAction:(NSNotification*)notification {
    if (_currentIndex > _waresTables.count-1) return;
    WareTableViewController *wareTableVc = (WareTableViewController *)_waresTables[_currentIndex];
    [wareTableVc scrollTop];
}

#pragma mark - NJCustomPushViewDelegate
- (void)pushCategoryViewDidPressNoPush{
    [self setUmengConfigOfCate:@"" org:@""];
}
- (void)pushCategoryView:(NJCustomPushView *)customPushView ensureOfCates:(NSArray *)categorys orgs:(NSArray *)orgs{
    
    [customPushView removeFromSuperview];
    
    [MDB_UserDefault setPushCats:categorys];
    [MDB_UserDefault setPushSources:orgs];
    
    NSString *cate = [categorys componentsJoinedByString:@","];
    NSString *org = [orgs componentsJoinedByString:@","];
    [self setUmengConfigOfCate:cate org:org];
}

- (void)setUmengConfigOfCate:(NSString *)cate org:(NSString *)org{
    
    NSString *clientstatus = @"0";
    if ([[NSString nullToString:cate] isEqualToString:@""] && [[NSString nullToString:org] isEqualToString:@""]) {
        clientstatus = @"1";
    }
     NSDictionary *prama=@{@"userkey":[NSString nullToString:[MDB_UserDefault defaultInstance].usertoken],
                          @"umengtoken":[NSString nullToString:[MDB_UserDefault getUmengDeviceToken]],
                          @"cates":[NSString nullToString:cate],
                          @"orgs":[NSString nullToString:org],
                          @"issound":@"1",
                          @"isvibrate":@"1",
                          @"minh":@"22",
                          @"maxh":@"8",
                          @"clientstatus":clientstatus};
    [HTTPManager sendRequestUrlToService:URL_umengconfig withParametersDictionry:prama view:self.view completeHandle:^(NSURLSessionTask *opration, id responceObjct, NSError *error) {
        if (responceObjct == nil) return ;
        NSString *str=[[NSString alloc]initWithData:responceObjct encoding:NSUTF8StringEncoding];
        NSDictionary *dicAll=[str JSONValue];
        if ([[dicAll objectForKey:@"info"]isEqualToString:@"GET_DATA_SUCCESS"]&&[dicAll objectForKey:@"status"]) {
            
            if (![[NSString nullToString:cate] isEqualToString:@""] || ![[NSString nullToString:org] isEqualToString:@""]) {
                NJPushSetAlertView *alertView = [NJPushSetAlertView new];
                [alertView show];
            }
          
        }
    }];
    [MDB_UserDefault setAaronLiEndDate:@"8"];
    [MDB_UserDefault setAaronLiStarDate:@"22"];

}

#pragma mark - WaresTableViewDelegate

-(void)tableViewSelecte:(Article *)art withTableVc:(WareTableViewController *)vc{
    if (vc.wareType == WareTypeAll) {
        [MobClick event:@"youhui_quanbu"];
    }else if (vc.wareType == WareTypeGuoNei){
        [MobClick event:@"youhui_guonei"];
    }else if (vc.wareType == WareTypeHaiTao){
        [MobClick event:@"youhui_haitao"];
    }else if (vc.wareType == WareTypeTianMao){
        [MobClick event:@"youhui_maoshihui"];
    }
    
    art.isSelected = YES;
    
    ProductInfoViewController *productInfoVc = [[ProductInfoViewController alloc] init];
    productInfoVc.theObject = art;
    [self.navigationController pushViewController:productInfoVc animated:YES];
}

- (void)tableViewDidSelectHeaderBarView:(NSString *)type{
    CheapOrOutsideViewController *cheapVc = [[CheapOrOutsideViewController alloc] init];
    cheapVc.type = type;
    [self.navigationController pushViewController:cheapVc animated:YES];
}

- (void)bannerViewDidSelectWithUrl:(NSString *)urlStr title:(NSString *)title{
    UIStoryboard *mainbord=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
    ShowActiveViewController *showAct=[mainbord instantiateViewControllerWithIdentifier:@"com.mbd.ShowActiveViewC"];
    showAct.url=urlStr;
    showAct.title=title;
    [self.navigationController pushViewController:showAct animated:YES];
}


#pragma mark - ScorllTableViewDelegate
- (NSUInteger)numberOfPagers:(NJScrollTableView *)view{
    return _waresTables.count;
}

- (UITableViewController *)scrollTableViewOfPagers:(NJScrollTableView *)view
                                     indexOfPagers:(NSUInteger)index{
    [_waresTables[index] updateData];
    return _waresTables[index];
}

- (void)whenSelectOnPager:(NSUInteger)number{
    _currentIndex = number;
}

-(void)rightBarButton{
     _segementControl=[[UISegmentedControl alloc]initWithItems:@[@"精华",@"最新"]];
    [_segementControl setFrame:CGRectMake(0, 20, 80, 28)];
    [_segementControl setTintColor:RadMenuColor];
    [_segementControl.layer setMasksToBounds:YES];
    [_segementControl.layer setCornerRadius:4.f];
    [_segementControl.layer setBorderWidth:1.f];
    [_segementControl.layer setBorderColor:RadMenuColor.CGColor];
    if (_isHot==0) {
        _segementControl.selectedSegmentIndex=1;
    }else{
        _segementControl.selectedSegmentIndex=0;
    }
    UIBarButtonItem *rightBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:_segementControl];
    [_segementControl addTarget:self action:@selector(segebtnValueChanged:) forControlEvents:UIControlEventValueChanged];
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    [negativeSpacer setWidth:-5];
    self.navigationItem.rightBarButtonItems = @[negativeSpacer, rightBarButtonItem];
}

-(void)segebtnValueChanged:(UISegmentedControl *)sender{
    
    if (sender.selectedSegmentIndex==0) {
        _isHot=1;
        for (WareTableViewController *waresTableVc in _waresTables) {
            waresTableVc.requestType = WareRequestTypeEssence;
            [waresTableVc updateData];
        }
    }else if(sender.selectedSegmentIndex==1){
        _isHot=0;
        for (WareTableViewController *waresTableVc in _waresTables) {
             waresTableVc.requestType = WareRequestTypeNew;
            [waresTableVc updateData];
        }
    }
}

-(void)leftBarButton{
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    [negativeSpacer setWidth:-10];
    UIButton *butleft=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 52, 44)];
    [butleft addTarget:self action:@selector(leftBarBut) forControlEvents:UIControlEventTouchUpInside];
    [butleft setImage:[UIImage imageNamed:@"home_filter"] forState:UIControlStateNormal];
    [butleft setImage:[UIImage imageNamed:@"home_filter"] forState:UIControlStateHighlighted];
    [butleft setTitle:@"筛选" forState:UIControlStateNormal];
    [butleft setTitleColor:[UIColor colorWithHexString:@"#333333"] forState:UIControlStateNormal];
    [butleft.titleLabel setFont:[UIFont systemFontOfSize:14.f]];
    [butleft setTitleEdgeInsets:UIEdgeInsetsMake(0, 5, 0, -5)];
    UIBarButtonItem *leftBar=[[UIBarButtonItem alloc]initWithCustomView:butleft];
    self.navigationItem.leftBarButtonItems = @[negativeSpacer, leftBar];
}
-(void)leftBarBut{
    FilterTypeHomeViewController *filterVc = [[FilterTypeHomeViewController alloc] init];
    if (![_homeTitleView.searchHotKeyWord isEqualToString:kDefaultHotSearchStr]) {
        filterVc.hotSearchStr = _homeTitleView.searchHotKeyWord;
    }
    [self.navigationController pushViewController:filterVc animated:YES];
}

-(UIView *)titleView{
    HomeNavTitleView *titleView =[[HomeNavTitleView alloc] initWithFrame:self.navigationController.navigationBar.bounds];
    [titleView setBackgroundColor:self.navigationController.view.backgroundColor];
    titleView.delegate = self;
    _homeTitleView = titleView;
    titleView.searchHotKeyWord = kDefaultHotSearchStr;
    return titleView;
}

-(void)getUserCont{
    if ([MDB_UserDefault getIsLogin]) {
        NSDictionary *dic=@{@"userkey":[NSString nullToString:[MDB_UserDefault defaultInstance].usertoken],
                            @"type":@"1"
                            };
        [HTTPManager sendRequestUrlToService:URL_usercenter withParametersDictionry:dic view:nil completeHandle:^(NSURLSessionTask *opration, id responceObjct, NSError *error) {
            if (responceObjct){
                NSString *str=[[NSString alloc]initWithData:responceObjct encoding:NSUTF8StringEncoding];
                NSDictionary *dicAll=[str JSONValue];
                if ([[dicAll objectForKey:@"status"]intValue] == 1) {
                    if ([dicAll objectForKey: @"data"]&&[[dicAll objectForKey:@"data"]isKindOfClass:[NSDictionary class]]) {
                        if ([[[dicAll objectForKey:@"data"] objectForKey:@"commentnum"] intValue]>0) {
                            [MDB_UserDefault setComment:YES];
                            [self.navigationController.tabBarController.tabBar showBadgeOnItemIndex:4];
                        }
                        
                    }
                }
            }
        }];

    }
}

- (void)loadSearchKeyword{
    [HTTPManager sendRequestUrlToService:URL_searchkeyword withParametersDictionry:nil view:nil completeHandle:^(NSURLSessionTask *opration, id responceObjct, NSError *error) {
        if (responceObjct){
            NSString *str=[[NSString alloc]initWithData:responceObjct encoding:NSUTF8StringEncoding];
            NSDictionary *dicAll=[str JSONValue];
            if ([[dicAll objectForKey:@"status"]intValue] == 1) {
                NSString *hotSearchKey = @"";
                if ([dicAll[@"data"] isKindOfClass:[NSString class]]) {
                    hotSearchKey = [NSString nullToString:dicAll[@"data"]];
                }
                if ([hotSearchKey isEqualToString:@""]) {
                    _homeTitleView.searchHotKeyWord = kDefaultHotSearchStr;
                }else{
                    _homeTitleView.searchHotKeyWord = [NSString nullToString:dicAll[@"data"]];
                }
            }
        }
    }];
}

#pragma mark - HandleAlertViewDelegate
- (void)handleAlertViewDidePressDismissBtn{
    if ([MDB_UserDefault getUmengfirestStatue]&&[MDB_UserDefault getUmengDeviceToken]) {
//        [self setAppconfigU];
    }
}

#pragma mark - HomeNavTitleViewDelegate
- (void)titleViewDidClickSearchWithHotWord:(NSString *)keyword{
    SearchHomeViewController *searchHomeVc = [[SearchHomeViewController alloc] init];
    if (![_homeTitleView.searchHotKeyWord isEqualToString:kDefaultHotSearchStr]) {
        searchHomeVc.hotSearchStr = _homeTitleView.searchHotKeyWord;
    }
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:searchHomeVc];
    [self presentViewController:nav animated:NO completion:nil];
}

@end
