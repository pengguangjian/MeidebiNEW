//
//  VKRegViewController.m
//  Meidebi
//
//  Created by Yin HuaJun on 13-6-21.
//  Copyright (c) 2013年 meidebi. All rights reserved.
//

#import "VKRegViewController.h"
#import "HTTPManager.h"
#import "SVModalWebViewController.h"
#import "VKRegSubjectView.h"
#import "RegUserInfoDataController.h"
#import "RegSuccessSubjectView.h"
#import "MDB_UserDefault.h"
#import <UMAnalytics/MobClick.h>
@interface VKRegViewController ()

<
VKRegSubjectViewDelegate,
UIAlertViewDelegate
>

@property (nonatomic, strong) RegUserInfoDataController *datacontroller;
@property (nonatomic, strong) NSDictionary *userInfoDict;
@property (nonatomic, assign) BOOL backBtnClick;
@property (nonatomic, assign) BOOL isShowSuccessView;
@end

@implementation VKRegViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self setnavigation];
    self.title=@"账号设置";
    VKRegSubjectView * subView = [VKRegSubjectView new];
    [self.view addSubview:subView];
    [subView mas_makeConstraints:^(MASConstraintMaker *make) {
        if (@available(iOS 11.0, *)) {
            make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop);
            make.left.equalTo(self.view.mas_safeAreaLayoutGuideLeft);
            make.right.equalTo(self.view.mas_safeAreaLayoutGuideRight);
            make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom);
        }else{
            make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(kTopHeight, 0, 0, 0));
        }
    }];
    subView.delegate = self;
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setnavigation{
    UIButton *butleft=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 44, 44)];
    [butleft setImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    [butleft setImage:[UIImage imageNamed:@"back_click.png"] forState:UIControlStateHighlighted];
    [butleft setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [butleft addTarget:self action:@selector(doClickBackAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBar=[[UIBarButtonItem alloc]initWithCustomView:butleft];
    self.navigationItem.leftBarButtonItem=leftBar;
}

-(void)doClickBackAction{
    if (_isShowSuccessView) {
        _backBtnClick = YES;
        [self.navigationController popToRootViewControllerAnimated:YES];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}


-(void)LoginOnceBeforeSign{
    
    NSString* urlString = URL_login;
    [HTTPManager sendRequestUrlToService:urlString withParametersDictionry:@{@"username":[NSString nullToString:_userInfoDict[@"username"]],@"password":[NSString nullToString:_userInfoDict[@"password"]]} view:nil completeHandle:^(NSURLSessionTask *opration, id responceObjct, NSError *error) {
        if (responceObjct) {
            NSString *hexString=[[NSString alloc]initWithData:responceObjct encoding:NSUTF8StringEncoding];
            NSDictionary* dictResult = (NSDictionary*)[hexString JSONValue];
            if ([[dictResult objectForKey:@"status"] intValue]==1 ) {
                 [[MDB_UserDefault defaultInstance] setUserWithDic:[dictResult objectForKey:@"user"] token:[dictResult objectForKey:@"data"]];
            }else{
            
            }
            
        }else{
        }
    }];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag==103){
        if (buttonIndex == 1) {
            NSString* url = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"mailAddressReg"]];//返利跳转链接
            SVModalWebViewController  *svweb=[[SVModalWebViewController alloc] initWithAddress:url];
            svweb.modalTransitionStyle=UIModalTransitionStyleCrossDissolve;
            
            [self presentViewController:svweb animated:YES completion:^{
                
            }];
        }
    }
}

#pragma mark - VKRegSubjectViewDelegate
- (void)regUserInfoView:(VKRegSubjectView *)subView didPressSubmitBtnWithData:(NSDictionary *)dataDict{
    _userInfoDict = dataDict;
    [self.datacontroller requestRegUserInfoWithData:dataDict vid:_vid  InView:subView withInvite:_invite callback:^(NSError *error, BOOL statue, id sulteData) {
        if (!statue) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                                message:[NSString stringWithFormat:@"%@",self.datacontroller.resultMessage]
                                                               delegate:nil
                                                      cancelButtonTitle:@"确定"
                                                      otherButtonTitles:nil, nil];
            [alertView show];

        }else{
            [MobClick event:@"wode_zhuce"];
            if (![[NSString nullToString:sulteData] isEqualToString:@""]) {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                                    message:[NSString stringWithFormat:@"%@",self.datacontroller.resultMessage]
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
                _isShowSuccessView = YES;
                [self LoginOnceBeforeSign];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    if (!_backBtnClick) {
                        [self.navigationController popToRootViewControllerAnimated:YES];
                    }
                });
            }
        }
    }];
}

#pragma mark - getters and setters 

- (RegUserInfoDataController *)datacontroller{
    if (!_datacontroller) {
        _datacontroller = [[RegUserInfoDataController alloc] init];
    }
    return _datacontroller;
}

@end
