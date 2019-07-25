//
//  SpecialInfoViewController.m
//  Meidebi
//
//  Created by mdb-admin on 2017/5/19.
//  Copyright © 2017年 meidebi. All rights reserved.
//

#import "SpecialInfoViewController.h"
#import "SpecialInfoSubjectView.h"
#import "RemarkHomeViewController.h"
#import "RemarkComposeViewController.h"
#import "VKLoginViewController.h"
#import "ADHandleViewController.h"
#import "MDB_UserDefault.h"
#import "HomeDataController.h"
#import "SpecialDataController.h"
#import "SVModalWebViewController.h"
#import "PersonalInfoIndexViewController.h"
#import "ProductInfoDataController.h"

#import <ShareSDK/ShareSDK.h>
#import <ShareSDKExtension/SSEShareHelper.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>
#import <ShareSDKUI/SSUIShareActionSheetStyle.h>
#import <ShareSDKUI/SSUIShareActionSheetCustomItem.h>
#import <ShareSDK/ShareSDK+Base.h>
#import <ShareSDKExtension/ShareSDK+Extension.h>

@interface SpecialInfoViewController ()
<
SpecialInfoSubjectViewDelegate,
UIAlertViewDelegate
>
@property (nonatomic, strong) NSString *specialID;
@property (nonatomic, strong) SpecialInfoSubjectView *subjectView;
@property (nonatomic, strong) SpecialInfoViewModel *viewModel;
@property (nonatomic, strong) SpecialDataController *specialDataController;
@property (nonatomic, strong) ProductInfoDataController *dataController;
@end

@implementation SpecialInfoViewController

- (instancetype)initWithSpecialInfo:(NSString *)specialID{
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        _specialID = specialID;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"专题详情";
    [self setNavigation];
    _subjectView = [SpecialInfoSubjectView new];
    [self.view addSubview:_subjectView];
    [_subjectView mas_makeConstraints:^(MASConstraintMaker *make) {
        if (@available(iOS 11.0, *)) {
            make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop);
            make.left.equalTo(self.view.mas_safeAreaLayoutGuideLeft);
            make.right.equalTo(self.view.mas_safeAreaLayoutGuideRight);
            make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom);
        }else{
            make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(kTopHeight, 0, 0, 0));
        }
    }];
    _subjectView.delegate = self;
    [self loadSpecialData];
}

