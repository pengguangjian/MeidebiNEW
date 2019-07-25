//
//  ResetPasswordViewController.m
//  Meidebi
//
//  Created by mdb-admin on 16/7/13.
//  Copyright © 2016年 meidebi. All rights reserved.
//

#import "ResetPasswordViewController.h"
#import "ResetPasswordSubjectView.h"
#import "ResetPassDataController.h"
#import "MDB_UserDefault.h"
#import "RegSuccessSubjectView.h"

#import "VKLoginViewController.h"

@class VKLoginViewController;
@interface ResetPasswordViewController ()
<
ResetPasswordSubjectViewDelegate,
RegSuccessSubjectViewDelegate
>
{
    BOOL issuccess;
}

@property (nonatomic, strong) ResetPassDataController *datacontroller;

@end

@implementation ResetPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavigation];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"设置新密码";
    
    ResetPasswordSubjectView *resetPasswordView = [ResetPasswordSubjectView new];
    [self.view addSubview:resetPasswordView];
    [resetPasswordView mas_makeConstraints:^(MASConstraintMaker *make) {
        if (@available(iOS 11.0, *)) {
            make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop);
            make.left.equalTo(self.view.mas_safeAreaLayoutGuideLeft);
            make.right.equalTo(self.view.mas_safeAreaLayoutGuideRight);
            make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom);
        }else{
            make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(kTopHeight, 0, 0, 0));
        }
    }];
    resetPasswordView.delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)setNavigation{
    UIButton* btnLeft = [UIButton buttonWithType:UIButtonTypeCustom];
    btnLeft.frame = CGRectMake(0,0,44,44);
    [btnLeft setImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    [btnLeft setImage:[UIImage imageNamed:@"back_click.png"] forState:UIControlStateHighlighted];
    [btnLeft addTarget:self action:@selector(doClickLeftAction) forControlEvents:UIControlEventTouchUpInside];
    [btnLeft setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    UIBarButtonItem* leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btnLeft];
    self.navigationItem.leftBarButtonItem = leftBarButtonItem;
}

-(void)doClickLeftAction{
    
    if(issuccess)
    {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
    else
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}

#pragma mark - ResetPasswordSubjectViewDelegate
- (void)resetPasswordView:(ResetPasswordSubjectView *)subView didPressSubmitBtnWithPassword:(NSString *)password{
    if(_vid == nil)
    {
        _vid = @"";
    }
    if(password == nil)
    {
        password = @"";
    }
    [self.datacontroller requestResetPassWithPassword:password
                                                  vid:_vid
                                               InView:subView
                                             callback:^(NSError *error, BOOL state, NSString *describle) {
        if (state) {
            RegSuccessSubjectView *regSuccessView = [RegSuccessSubjectView new];
            [self.view addSubview:regSuccessView];
            [regSuccessView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(64, 0, 0, 0));
            }];
            regSuccessView.backgroundColor = [UIColor whiteColor];
            regSuccessView.successType = RegSuccessTypeSeting;
            regSuccessView.delegate = self;
            issuccess = YES;
        }else{
            [MDB_UserDefault showNotifyHUDwithtext:self.datacontroller.resultMessage inView:self.view];
        }
    }];
}

#pragma mark - RegSuccessSubjectViewDelegate
- (void)regSuccessViewDidPressLoginBtn{
    NSArray *viewControllers = self.navigationController.viewControllers;
    for(UIViewController *vc in viewControllers)
    {
        if([vc isKindOfClass:[VKLoginViewController class]])
        {
            [self.navigationController popToViewController:vc animated:YES];
            return;
        }
    }
    
    VKLoginViewController *vc = [[VKLoginViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
    
    
//    if (viewControllers.count>=2) {
//        [self.navigationController popToViewController:viewControllers[1] animated:YES];
//    }
    
}

#pragma mark - getter and setter
- (ResetPassDataController *)datacontroller{
    if (!_datacontroller) {
        _datacontroller = [[ResetPassDataController alloc] init];
    }
    return _datacontroller;
}


@end
