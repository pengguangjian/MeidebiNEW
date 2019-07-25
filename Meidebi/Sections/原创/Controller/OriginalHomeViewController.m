//
//  OriginalHomeViewController.m
//  Meidebi
//  原创首页
//  Created by ZlJ_losaic on 2017/9/21.
//  Copyright © 2017年 meidebi. All rights reserved.
//

#import "OriginalHomeViewController.h"
#import "PersonalInfoIndexViewController.h"
#import "OriginalDetailViewController.h"
#import "OriginalDatacontroller.h"
#import "SVModalWebViewController.h"
#import "ProductInfoViewController.h"
#import "ProductInfoDataController.h"
#import "OriginalSearchResultViewController.h"
#import "VKLoginViewController.h"
#import "MDB_UserDefault.h"
#import "GMDCircleLoader.h"
#import "TKExploreSubjectView.h"
#import "TKTopicViewController.h"

#import "TKExploreSearchWriteView.h"

#import "TKTopicComposeViewController.h"

#import "PushYuanChuangViewController.h"

@interface OriginalHomeViewController ()
<
UIAlertViewDelegate,
TKExploreSubjectViewDelegate
>
@property (nonatomic, strong) TKExploreSubjectView *subjectView;
@property (nonatomic, strong) UIButton *writeBtn;
@property (nonatomic, strong) OriginalDatacontroller *datacontroller;
@property (nonatomic, strong) ProductInfoDataController *productDataController;
@property (nonatomic, strong) TKExploreSearchWriteView *seachView;
@end

@implementation OriginalHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.title = @"原创";
    [self drawRightNavBt];
    [self setupSubviews];
    [self loadOriginalListData];
    [self loadOriginalIndexData];
    
}

-(void)searchView
{
    if(_seachView==nil)
    {
        _seachView = [[TKExploreSearchWriteView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenW-65, self.navigationController.navigationBar.height)];
        _seachView.nvc = self.navigationController;
        [self.navigationController.navigationBar addSubview:_seachView];
    }
    
    [_seachView setHidden:NO];
    [self.navigationController.navigationBar bringSubviewToFront:_seachView];
    
}

-(void)drawRightNavBt
{
//    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
//    [negativeSpacer setWidth:-7];
//
//
//    UIView *rightV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 65, 44)];
//
//    UIButton *butright=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 65, 44)];
//    [butright addTarget:self action:@selector(rightBarClicked) forControlEvents:UIControlEventTouchUpInside];
//    [butright setTitle:@"发布原创" forState:UIControlStateNormal];
//    [butright setTitleColor:RadMenuColor forState:UIControlStateNormal];
//    [butright.titleLabel setFont:[UIFont fontWithName:@"Arial-BoldMT" size:14]];
//    [butright setTitleEdgeInsets:UIEdgeInsetsMake(0, 6, 0, -6)];
//    //    [butright setImageEdgeInsets:UIEdgeInsetsMake(0, 0, -1, 0)];
//
//    [rightV addSubview:butright];
//    UIBarButtonItem *rightBar=[[UIBarButtonItem alloc]initWithCustomView:rightV];
//    self.navigationItem.rightBarButtonItems = @[negativeSpacer, rightBar];
    
    
    
    UIButton* btnright = [UIButton buttonWithType:UIButtonTypeCustom];//btnLeft.backgroundColor=[UIColor redColor];
    btnright.frame = CGRectMake(0,0,60,44);
    [btnright setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
    [btnright setTitle:@"发布原创" forState:UIControlStateNormal];
    [btnright setTitleColor:RadMenuColor forState:UIControlStateNormal];
    [btnright.titleLabel setFont:[UIFont fontWithName:@"Arial-BoldMT" size:14]];
    [btnright addTarget:self action:@selector(rightBarClicked) forControlEvents:UIControlEventTouchUpInside];
    [btnright setTitleEdgeInsets:UIEdgeInsetsMake(0, 12, 0, -12)];
    UIBarButtonItem* rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btnright];
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
    
}

