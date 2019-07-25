//
//  WelfareHomeViewController.m
//  Meidebi
//
//  Created by mdb-admin on 2016/10/24.
//  Copyright © 2016年 meidebi. All rights reserved.
//

#import "WelfareHomeViewController.h"
#import "WelfareHomeSubjectView.h"
#import "WelfareHomeDataController.h"
#import "MDB_UserDefault.h"
#import "TaskRuleViewController.h"
#import "PersonalInfoViewController.h"
#import "PushSubscibeViewController.h"
#import "InviteFriendViewController.h"
#import "SignInViewController.h"
#import "BrokeHomeViewController.h"
#import "UpShareViewController.h"
#import "VKLoginViewController.h"
#import "WelfareReceiveViewController.h"
#import "SocialBoundViewController.h"
#import "BindingUserInfoViewController.h"
#import "PersonalInfoIndexViewController.h"
#import "ShowActiveViewController.h"
#import "VolumeContentViewController.h"
#import "AddressListViewController.h"
#import "RegCodeViewController.h"
@interface WelfareHomeViewController ()
<
UIAlertViewDelegate,
AddressListViewControllerDelegate,
WelfareHomeSubjectViewDelegate
>
@property (nonatomic, strong) WelfareHomeSubjectView *welfareSubjectView;
@property (nonatomic, strong) WelfareHomeDataController *dataController;
@property (nonatomic, strong) NSString *giftType;
@property (nonatomic, copy) void (^complete)(void);
@end

@implementation WelfareHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    _welfareSubjectView = [[WelfareHomeSubjectView alloc] initWithCurrentNavigationController:self.navigationController];
    _welfareSubjectView.delegate = self;
    [self.view addSubview:_welfareSubjectView];
    [_welfareSubjectView mas_makeConstraints:^(MASConstraintMaker *make) {
        if (@available(iOS 11.0, *)) {
            make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop);
            make.left.equalTo(self.view.mas_safeAreaLayoutGuideLeft);
            make.right.equalTo(self.view.mas_safeAreaLayoutGuideRight);
            make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom);
        }else{
            make.edges.equalTo(self.view);
        }
    }];
    [_welfareSubjectView update];
    __weak typeof (self) weakSelf = self;
    _welfareSubjectView.didComplete = ^(UIView *navTitleView) {
        weakSelf.navigationItem.titleView = navTitleView;
    };
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


- (BOOL)verificationLogin{
    if (![MDB_UserDefault getIsLogin]){
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                            message:@"请登录后再试"
                                                           delegate:self
                                                  cancelButtonTitle:Nil
                                                  otherButtonTitles:@"登录",@"取消", nil];
        [alertView show];
        return NO;
    }
    return YES;
}

#pragma mark - WelfareHomeSubjectViewDelegate

- (void)welfareHomeSubjectViewDidNAv:(UIView *)navTitleView{
     self.navigationItem.titleView = navTitleView;
}
- (void)welfareHomeSubjectViewDidSelectCellWithType:(WelfareStrategyJumpType)type{
    switch (type) {
        case WelfareStrategyJumpTypeShaidan:
        {
            UpShareViewController *upshareVc = [[UpShareViewController alloc] init];
            [self.navigationController pushViewController:upshareVc animated:YES];
        }
            break;
        case WelfareStrategyJumpTypeBroke:{
            BrokeHomeViewController *brokeHomeVC = [[BrokeHomeViewController alloc] init];
            [self.navigationController pushViewController:brokeHomeVC animated:YES];
        }
            break;
        case WelfareStrategyJumpTypeInvite:{
            if ([self verificationLogin]) {
                InviteFriendViewController *inviteFriendVC = [[InviteFriendViewController alloc] init];
                [self.navigationController pushViewController:inviteFriendVC animated:YES];
            }
        }
            break;
        case WelfareStrategyJumpTypeRegister:{
            RegCodeViewController *regVC = [[RegCodeViewController alloc] init];
            [self.navigationController pushViewController:regVC animated:YES];
        }
            break;
        case WelfareStrategyJumpTypeSubscribe:{
            PushSubscibeViewController *pushSubscibeVC = [[PushSubscibeViewController alloc] init];
            [self.navigationController pushViewController:pushSubscibeVC animated:YES];
        }
            break;
        case WelfareStrategyJumpTypeAttendance:{
            SignInViewController *signInVC = [[SignInViewController alloc] init];
            [self.navigationController pushViewController:signInVC animated:YES];
        }
            break;
        case WelfareStrategyJumpTypePerfectInfo:{
            if ([self verificationLogin]) {
                PersonalInfoViewController *personalInfoVC = [[PersonalInfoViewController alloc] init];
                [self.navigationController pushViewController:personalInfoVC animated:YES];
            }
        }
            break;
        case WelfareStrategyJumpTypeBoundOtherAccout:{
            if ([self verificationLogin]) {
                SocialBoundViewController *socialBoundVC = [[SocialBoundViewController alloc] init];
                [self.navigationController pushViewController:socialBoundVC animated:YES];
            }
        }
            break;
        case WelfareStrategyJumpTypePhoneAuthentication:{
            if ([self verificationLogin]) {
                BindingUserInfoViewController *bindingUserInfoVC = [[BindingUserInfoViewController alloc] init];
                [self.navigationController pushViewController:bindingUserInfoVC animated:YES];
            }
        }
            break;
        default:
            break;
    }
}

