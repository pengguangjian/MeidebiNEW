//
//  RetrievePasswordViewController.m
//  Meidebi
//
//  Created by mdb-admin on 16/7/13.
//  Copyright © 2016年 meidebi. All rights reserved.
//

#import "RetrievePasswordViewController.h"
#import "RegCodeSubjectView.h"
#import "VKLostViewController.h"
#import "ResetPasswordViewController.h"
#import "RegCodeDataController.h"
@interface RetrievePasswordViewController ()
<
RegCodeSubjectViewDelegate
>
@property (nonatomic, strong) RegCodeDataController *datacontroller;
@property (nonatomic, strong) RegCodeSubjectView *codeSubview;
@end

@implementation RetrievePasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavigation];
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.title = @"找回密码";
    _codeSubview = [RegCodeSubjectView new];
    [self.view addSubview:_codeSubview];
    if(_ischanpassword == YES)
    {
        self.title = @"修改密码";
        _codeSubview.ischangepassword = YES;
    }
    [_codeSubview mas_makeConstraints:^(MASConstraintMaker *make) {
        if (@available(iOS 11.0, *)) {
            make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop);
            make.left.equalTo(self.view.mas_safeAreaLayoutGuideLeft);
            make.right.equalTo(self.view.mas_safeAreaLayoutGuideRight);
            make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom);
        }else{
            make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(kTopHeight, 0, 0, 0));
        }
    }];
    _codeSubview.delegate = self;
    _codeSubview.regType = RegCodeTypeRetrieve;
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
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - RegCodeSubjectViewDelegate
- (void)regCodeView:(RegCodeSubjectView *)subView didPressAcquireCodeBtnWithMobile:(NSString *)mobileNumber{
    [self.datacontroller requestGetCodeWithMobilNumber:mobileNumber
                                               regType:RegCodeTypeRetrieve
                                                InView:subView
                                              callback:^(NSError *error, BOOL state, NSString *describle) {
                                                    if (![self.datacontroller.resultMessage isEqualToString:@""]) {
                                                        [_codeSubview bindMobileWarnData:self.datacontroller.resultMessage];
                                                    }
                                                }];
}

- (void)regCodeView:(RegCodeSubjectView *)subView
                    didPressRegBtnWithMobile:(NSString *)mobileNumber
                    andCode:(NSString *)code
                    withInvite: (NSString *)invite
                    andpassword:(NSString *)password
{
    [self.datacontroller requestVerificationCodeWithMobilNumber:mobileNumber
                                                           code:code
                                                           type:@"3"
                                                         InView:subView
                                                       callback:^(NSError *error, BOOL state, NSString *describle) {
                                                           if (state) {
                                                               ResetPasswordViewController *resetPasswordVc = [[ResetPasswordViewController alloc] init];
                                                               resetPasswordVc.vid = self.datacontroller.vid;
                                                               [self.navigationController pushViewController:resetPasswordVc animated:YES];
                                                           }else{
                                                               if (![self.datacontroller.resultMessage isEqualToString:@""]) {
                                                                   [_codeSubview bindCodeWarnData:self.datacontroller.resultMessage];
                                                               }
                                                           }
                                                       }];
    
    
}
//- (void)regCodeView:(RegCodeSubjectView *)subView didPressRegBtnWithMobile:(NSString *)mobileNumber
//                                                                   andCode:(NSString *)code
//                                                                withInvite:(NSString *)invite{
//    
//    [self.datacontroller requestVerificationCodeWithMobilNumber:mobileNumber
//                                                           code:code
//                                                           type:@"3"
//                                                         InView:subView
//                                                       callback:^(NSError *error, BOOL state, NSString *describle) {
//                                                           if (state) {
//                                                               ResetPasswordViewController *resetPasswordVc = [[ResetPasswordViewController alloc] init];
//                                                               resetPasswordVc.vid = self.datacontroller.vid;
//                                                               [self.navigationController pushViewController:resetPasswordVc animated:YES];
//                                                           }else{
//                                                               if (![self.datacontroller.resultMessage isEqualToString:@""]) {
//                                                                   [_codeSubview bindCodeWarnData:self.datacontroller.resultMessage];
//                                                               }
//                                                           }
//                                                       }];
//}

- (void)regCodeViewDidPressRetrieveMailBtn{
    UIStoryboard *Oneselfboard = [UIStoryboard storyboardWithName:@"Oneself" bundle:nil];
    VKLostViewController *lostVc=[Oneselfboard instantiateViewControllerWithIdentifier:@"com.mdb.VKLostVC"];
    [self.navigationController pushViewController:lostVc animated:YES];

}

#pragma mark - getter and setter
- (RegCodeDataController *)datacontroller{
    if (!_datacontroller) {
        _datacontroller = [[RegCodeDataController alloc] init];
    }
    return _datacontroller;
}

@end