-(void)rightBarClicked
{
    [self originalSubjectViewpushYuanChuangAction];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
    
    [self searchView];
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self searchView];
    NSString *strtemp = [[NSUserDefaults standardUserDefaults] objectForKey:@"yuanchuangfabugengxin"];
    if(strtemp.integerValue == 1)
    {
        [self loadOriginalListData];
        [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:@"yuanchuangfabugengxin"];
    }

    
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [GMDCircleLoader hideFromView:self.view animated:YES];
    [_seachView setHidden:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)setupSubviews{
    
    
    float ftopheith =  kStatusBarHeight+44;
    float fother = 34.0;
    if(ftopheith<66)
    {
        ftopheith = 64;
        fother = 0;
    }
    ///CGRectMake(0, ftopheith, BOUNDS_WIDTH, BOUNDS_HEIGHT-ftopheith-fother-kTabBarHeight)
    
    _subjectView = [TKExploreSubjectView new];
    [self.view addSubview:_subjectView];
    [_subjectView mas_makeConstraints:^(MASConstraintMaker *make) {
        if (@available(iOS 11.0, *)) {
            make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop);
            make.left.equalTo(self.view.mas_safeAreaLayoutGuideLeft);
            make.right.equalTo(self.view.mas_safeAreaLayoutGuideRight);
            make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom);
        }else{
            make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(kTopHeight, 0, 0, 0));
//            make.edges.equalTo(self.view);
        }
    }];
    _subjectView.delegate = self;
}

- (void)loadOriginalListData{
    [GMDCircleLoader setOnView:self.view withTitle:nil animated:YES];
    [self.datacontroller requestOriginalListTargetView:nil
                                              callback:^(NSError *error, BOOL state, NSString *describle) {
                                           [GMDCircleLoader hideFromView:self.view animated:YES];
                                           [self renderSubjectView];
                                           if (!state) {
                                               [MDB_UserDefault showNotifyHUDwithtext:describle inView:self.view];
                                           }
                                           _writeBtn.hidden = NO;
    }];
}

- (void)loadOriginalIndexData{
    [self.datacontroller requestOriginalIndexDataCallback:^(NSError *error, BOOL state, NSString *describle) {
        if (state) {
            [_subjectView bindOriginalRelevanceDataWithModel:self.datacontroller.resultDict];
        }
    }];
}

- (void)renderSubjectView{
    NSMutableArray *originals = [NSMutableArray array];
    for (NSDictionary *dict in self.datacontroller.results) {
        TKTopicListViewModel *model = [TKTopicListViewModel viewModelWithSubject:dict];
        if (model) {
            [originals addObject:model];
        }
    }
    [_subjectView bindeTopicData:originals.mutableCopy];
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex==0) {
        VKLoginViewController*theViewController= [[VKLoginViewController alloc] init];
        [self.navigationController pushViewController:theViewController animated:YES ];
    }
}