-(void)setNavigation{
    UIButton* btnright = [UIButton buttonWithType:UIButtonTypeCustom];//btnLeft.backgroundColor=[UIColor redColor];
    btnright.frame = CGRectMake(0,0,44,44);
    [btnright setImage:[UIImage imageNamed:@"fengxiang"] forState:UIControlStateNormal];
    [btnright setImage:[UIImage imageNamed:@"fengxiang_click"] forState:UIControlStateHighlighted];
    [btnright setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
    [btnright addTarget:self action:@selector(doShareAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem* rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btnright];
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)loadSpecialData{
    [self.specialDataController requestSpecialInfoDataWithID:_specialID
                                                   inView:_subjectView
                                                 callback:^(NSError *error, BOOL state, NSString *describle) {
                                                     if (state) {
                                                         [self renderSubjectView];
                                                     }
    }];
    [self.specialDataController requestShareDataWithSpecialID:_specialID
                                                     callback:^(NSError *error, BOOL state, NSString *describle) {
        
    }];
}

- (void)renderSubjectView{
    _viewModel = [SpecialInfoViewModel viewModelWithSubject:self.specialDataController.resultDict];
    [_subjectView bindSpcialDetailData:_viewModel];
}

- (void)showAlertView{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                        message:@"请登录后再试"
                                                       delegate:self
                                              cancelButtonTitle:nil
                                              otherButtonTitles:@"登录",@"取消", nil];
    [alertView show];

}

- (void)doShareAction{
    ShareModel *share = self.specialDataController.resultShareInfo;
    if (share) {
        //1、创建分享参数（必要）
        NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
        [shareParams SSDKSetupShareParamsByText:share.content
                                         images:share.shareImage
                                            url:[NSURL URLWithString:share.url]
                                          title:share.title
                                           type:SSDKContentTypeAuto];
        
        [shareParams SSDKSetupSinaWeiboShareParamsByText:share.sina_weibocontent title:nil image:share.shareImage url:[NSURL URLWithString:share.url] latitude:0 longitude:0 objectID:nil type:SSDKContentTypeAuto];
        
        [shareParams SSDKSetupTencentWeiboShareParamsByText:share.qq_weibocontent images:share.shareImage latitude:0 longitude:0 type:SSDKContentTypeAuto];
        
        //2、分享
        [ShareSDK showShareActionSheet:self.view
                                 items:nil
                           shareParams:shareParams
                   onShareStateChanged:^(SSDKResponseState state, SSDKPlatformType platformType, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error, BOOL end) {
                       
                   }];
        
    }else{
        [self.specialDataController requestShareDataWithSpecialID:_specialID
                                                         callback:^(NSError *error, BOOL state, NSString *describle) {
                                        if (state) {
                                            [self doShareAction];

                                        }
        }];
    }
}

#pragma mark - SpecialInfoSubjectViewDelegate
- (void)remarkHomeSubjectClickUrl:(NSString *)urlStr{
    if (!urlStr) return;
    ADHandleViewController *vc = [[ADHandleViewController alloc] initWithAdLink:urlStr];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)photoGroupView:(YYPhotoGroupView *)photoGroupView didClickImageView:(UIView *)fromeView{
    [photoGroupView presentFromImageView:fromeView
                             toContainer:self.navigationController.view
                                animated:YES
                              completion:nil];
}

- (void)detailSubjectViewDidCickInputRemarkView{
    [self detailSubjectViewDidCickReadMoreRemark];
}

- (void)remarkTableViewDidClickUser:(NSString *)userid{
    PersonalInfoIndexViewController *personalInfoIndexVC = [[PersonalInfoIndexViewController alloc] initWithUserID:userid];
    [self.navigationController pushViewController:personalInfoIndexVC animated:YES];
}

- (void)detailSubjectViewDidCickReadMoreRemark{
    RemarkHomeViewController *remarkHomeVc = [[RemarkHomeViewController alloc] init];
    remarkHomeVc.type = RemarkTypeCommentAwards;
    remarkHomeVc.linkid = _viewModel.specialID;
    [self.navigationController pushViewController:remarkHomeVc animated:YES];
}

- (void)detailSubjectViewDidCickCollectBtn:(void (^)(BOOL))didComplete{
    if ([MDB_UserDefault getIsLogin]){
        [self.specialDataController requestShouDataWithInView:_subjectView specialID:_viewModel.specialID linkType:@"6" callback:^(NSError *error, BOOL state, NSString *describle) {
            if (!error) {
                if (self.specialDataController.isSuccessShou) {
                    if (didComplete) {
                        didComplete(NO);
                    }
                }else{
                    if (didComplete) {
                        didComplete(YES);
                    }
                }
            }
        }];
    }else{
        [self showAlertView];
    }
}

- (void)detailSubjectViewDidCicklikeBtn:(void (^)(BOOL))didComplete{
//    if ([MDB_UserDefault getIsLogin]){
        [self.specialDataController requestZanDataWithInView:_subjectView specialID:_viewModel.specialID callback:^(NSError *error, BOOL state, NSString *describle) {
            if (!error && self.specialDataController.isSuccessZan) {
                if (didComplete) {
                    didComplete(NO);
                }
            }
        }];
//    }else{
//        [self showAlertView];
//    }
}

- (void)detailSubjectViewDidCickWebViewUrlLink:(NSString *)link{
    SVModalWebViewController *svweb=[[SVModalWebViewController alloc] initWithAddress:link];
    svweb.modalTransitionStyle=UIModalTransitionStyleCrossDissolve;
    [self presentViewController:svweb animated:NO completion:nil];
}

- (void)detailSubjectViewDidCickAddFollowWithUserid:(NSString *)userid didComplete:(void (^)(BOOL))didComplete{
    [self.dataController requestAddFollwDataWithInView:_subjectView userid:userid callback:^(NSError *error, BOOL state, NSString *describle) {
        if (state) {
            didComplete(state);
        }else{
            [MDB_UserDefault showNotifyHUDwithtext:describle inView:_subjectView];
        }
    }];
}

- (void)detailSubjectViewDidCickAvaterViewWithUserid:(NSString *)userid{
    PersonalInfoIndexViewController *personalInfoVc = [[PersonalInfoIndexViewController alloc] initWithUserID:userid];
    [self.navigationController pushViewController:personalInfoVc animated:YES];
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex==0) {
        VKLoginViewController* theViewController= [[VKLoginViewController alloc] init];
        [self.navigationController pushViewController:theViewController animated:YES ];
    }
}

#pragma mark - setters and getters

- (SpecialDataController *)specialDataController{
    if (!_specialDataController) {
        _specialDataController = [[SpecialDataController alloc] init];
    }
    return _specialDataController;
}

- (ProductInfoDataController *)dataController{
    if (!_dataController) {
        _dataController = [[ProductInfoDataController alloc] init];
    }
    return _dataController;
}
@end
