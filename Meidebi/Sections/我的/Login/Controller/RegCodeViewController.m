//
//  RegCodeViewController.m
//  Meidebi
//
//  Created by mdb-admin on 16/7/12.
//  Copyright © 2016年 meidebi. All rights reserved.
//

#import "RegCodeViewController.h"
#import "RegCodeSubjectView.h"
#import "VKRegViewController.h"
#import "RegCodeDataController.h"
#import "MDB_UserDefault.h"
#import "SVModalWebViewController.h"
#import "RegSuccessSubjectView.h"

#import <UMAnalytics/MobClick.h>

#import "HTTPManager.h"

@interface RegCodeViewController ()
<
RegCodeSubjectViewDelegate
>
@property (nonatomic, strong) RegCodeDataController *dataController;
@property (nonatomic, strong) RegCodeSubjectView *subView;
@property (nonatomic, assign) BOOL backBtnClick;

@property (nonatomic, strong) NSString *strphone;
@property (nonatomic, strong) NSString *strpass;

@end

@implementation RegCodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setnavigation];
    self.title = @"注册";
    self.view.backgroundColor = [UIColor whiteColor];
    _subView = [RegCodeSubjectView new];
    [self.view addSubview:_subView];
    [_subView mas_makeConstraints:^(MASConstraintMaker *make) {
        if (@available(iOS 11.0, *)) {
            make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop);
            make.left.equalTo(self.view.mas_safeAreaLayoutGuideLeft);
            make.right.equalTo(self.view.mas_safeAreaLayoutGuideRight);
            make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom);
        }else{
            make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(kTopHeight, 0, 0, 0));
        }
    }];
    _subView.delegate = self;
    
}

-(void)setnavigation{
    UIButton *butleft=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 44, 44)];
    [butleft setImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    [butleft setImage:[UIImage imageNamed:@"back_click.png"] forState:UIControlStateHighlighted];
    [butleft addTarget:self action:@selector(doClickBackAction) forControlEvents:UIControlEventTouchUpInside];
    [butleft setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    UIBarButtonItem *leftBar=[[UIBarButtonItem alloc]initWithCustomView:butleft];
    self.navigationItem.leftBarButtonItem=leftBar;
}

-(void)doClickBackAction;
{
    _backBtnClick = YES;
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - RegCodeSubjectViewDelegate
- (void)regCodeViewDidPressUserProtocolBtn{
    SVModalWebViewController  *svweb=[[SVModalWebViewController alloc] initWithAddress:@"http://www.meidebi.com/article-6.html?comfirm_visit_web=1"];
    [self presentViewController:svweb animated:YES completion:^{}];
}

- (void)regCodeView:(RegCodeSubjectView *)subView
didPressAcquireCodeBtnWithMobile:(NSString *)mobileNumber{
    [self.dataController requestGetCodeWithMobilNumber:mobileNumber
                                               regType:RegCodeTypeNomal
                                                InView:subView
                                              callback:^(NSError *error, BOOL state, NSString *describle) {
        if (![self.dataController.resultMessage isEqualToString:@""]) {
            [_subView bindMobileWarnData:self.dataController.resultMessage];
        }
    }];
}

- (void)regCodeView:(RegCodeSubjectView *)subView didPressRegBtnWithMobile:(NSString *)mobileNumber andCode:(NSString *)code withInvite:(NSString *)invite andpassword:(NSString *)password{
    _strpass = password;
    _strphone = mobileNumber;
    
    
    NSMutableDictionary *dicpush = [NSMutableDictionary new];
    [dicpush setObject:mobileNumber forKey:@"phone"];
    [dicpush setObject:code forKey:@"code"];
    [dicpush setObject:password forKey:@"password"];
    [dicpush setObject:invite forKey:@"invitation_code"];
    [dicpush setObject:@"1" forKey:@"devicetype"];
    
    [self.dataController requestNewRegUserInfoWithData:dicpush InView:subView callback:^(NSError *error, BOOL statue, id sulteData) {
        
        if (!statue) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                                message:[NSString stringWithFormat:@"%@",self.dataController.resultMessage]
                                                               delegate:nil
                                                      cancelButtonTitle:@"确定"
                                                      otherButtonTitles:nil, nil];
            [alertView show];
            
        }else{
            [MobClick event:@"wode_zhuce"];
            if (![[NSString nullToString:sulteData] isEqualToString:@""]) {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                                    message:[NSString stringWithFormat:@"%@",self.dataController.resultMessage]
                                                                   delegate:self
                                                          cancelButtonTitle:@"取消"
                                                          otherButtonTitles:@"去激活", nil];
                [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%@",sulteData] forKey:@"mailAddressReg"];
                [alertView setTag:103];
                [alertView show];
            }else{
                RegSuccessSubjectView *regSuccessView = [RegSuccessSubjectView new];
                [self.view addSubview:regSuccessView];
                [regSuccessView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(64, 0, 0, 0));
                }];
                regSuccessView.backgroundColor = [UIColor whiteColor];
                regSuccessView.successType = RegSuccessTypeNormal;
                
                
                //                        _isShowSuccessView = YES;
                [self LoginOnceBeforeSign];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    if (!_backBtnClick) {
                        [self.navigationController popToRootViewControllerAnimated:YES];
                    }
                });
            }
        }
    }];
    
