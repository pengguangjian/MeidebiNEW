//
//  ChangePasswordOldpassController.m
//  Meidebi
//  用旧密码来修改新密码
//  Created by mdb-losaic on 2019/4/24.
//  Copyright © 2019 meidebi. All rights reserved.
//

#import "ChangePasswordOldpassController.h"
#import "MDB_UserDefault.h"

#import "AccountAndSecurityDataController.h"

#import "MDB_ShareExstensionUserDefault.h"
#import <ShareSDKExtension/SSEThirdPartyLoginHelper.h>


@interface ChangePasswordOldpassController ()<UITextFieldDelegate>
{
    UITextField *fieldoldpass;
    UITextField *fieldnewpass;
    UITextField *fieldok;
    
    
    AccountAndSecurityDataController *datacontrol;
    
}
@end

@implementation ChangePasswordOldpassController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"修改密码";
    
    [self drawSubview];
    
}

-(void)drawSubview
{
    UIView *viewback = [[UIView alloc] init];
    [self.view addSubview:viewback];
    [viewback mas_makeConstraints:^(MASConstraintMaker *make) {
        if (@available(iOS 11.0, *)) {
            make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop);
            make.left.equalTo(self.view.mas_safeAreaLayoutGuideLeft);
            make.right.equalTo(self.view.mas_safeAreaLayoutGuideRight);
            make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom);
        }else{
            make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(kTopHeight, 0, 0, 0));
        }
    }];
    
    fieldoldpass = [[UITextField alloc] init];
    [fieldoldpass setPlaceholder:@"输入旧密码"];
    UIView *viewoldpass = [self drawitemview:CGRectMake(0, 0, kMainScreenW, 80) andimage:@"ChangePasswordOldpass_old" andfield:fieldoldpass];
    [viewback addSubview:viewoldpass];
    
    ///ChangePasswordOldpass_new ChangePasswordOldpass_ok
    
    fieldnewpass = [[UITextField alloc] init];
    [fieldnewpass setPlaceholder:@"输入新密码"];
    UIView *viewnewpass = [self drawitemview:CGRectMake(0, viewoldpass.bottom, kMainScreenW, viewoldpass.height) andimage:@"ChangePasswordOldpass_new" andfield:fieldnewpass];
    [viewback addSubview:viewnewpass];
    
    
    fieldok = [[UITextField alloc] init];
    [fieldok setPlaceholder:@"确认新密码"];
    UIView *viewokpass = [self drawitemview:CGRectMake(0, viewnewpass.bottom, kMainScreenW, viewoldpass.height) andimage:@"ChangePasswordOldpass_ok" andfield:fieldok];
    [viewback addSubview:viewokpass];
    
    UIButton *loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [viewback addSubview:loginBtn];
    [loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(viewback.mas_right).offset(-20);
        make.left.equalTo(viewback.mas_left).offset(20);
        make.top.equalTo(viewokpass.mas_bottom).offset(60 *kScale);
        make.height.offset(50 *kScale);
    }];
    [loginBtn setBackgroundImage:[MDB_UserDefault createImageWithColor:[UIColor colorWithHexString:@"#FD7A0E"]] forState:UIControlStateNormal];
    [loginBtn setBackgroundImage:[MDB_UserDefault createImageWithColor:[UIColor colorWithHexString:@"#ff8721"]] forState:UIControlStateHighlighted];
    loginBtn.titleLabel.font = [UIFont systemFontOfSize:16.f];
    [loginBtn setTitleColor:[UIColor whiteColor]
                   forState:UIControlStateNormal];
    [loginBtn setTitle:@"确认" forState:UIControlStateNormal];
    loginBtn.layer.masksToBounds  =YES;
    loginBtn.layer.cornerRadius = 4.f;
    loginBtn.tag = 101;
    [loginBtn addTarget:self action:@selector(responsToButtonEvents) forControlEvents:UIControlEventTouchUpInside];
    
    
}

-(UIView *)drawitemview:(CGRect)rect andimage:(NSString *)strimage andfield:(UITextField *)field
{
    UIView *view = [[UIView alloc] initWithFrame:rect];
    [view setBackgroundColor:[UIColor whiteColor]];
    
    UIImageView *imagev = [[UIImageView alloc] initWithFrame:CGRectMake(20, 0, 20, 20)];
    imagev.centerY = view.height/2.0;
    [imagev setImage:[UIImage imageNamed:strimage]];
    [imagev setContentMode:UIViewContentModeScaleAspectFit];
    [view addSubview:imagev];
    
    
    [field setFrame:CGRectMake(imagev.right+10, 0, view.width-imagev.right-20, view.height)];
    [field setTextColor:RGB(50, 50, 50)];
    [field setTextAlignment:NSTextAlignmentLeft];
    [field setFont:[UIFont systemFontOfSize:15]];
    [field setSecureTextEntry:YES];
    [field setKeyboardType:UIKeyboardTypeEmailAddress];
    [field setDelegate:self];
    [view addSubview:field];
    
    UIView *viewline = [[UIView alloc] initWithFrame:CGRectMake(15, view.height-1, view.width-30, 1)];
    [viewline setBackgroundColor:RGB(235, 235, 235)];
    [view addSubview:viewline];
    return view;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if([string isEqualToString:@" "])
    {
        return NO;
    }
    return YES;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}


-(void)responsToButtonEvents
{
    NSString *strold = fieldoldpass.text;
    NSString *strnew = fieldnewpass.text;
    NSString *strok = fieldok.text;
    if(strold.length<6||strold.length>16||strnew.length<6||strnew.length>16)
    {
        [MDB_UserDefault showNotifyHUDwithtext:@"密码支持6~16位" inView:self.view];
        return;
    }
    if(![strnew isEqualToString:strok])
    {
        [MDB_UserDefault showNotifyHUDwithtext:@"新密码和确认密码不一致" inView:self.view];
        return;
    }
    if(datacontrol==nil)
    {
        datacontrol = [[AccountAndSecurityDataController alloc] init];
    }
    
    NSDictionary *dicpusn = @{@"userkey" : [NSString nullToString:[MDB_UserDefault defaultInstance].usertoken],@"password":strold,@"new_password":strnew,@"confirm_password":strok,@"validate_type":@"password"};
    
    [datacontrol requestAccountAndSecurityInView:self.view andpush:dicpusn andurl:URL_AccountModify_Password WithCallback:^(NSError *error, BOOL state, NSString *describle) {
        
        if(state)
        {
            [[MDB_UserDefault defaultInstance] setUserNil];
            [[MDB_ShareExstensionUserDefault defaultInstance] saveUserToken:@""];
            //退出第三方登录
            [SSEThirdPartyLoginHelper logout:[SSEThirdPartyLoginHelper currentUser]];
            //消息清空
            [MDB_UserDefault setMessage:NO];
            NSInteger needPhone = 1;
            [MDB_UserDefault setNeedPhoneStatue:needPhone==1?YES:NO];
            [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:@"weiduxiaoxinumpgg"];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"tabbarnumessagenum" object:nil];
            
            [MDB_UserDefault showNotifyHUDwithtext:@"密码修改成功，请重新登录" inView:self.view];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                [self.navigationController popToRootViewControllerAnimated:YES];
                
            });
            
        }
        else
        {
            [MDB_UserDefault showNotifyHUDwithtext:describle inView:self.view];
        }
        
        
    }];
    
    
}

@end
