//
//  SocialBoundViewController.m
//  Meidebi
//
//  Created by mdb-admin on 2017/6/28.
//  Copyright © 2017年 meidebi. All rights reserved.
//

#import "SocialBoundViewController.h"
#import "SocialBoundSubjectView.h"
#import <ShareSDK/ShareSDK.h>
#import "BrokeAlertView.h"
#import "SocialBoundDataController.h"
#import "MDB_UserDefault.h"
@interface SocialBoundViewController ()
<
BrokeAlertViewDelegate,
SocialBoundSubjectViewDelegate
>
@property (nonatomic, strong) SocialBoundDataController *datacontroller;
@property (nonatomic, strong) SocialBoundSubjectView *subjectView;
@property (nonatomic, copy) void(^didComplete)(void);
@property (nonatomic, assign) SSDKPlatformType sharePlatform;
@end

@implementation SocialBoundViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"绑定社交账号";
    [self setupSubviews];
    [self loadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupSubviews{
    _subjectView = [SocialBoundSubjectView new];
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
}

- (void)loadData{
    [self.datacontroller requestBoundListWithInView:_subjectView callback:^(NSError *error, BOOL state, NSString *describle) {
        if (state) {
            [_subjectView bindDataWithModel:self.datacontroller.resultDict];
        }
    }];
}

- (void)relievieBound{
    NSString *type = @"";
    if (_sharePlatform == SSDKPlatformTypeSinaWeibo) {
        type = @"2";
    }else if (_sharePlatform == SSDKPlatformTypeQQ){
        type = @"1";
    }
    [self.datacontroller requestRelieveBoundWithInView:_subjectView type:type callback:^(NSError *error, BOOL state, NSString *describle) {
        if (state) {
            [self loadData];
        }else{
            [MDB_UserDefault showNotifyHUDwithtext:describle inView:_subjectView];
        }
    }];
}

#pragma mark - SocialBoundSubjectViewDelegate
- (void)socialBoundSubjectViewDidSelectCellWithPlatform:(SocialPlatformType)platform
                                               complete:(void (^)(void))complete{
    SSDKPlatformType sharePlatform = SSDKPlatformTypeUnknown;
    if (platform == SocialPlatformTypeSina) {
        sharePlatform = SSDKPlatformTypeSinaWeibo;
    }else{
        sharePlatform = SSDKPlatformTypeQQ;
    }
    [ShareSDK getUserInfo:sharePlatform
           onStateChanged:^(SSDKResponseState state, SSDKUser *user, NSError *error)
     {
         if (state == SSDKResponseStateSuccess)
         {
             if (sharePlatform == SSDKPlatformTypeQQ) {
                 [self.datacontroller requestBoundQQWithInView:_subjectView token:user.credential.token openid:user.uid nickname:user.nickname expiresIn:[NSString stringWithFormat:@"%@",@(user.credential.expired.timeIntervalSince1970)] callback:^(NSError *error, BOOL state, NSString *describle) {
                     if (state) {
                         [self loadData];
                     }else{
                         [MDB_UserDefault showNotifyHUDwithtext:describle inView:_subjectView];
                     }
                 }];
             }else if (sharePlatform == SSDKPlatformTypeSinaWeibo){
                 [self.datacontroller requestBoundSinaWithInView:_subjectView token:user.credential.token uid:user.uid nickname:user.nickname expiresIn:[NSString stringWithFormat:@"%@",@(user.credential.expired.timeIntervalSince1970)] callback:^(NSError *error, BOOL state, NSString *describle) {
                     if (state) {
                         [self loadData];
                     }else{
                         [MDB_UserDefault showNotifyHUDwithtext:describle inView:_subjectView];
                     }
                 }];
             }
            
         }else{
             NSLog(@"%@",error);
         }
         
     }];

}

- (void)socialBoundSubjectViewDidSelectCellWithCancelPlatformAuthorized:(SocialPlatformType)platform
                                                               complete:(void (^)(void))complete{
    _sharePlatform = SSDKPlatformTypeUnknown;
    if (platform == SocialPlatformTypeSina) {
        _sharePlatform = SSDKPlatformTypeSinaWeibo;
    }else{
        _sharePlatform = SSDKPlatformTypeQQ;
    }
    BrokeAlertView *alertView = [[BrokeAlertView alloc] init];
    alertView.style = alertStyleSocialBound;
    alertView.delegate = self;
    [alertView showAlert];
}

#pragma mark - BrokeAlertViewDelegate
- (void)brokeAlertViewDidPressEnsureBtnWithAlertView:(BrokeAlertView *)alertView{
    [ShareSDK cancelAuthorize:_sharePlatform];
    [self relievieBound];
}

#pragma mark - setters and getters
- (SocialBoundDataController *)datacontroller{
    if (!_datacontroller) {
        _datacontroller = [[SocialBoundDataController alloc] init];
    }
    return _datacontroller;
}

@end
