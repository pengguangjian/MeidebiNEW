//
//  BindingUserInfoViewController.m
//  Meidebi
//
//  Created by mdb-admin on 16/7/13.
//  Copyright © 2016年 meidebi. All rights reserved.
//

#import "BindingUserInfoViewController.h"
#import "BindingUserInfoSubjectView.h"
#import "RegCodeDataController.h"
#import "RegSuccessSubjectView.h"
#import "SVModalWebViewController.h"

#import "VKLoginViewController.h"

#import "MDB_UserDefault.h"

@interface BindingUserInfoViewController ()
<
BindingUserInfoSubjectViewDelegate
>

@property (nonatomic, strong) NSString *Vid;
@property (nonatomic, strong) RegCodeDataController *dataController;
@property (nonatomic, assign) BOOL backBtnClick;

@property (nonatomic, assign) BOOL ispassword;

@end

@implementation BindingUserInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    [self setNavigationTitle];
    [self setnavigation];
    
    [self isPwdData];
    
    
    
}

- (void)setNavigationTitle{
    
    self.title = @"绑定手机";
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18],NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#666666"]}] ;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
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

-(void)doClickBackAction
{
//    for(UIViewController *vc in self.navigationController.viewControllers)
//    {
//        if([vc isKindOfClass:[VKLoginViewController class]])
//        {
//
//            [self.navigationController popToViewController:vc animated:YES];
//            return;
//        }
//    }
//
//    [self.navigationController popViewControllerAnimated:YES];
    
    NSInteger index = 0;
    for (NSInteger i = 0; i<self.navigationController.viewControllers.count; i++) {
        if ([@"VKLoginViewController" isEqualToString:NSStringFromClass([(UIViewController *)self.navigationController.viewControllers[i] class])]) {
            if (i != 0) {
                index = i-1;
            }
            break;
        }
    }
     _backBtnClick = YES;
    [self.navigationController popToViewController:self.navigationController.viewControllers[index] animated:YES];
}


-(void)isPwdData
{
    if (!_dataController) {
        _dataController = [[RegCodeDataController alloc] init];
    }
    
    [self.dataController requestisPwdInView:self.view callback:^(NSError *error, BOOL state, NSString *describle) {
       
        _ispassword = state;
        if(self.dataController.strpass.length>5)
        {
            _ispassword = YES;
            
        }
        BindingUserInfoSubjectView *bindingUserInfoSubview = [BindingUserInfoSubjectView new];
        bindingUserInfoSubview.isPwd = state;
        [self.view addSubview:bindingUserInfoSubview];
        [bindingUserInfoSubview mas_makeConstraints:^(MASConstraintMaker *make) {
            if (@available(iOS 11.0, *)) {
                make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop);
                make.left.equalTo(self.view.mas_safeAreaLayoutGuideLeft);
                make.right.equalTo(self.view.mas_safeAreaLayoutGuideRight);
                make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom);
            }else{
                make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(kTopHeight, 0, 0, 0));
            }
        }];
        bindingUserInfoSubview.delegate = self;
        
    }];
    
}

#pragma mark - BindingUserInfoSubjectViewDelegate

- (void)bindingViewDidPressUserProtocolBtn{
    SVModalWebViewController  *svweb=[[SVModalWebViewController alloc] initWithAddress:@"http://www.meidebi.com/article-6.html?comfirm_visit_web=1"];
    [self presentViewController:svweb animated:YES completion:^{}];
}


- (void)bindingUserInfoView:(BindingUserInfoSubjectView *)subView
didPressAcquireCodeBtnWithMobile:(NSString *)mobileNumber{
    
    [self.dataController requestGetCodeWithMobilNumber:mobileNumber
                                               regType:RegCodeTypeBinding
                                                InView:self.view
                                              callback:^(NSError *error, BOOL state, NSString *describle) {
        if (![self.dataController.resultMessage isEqualToString:@""]) {
            [subView bindMobileWarnData:self.dataController.resultMessage];
        }
    }];
}

- (void)bindingUserInfoView:(BindingUserInfoSubjectView *)subView
didPressSubmitBtnWithMobile:(NSString *)mobileNumber
                    andCode:(NSString *)code
                andpassword:(NSString *)password{
    if(_ispassword && password.length<6)
    {
        [MDB_UserDefault showNotifyHUDwithtext:@"请输入正确的密码" inView:self.view];
        return;
    }
    [self.dataController requestVerificationCodeWithMobilNumber:mobileNumber
                                                           code:code
                                                           type:@"2"
                                                         InView:self.view
                                                       callback:^(NSError *error, BOOL state, NSString *describle) {
        if (![self.dataController.resultMessage isEqualToString:@""]) {
            [subView bindCodeWarnData:self.dataController.resultMessage];
        }
        if(state)
        {
            if(password.length>1)
            {
                
                NSDictionary *parameters = [NSDictionary dictionary];
                parameters = @{@"password":[NSString nullToString:password],
                               @"userkey":[NSString nullToString:[MDB_UserDefault defaultInstance].usertoken]
                               };
                
                [self.dataController requestAddPwdWithData:parameters InView:self.view callback:^(NSError *error, BOOL state, NSString *describle) {
                    
                }];
            }
            
            
            RegSuccessSubjectView *successSubView = [RegSuccessSubjectView new];
            [self.view addSubview:successSubView];
            [successSubView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(64, 0, 0, 0));
            }];
            successSubView.backgroundColor = [UIColor whiteColor];
            successSubView.successType = RegSuccessTypeBinding;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                if (!_backBtnClick) {
                    [self doClickBackAction];
                }
            });
        }
    }];

}

- (void)bindingUserInfoViewDidPressNotSubmitBtn{
    [self doClickBackAction];
}

#pragma mark - getter and setter
- (RegCodeDataController *)dataController{
    if (!_dataController) {
        _dataController = [[RegCodeDataController alloc] init];
    }
    return _dataController;
}


@end
