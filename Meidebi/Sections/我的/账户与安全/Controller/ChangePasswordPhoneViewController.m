//
//  ChangePasswordPhoneViewController.m
//  Meidebi
//  用手机号来修改密码
//  Created by mdb-losaic on 2019/4/24.
//  Copyright © 2019 meidebi. All rights reserved.
//

#import "ChangePasswordPhoneViewController.h"

#import "MDB_UserDefault.h"

#import "AccountAndSecurityDataController.h"

#import "MDB_ShareExstensionUserDefault.h"
#import <ShareSDKExtension/SSEThirdPartyLoginHelper.h>


@interface ChangePasswordPhoneViewController ()<UITextFieldDelegate>
{
    UITextField *fieldphone;
    UITextField *fieldcode;
    UIButton *btCode;
    UITextField *fieldnewpass;
    UITextField *fieldok;
    
    AccountAndSecurityDataController *datacontrol;
    
}

@property (nonatomic, assign) int timeout;

@end

@implementation ChangePasswordPhoneViewController

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
    
    fieldphone = [[UITextField alloc] init];
    [fieldphone setPlaceholder:@"输入手机号"];
    [fieldphone setKeyboardType:UIKeyboardTypeNumberPad];
    UIView *viewphone = [self drawitemview:CGRectMake(0, 0, kMainScreenW, 80) andimage:@"phone" andfield:fieldphone];
    [viewback addSubview:viewphone];
    
    
    fieldcode = [[UITextField alloc] init];
    [fieldcode setPlaceholder:@"输入验证码"];
    [fieldcode setKeyboardType:UIKeyboardTypeNumberPad];
    UIView *viewcode = [self drawitemview:CGRectMake(0, viewphone.bottom, kMainScreenW, viewphone.height) andimage:@"verifyCode" andfield:fieldcode];
    [viewback addSubview:viewcode];
    
    btCode = [[UIButton alloc] init];
    [viewcode addSubview:btCode];
    [btCode mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.offset(30*kScale);
        make.width.offset(93*kScale);
        make.centerY.mas_equalTo(fieldcode.mas_centerY);
        make.right.mas_equalTo(viewcode.mas_right).offset(-15);
    }];
    [btCode.layer setMasksToBounds:YES];
    [btCode.layer setCornerRadius:4];
    [btCode setTitle:@"获取验证码" forState:UIControlStateNormal];
    [btCode setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btCode.titleLabel setFont:[UIFont systemFontOfSize:12]];
    [btCode setBackgroundColor:RGB(255,146,93)];
    [btCode addTarget:self action:@selector(codeAction) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    
    fieldnewpass = [[UITextField alloc] init];
    [fieldnewpass setPlaceholder:@"输入新密码"];
    [fieldnewpass setSecureTextEntry:YES];
    [fieldnewpass setKeyboardType:UIKeyboardTypeEmailAddress];
    UIView *viewnewpass = [self drawitemview:CGRectMake(0, viewcode.bottom, kMainScreenW, viewphone.height) andimage:@"ChangePasswordOldpass_new" andfield:fieldnewpass];
    [viewback addSubview:viewnewpass];
    
    
    fieldok = [[UITextField alloc] init];
    [fieldok setPlaceholder:@"确认新密码"];
    [fieldok setSecureTextEntry:YES];
    [fieldok setKeyboardType:UIKeyboardTypeEmailAddress];
    UIView *viewokpass = [self drawitemview:CGRectMake(0, viewnewpass.bottom, kMainScreenW, viewphone.height) andimage:@"ChangePasswordOldpass_ok" andfield:fieldok];
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
    [field setDelegate:self];
    [view addSubview:field];
    
    UIView *viewline = [[UIView alloc] initWithFrame:CGRectMake(15, view.height-1, view.width-30, 1)];
    [viewline setBackgroundColor:RGB(235, 235, 235)];
    [view addSubview:viewline];
    return view;
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}


#pragma mark - 获取验证码
-(void)codeAction
{
    if([fieldphone.text stringByReplacingOccurrencesOfString:@" " withString:@""].length != 11)
    {
        
        [MDB_UserDefault showNotifyHUDwithtext:@"请输入正确的手机号" inView:self.view];
        return;
    }
    [self.view endEditing:YES];
    
   ///获取验证码
    if(datacontrol==nil)
    {
        datacontrol = [[AccountAndSecurityDataController alloc] init];
    }
    NSDictionary *dicpusn = @{@"userkey" : [NSString nullToString:[MDB_UserDefault defaultInstance].usertoken],@"mobile":fieldphone.text};
    
    [datacontrol requestAccountAndSecurityInView:self.view andpush:dicpusn andurl:URL_AccountModify_Password_Sms WithCallback:^(NSError *error, BOOL state, NSString *describle) {
        
        if(state)
        {///倒计时
            [self timing];
            [MDB_UserDefault showNotifyHUDwithtext:@"验证码发送成功，请注意查收" inView:self.view];
        }
        else
        {
            [MDB_UserDefault showNotifyHUDwithtext:describle inView:self.view];
        }
        
        
    }];
    
    
    
    
}

-(void)timing
{
    _timeout=60; //倒计时时间
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        if(_timeout<=0){ //倒计时结束，关闭
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                [btCode setTitle:@"获取验证码" forState:UIControlStateNormal];
                btCode.userInteractionEnabled = YES;
            });
        }else{
            int seconds = _timeout % 60;
            __block NSString *strTime = [NSString stringWithFormat:@"%.2d", seconds];
            dispatch_async(dispatch_get_main_queue(), ^{
                if ([strTime isEqual:@"00"]) {
                    strTime = @"60";
                }
                [btCode setTitle:[NSString stringWithFormat:@"%@秒",strTime] forState:UIControlStateNormal];
                btCode.userInteractionEnabled = NO;
            });
            _timeout--;
            
        }
    });
    dispatch_resume(_timer);
    
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if([string isEqualToString:@" "])
    {
        return NO;
    }
    return YES;
}

-(void)responsToButtonEvents
{
    NSString *strphone = fieldphone.text;
    NSString *strcode = fieldcode.text;
    NSString *strnew = fieldnewpass.text;
    NSString *strok = fieldnewpass.text;
    
    if(strphone.length!=11)
    {
        [MDB_UserDefault showNotifyHUDwithtext:@"手机号码错误" inView:self.view];
        return;
    }
    
    if(strcode.length<4||strcode.length>8)
    {
        [MDB_UserDefault showNotifyHUDwithtext:@"请输入正确的验证码" inView:self.view];
        return;
    }
    
    if(strnew.length<6||strnew.length>16)
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
    
    NSDictionary *dicpusn = @{@"userkey" : [NSString nullToString:[MDB_UserDefault defaultInstance].usertoken],@"password":strnew,@"confirm_password":strok,@"validate_type":@"mobile",@"validate_code":strcode,@"mobile":strphone};
    
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