- (void)welfareHomeSubjectViewDidClickMyWelfareBtn{
    WelfareReceiveViewController *welfareReceiveVC = [[WelfareReceiveViewController alloc] init];
    [self.navigationController pushViewController:welfareReceiveVC animated:YES];
}


- (void)welfareHomeSubjectViewDidClickAvater:(NSString *)userid{
    if ([userid isEqualToString:@""]) return;
    PersonalInfoIndexViewController *personalInfoIndexVC = [[PersonalInfoIndexViewController alloc] initWithUserID:userid];
    [self.navigationController pushViewController:personalInfoIndexVC animated:YES];
}

- (void)welfareHomeSubjectViewDidClickAd:(NSDictionary *)adInfo{
    UIStoryboard *mainbord=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
    ShowActiveViewController *showAct=[mainbord instantiateViewControllerWithIdentifier:@"com.mbd.ShowActiveViewC"];
    showAct.url=[NSString nullToString:adInfo[@"link"]];
    showAct.title=[NSString nullToString:adInfo[@"title"]];
    [self.navigationController pushViewController:showAct animated:YES];
}

- (void)welfareHomeSubjectViewJumpLoginVc{
    VKLoginViewController* theViewController= [[VKLoginViewController alloc] init];
    [self.navigationController pushViewController:theViewController animated:YES ];
}

- (void)welfareHomeSubjectViewReferCopperRule{
    TaskRuleViewController *ruleVc = [[TaskRuleViewController alloc] init];
    [self.navigationController pushViewController:ruleVc animated:YES];
}

- (void)welfareHomeSubjectViewConversionCouponWithID:(NSString *)couponID{
    VolumeContentViewController *ductViewC = [[VolumeContentViewController alloc] init];
    ductViewC.juancleid = couponID.integerValue;
    [self.navigationController pushViewController:ductViewC animated:YES];
}

- (void)welfareHomeSubjectViewDidSelectWaresWithItemId:(NSString *)waresId waresType:(NSString *)type haveto:(NSString *)haveto{
    VolumeContentViewController *ductViewC = [[VolumeContentViewController alloc] init];
    ductViewC.juancleid = waresId.integerValue;
    if ([type isEqualToString:@"coupon"]) {
        ductViewC.type = waresTypeCoupon;
    }else{
        ductViewC.type = waresTypeMaterial;
    }
    ductViewC.haveto = haveto;
    [self.navigationController pushViewController:ductViewC animated:YES];
}
- (void)welfareHomeSubjectViewReferLogisticsAddress:(void (^)(void))complete{
    _complete = complete;
    AddressListViewController *addressListVc = [[AddressListViewController alloc] init];
    addressListVc.delegate = self;
    [self.navigationController pushViewController:addressListVc animated:YES];
}

#pragma mark - AddressListViewControllerDelegate
- (void)afreshConversionAlertView{
    if (_complete) {
        _complete();
    }
}
#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
        VKLoginViewController* theViewController= [[VKLoginViewController alloc] init];
        [self.navigationController pushViewController:theViewController animated:YES ];
    }
}

#pragma mark - setters and getters
- (WelfareHomeDataController *)dataController{
    if (!_dataController) {
        _dataController = [[WelfareHomeDataController alloc] init];
    }
    return _dataController;
}
@end