//    [self.dataController requestVerificationCodeWithMobilNumber:mobileNumber
//                                                           code:code
//                                                         InView:subView
//                                                       callback:^(NSError *error, BOOL state, NSString *describle) {
//        if (![self.dataController.resultMessage isEqualToString:@""]) {
////            [MDB_UserDefault showNotifyHUDwithtext:self.dataController.resultMessage inView:_subView];
//            [_subView bindCodeWarnData:self.dataController.resultMessage];
//        }else{
//
//            NSMutableDictionary *dict = [NSMutableDictionary new];
//            [dict setObject:password forKey:@"password"];
//
//            [self.dataController requestRegUserInfoWithData:dict vid:self.dataController.vid InView:self.view withInvite:invite callback:^(NSError *error, BOOL statue, id sulteData) {
//
//                if (!statue) {
//                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示"
//                                                                        message:[NSString stringWithFormat:@"%@",self.dataController.resultMessage]
//                                                                       delegate:nil
//                                                              cancelButtonTitle:@"确定"
//                                                              otherButtonTitles:nil, nil];
//                    [alertView show];
//
//                }else{
//                    [MobClick event:@"wode_zhuce"];
//                    if (![[NSString nullToString:sulteData] isEqualToString:@""]) {
//                        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示"
//                                                                            message:[NSString stringWithFormat:@"%@",self.dataController.resultMessage]
//                                                                           delegate:self
//                                                                  cancelButtonTitle:@"取消"
//                                                                  otherButtonTitles:@"去激活", nil];
//                        [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%@",sulteData] forKey:@"mailAddressReg"];
//                        [alertView setTag:103];
//                        [alertView show];
//                    }else{
//                        RegSuccessSubjectView *regSuccessView = [RegSuccessSubjectView new];
//                        [self.view addSubview:regSuccessView];
//                        [regSuccessView mas_makeConstraints:^(MASConstraintMaker *make) {
//                            make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(64, 0, 0, 0));
//                        }];
//                        regSuccessView.backgroundColor = [UIColor whiteColor];
//                        regSuccessView.successType = RegSuccessTypeNormal;
//
//
////                        _isShowSuccessView = YES;
//                        [self LoginOnceBeforeSign];
//                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                            if (!_backBtnClick) {
//                                [self.navigationController popToRootViewControllerAnimated:YES];
//                            }
//                        });
//                    }
//                }
//
//            }];
//            ////验证码成功
//
////            VKRegViewController *RegVc = [[VKRegViewController alloc] init];
////            RegVc.invite = invite;
////            RegVc.phone = mobileNumber;
////            RegVc.vid = self.dataController.vid;
////            [self.navigationController pushViewController:RegVc animated:YES];
//        }
//    }];
}
-(void)LoginOnceBeforeSign
{
    NSString* urlString = URL_login;
    [HTTPManager sendRequestUrlToService:urlString withParametersDictionry:@{@"username":_strphone,@"password":_strpass} view:nil completeHandle:^(NSURLSessionTask *opration, id responceObjct, NSError *error) {
        if (responceObjct) {
            NSString *hexString=[[NSString alloc]initWithData:responceObjct encoding:NSUTF8StringEncoding];
            NSDictionary* dictResult = (NSDictionary*)[hexString JSONValue];
            if ([[dictResult objectForKey:@"status"] intValue]==1 ) {
                [[MDB_UserDefault defaultInstance] setUserWithDic:[dictResult objectForKey:@"user"] token:[dictResult objectForKey:@"data"]];
                [self setHttpToken];
                [self zhucetishi];
            }else{
                [MDB_UserDefault showNotifyHUDwithtext:@"登录失败，请到登录页面进行登录" inView:self.view];
            }
            
        }else{
        }
    }];
    
}

-(void)zhucetishi
{
    NSDictionary *dicpush = @{@"userkey": [NSString nullToString:[MDB_UserDefault defaultInstance].usertoken]};
    
    [HTTPManager sendGETRequestUrlToService:ResignSuccessnormalcouponinfoViewUrl withParametersDictionry:dicpush view:nil completeHandle:^(NSURLSessionTask *opration, id responceObjct, NSError *error) {
        
        if (responceObjct==nil) {
            
        }else{
            NSString *str=[[NSString alloc]initWithData:responceObjct encoding:NSUTF8StringEncoding];
            NSDictionary *dicAll=[str JSONValue];
            if ([[NSString stringWithFormat:@"%@",[dicAll objectForKey:@"status"]] isEqualToString:@"1"]) {
                
                NSDictionary *dicdata = [dicAll objectForKey:@"data"];
                UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"提示" message:[NSString stringWithFormat:@"注册成功！￥%@商品券已到账。可在“我的-我的奖励”中查看，适用于所有代购订单",[dicdata objectForKey:@"denomination"]] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alter show];
            }
        }
        
    }];
}

-(void)setHttpToken
{
    [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"setHttpTokensss"];
    NSDictionary *prama;
    if ([MDB_UserDefault getIsLogin]) {
        prama=@{@"umengtoken":[NSString nullToString:[MDB_UserDefault getUmengDeviceToken]],
                @"userkey":[NSString nullToString:[MDB_UserDefault defaultInstance].usertoken]};
    }else{
        if ([MDB_UserDefault getUmengDeviceToken]) {
            prama=@{@"umengtoken":[MDB_UserDefault getUmengDeviceToken]};
        }
    }
    [HTTPManager sendRequestUrlToService:URL_getumengconfig withParametersDictionry:prama view:nil completeHandle:^(NSURLSessionTask *opration, id responceObjct, NSError *error) {
        
    }];
    
}

#pragma mark - getters and setters
- (RegCodeDataController *)dataController{
    if (!_dataController) {
        _dataController = [[RegCodeDataController alloc] init];
    }
    return _dataController;
}

@end