#pragma mark - TKExploreSubjectViewDelegate
///发布原创
- (void)originalSubjectViewpushYuanChuangAction
{
    if ([MDB_UserDefault getIsLogin]) {
//        TKTopicComposeViewController *vc = [[TKTopicComposeViewController alloc] initWithTopicType:0];
//        [self.navigationController pushViewController:vc animated:YES];
        
        PushYuanChuangViewController *vc = [[PushYuanChuangViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
        
        
    }else{
        VKLoginViewController *vc = [[VKLoginViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
}
//int itemp = 0;
- (void)exploreSubjectViewDidSelectTopicType:(TKTopicType)type{
//    itemp++;
    [_seachView.searchField resignFirstResponder];
    TKTopicViewController *vc = [[TKTopicViewController alloc] initWithTopicType:type];
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)exploreSubjectViewDidSelectItemID:(NSString *)itemID{
    [_seachView.searchField resignFirstResponder];
    OriginalDetailViewController *vc = [[OriginalDetailViewController alloc] initWithOriginalID:itemID];
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)originalSubjectViewDidClickAvaterImageView:(NSString *)userID{
    [_seachView.searchField resignFirstResponder];
    PersonalInfoIndexViewController *vc = [[PersonalInfoIndexViewController alloc] initWithUserID:userID];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)originalSubjectViewDidClickFollowBtn:(NSString *)userID complete:(void (^)(BOOL))callback{
    [_seachView.searchField resignFirstResponder];
    if ([MDB_UserDefault getIsLogin]) {
        [self.productDataController requestAddFollwDataWithInView:_subjectView userid:userID callback:^(NSError *error, BOOL state, NSString *describle) {
            callback(state);
            if (!state){
                [MDB_UserDefault showNotifyHUDwithtext:describle inView:_subjectView];
            }
        }];
    }else{
        VKLoginViewController* theViewController= [[VKLoginViewController alloc] init];
        [self.navigationController pushViewController:theViewController animated:YES ];
    }
    
}

- (void)exploreSubjectViewDidClickBannerWithItem:(NSDictionary *)item{
    [_seachView.searchField resignFirstResponder];
    if ([[NSString nullToString:item[@"linkType"]] isEqualToString:@"0"]) {
        SVModalWebViewController  *svweb=[[SVModalWebViewController alloc] initWithAddress:[NSString nullToString:item[@"link"]]];
        svweb.modalTransitionStyle=UIModalTransitionStylePartialCurl;
        [self presentViewController:svweb animated:NO completion:nil];
    }else if([[NSString nullToString:item[@"linkType"]] isEqualToString:@"1"]){
        ProductInfoViewController *productInfoVc = [[ProductInfoViewController alloc] init];
        productInfoVc.productId = [NSString nullToString:item[@"linkId"]];
        [self.navigationController pushViewController:productInfoVc animated:YES];
    }else if([[NSString nullToString:item[@"linkType"]] isEqualToString:@"2"]){
        OriginalDetailViewController *vc = [[OriginalDetailViewController alloc] initWithOriginalID:[NSString nullToString:item[@"linkId"]]];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)lastPage{
    [self.datacontroller lastNewPageDataWithCallback:^(NSError *error, BOOL state, NSString *describle) {
        if (state) {
            [self renderSubjectView];
        }
        else
        {
            [_subjectView bindeTopicData:nil];
        }
    }];
    [self loadOriginalIndexData];
}

- (void)nextPage{
    [self.datacontroller nextPageDataWithCallback:^(NSError *error, BOOL state, NSString *describle) {
        if (state) {
            [self renderSubjectView];
        }
    }];
}

- (void)scrollRollView
{
    [_seachView.searchField resignFirstResponder];
}

- (void)photoGroupView:(YYPhotoGroupView *)photoGroupView didClickImageView:(UIView *)fromeView{
    [photoGroupView presentFromImageView:fromeView
                             toContainer:self.tabBarController.view
                                animated:YES
                              completion:nil];
}

- (void)exploreSubjectViewDidCickAvaterViewWithUserid:(NSString *)userid{
    if (userid.length <= 0) return;
    PersonalInfoIndexViewController *personalInfoVc = [[PersonalInfoIndexViewController alloc] initWithUserID:userid];
    [self.navigationController pushViewController:personalInfoVc animated:YES];
}

#pragma mark - setters and getters
- (OriginalDatacontroller *)datacontroller{
    if (!_datacontroller) {
        _datacontroller = [[OriginalDatacontroller alloc] init];
    }
    return _datacontroller;
}

- (ProductInfoDataController *)productDataController{
    if (!_productDataController) {
        _productDataController = [[ProductInfoDataController alloc] init];
    }
    return _productDataController;
}

@end
