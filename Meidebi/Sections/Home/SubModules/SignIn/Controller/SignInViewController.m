//
//  SignInViewController.m
//  Meidebi
//
//  Created by fishmi on 2017/5/16.
//  Copyright © 2017年 meidebi. All rights reserved.
//

#import "SignInViewController.h"
#import "SignInView.h"
#import "SignInDataController.h"
#import "MDB_UserDefault.h"

// 分享
#import "ShareModel.h"
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKExtension/SSEShareHelper.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>
#import <ShareSDKUI/SSUIShareActionSheetStyle.h>
//#import <ShareSDKUI/SSUIShareActionSheetCustomItem.h>
#import <ShareSDK/ShareSDK+Base.h>
#import <ShareSDKExtension/ShareSDK+Extension.h>
#import "UIImage+Extensions.h"
@interface SignInViewController ()<SignInViewDelegate>

@property (nonatomic ,strong) SignInDataController *dataController;
@property (nonatomic ,strong) SignInView *subView;
@property (nonatomic, strong) ShareModel *shareModel;
@end

@implementation SignInViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    if(self.dataController == nil)
    {
        
        self.dataController = [[SignInDataController alloc] init];
    }
    
    [self setNavigationTitle];
    [self setSubView];
    [self setLeftBarButton];
    [self setupRightBarButton];
    [self loadShareData];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if(self.dataController == nil)
    {
        
        self.dataController = [[SignInDataController alloc] init];
    }
    if ([MDB_UserDefault getIsLogin]) {
        [self loadSignInHeadInfoData];
    }
    [self loadSignInListData];
}

-(void)setupRightBarButton{
    UIButton *shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    shareBtn.frame = CGRectMake(0, 0, 44, 44);
    [shareBtn setImage:[UIImage imageNamed:@"share_btn"] forState:UIControlStateNormal];
    [shareBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
    [shareBtn addTarget:self action:@selector(shareBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *shareItem = [[UIBarButtonItem alloc] initWithCustomView:shareBtn];
    self.navigationItem.rightBarButtonItem = shareItem;
}

- (void)setSubView{
    SignInView *subView = [[SignInView alloc] init];
    [self.view addSubview:subView];
    [subView mas_makeConstraints:^(MASConstraintMaker *make) {
        if (@available(iOS 11.0, *)) {
            make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop);
            make.left.equalTo(self.view.mas_safeAreaLayoutGuideLeft);
            make.right.equalTo(self.view.mas_safeAreaLayoutGuideRight);
            make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom);
        }else{
            make.edges.equalTo(self.view);
        }
    }];
    subView.delegate = self;
    _subView = subView;
}

- (void)setNavigationTitle{
      self.title = @"每日签到";
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18],NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#666666"]}] ;
}

- (void)setLeftBarButton{
   
    UIButton *backBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    [backBtn setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [backBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [backBtn addTarget:self action:@selector(backTo) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem = backItem;
    
}

- (void)backTo{
    [self.navigationController popViewControllerAnimated:YES];
}


-(void)signInBtnClick{
    [self loadSignInListData];
//    if (![MDB_UserDefault defaultInstance].userissign) {
        [self.dataController requestSignInDoSignDataControllerInView:self.view DataWithCallback:^(NSError *error, BOOL state, NSString *describle) {
            if (state) {
                [self loadSignInHeadInfoData];
                [MDB_UserDefault showNotifyHUDwithtext:@"签到成功" inView:self.view.window];
                
            }else{
                if (![@"" isEqualToString:describle]) {
                    [MDB_UserDefault showNotifyHUDwithtext:describle inView:self.view];
                }
            }
                
        }];

//    }
}

- (void)loadSignInHeadInfoData{
    [self.dataController requestSignInHeadInfoDataControllerInView:self.view DataWithCallback:^(NSError *error, BOOL state, NSString *describle) {
        if (state) {
            [_subView bindSignInHeadInfoData:self.dataController.headInfoResults];
        }else{
            if (![@"" isEqualToString:describle]) {
                [MDB_UserDefault showNotifyHUDwithtext:describle inView:self.view];
            }
        }
    }];
}

- (void)loadSignInListData{
    [self.dataController requestSignInListDataControllerDataWithCallback:^(NSError *error, BOOL state, NSString *describle) {
        if (state) {
            [_subView bindSignInListData:self.dataController.listResults];
        }else{
            if (![@"" isEqualToString:describle]) {
                [MDB_UserDefault showNotifyHUDwithtext:describle inView:self.view];
            }
        }
    }];
}

- (void)loadShareData{
    
    [self.dataController requestSignInShareDataCallback:^(NSError *error, BOOL state, NSString *describle) {
        if (state) {
            ShareModel *model = [ShareModel modelWithDict:self.dataController.shareResultsDict];
            _shareModel = model;
        }
    }];
}

- (void)shareBtnClicked:(UIButton *)sender{
    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
    UIImage *images = [UIImage imageNamed:@"icon120"];
    if (!images) return;
    NSArray* imageArray = @[images];
    ShareModel *model = _shareModel;
    if ([[NSString nullToString:model.content] isEqualToString:@""]) return;
    [shareParams SSDKSetupShareParamsByText:model.content
                                     images:imageArray
                                        url:[NSURL URLWithString:model.url]
                                      title:model.title
                                       type:SSDKContentTypeAuto];
    NSString *contentStr = [NSString stringWithFormat:@"%@%@",model.title,model.url];
//    [shareParams SSDKSetupSinaWeiboShareParamsByText:contentStr title:nil image:images url:[NSURL URLWithString:model.url] latitude:0 longitude:0 objectID:nil type:SSDKContentTypeAuto];
    ///分享更改
    [shareParams SSDKSetupSinaWeiboShareParamsByText:contentStr title:nil images:images video:nil url:[NSURL URLWithString:model.url] latitude:0 longitude:0 objectID:nil isShareToStory:NO type:SSDKContentTypeAuto];
    
    [shareParams SSDKSetupTencentWeiboShareParamsByText:contentStr images:images latitude:0 longitude:0 type:SSDKContentTypeAuto];
    
    NSArray *arritems = @[@(SSDKPlatformTypeSinaWeibo),@(SSDKPlatformTypeWechat), @(SSDKPlatformTypeQQ)];
    ///分享更改
    [ShareSDK showShareActionSheet:self.view customItems:arritems shareParams:shareParams sheetConfiguration:nil onStateChanged:^(SSDKResponseState state, SSDKPlatformType platformType, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error, BOOL end) {
        
    }];
//    [ShareSDK showShareActionSheet:self.view
//                             items:nil
//                       shareParams:shareParams
//               onShareStateChanged:^(SSDKResponseState state, SSDKPlatformType platformType, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error, BOOL end) {
//               }];
}
- (SignInDataController *)dataController{
    if (!_dataController) {
        _dataController = [[SignInDataController alloc] init];
    }
    return _dataController;
}


- (void)ClickToVKLoginViewController:(UIViewController *)controller{
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)clicktoProductInfoViewController: (UIViewController *) targetVc{
    [self.navigationController pushViewController:targetVc animated:YES];
}



@end
