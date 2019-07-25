//
//  ChangePhoneOldViewController.m
//  Meidebi
//  修改手机号验证原来手机号和密码
//  Created by mdb-losaic on 2019/4/24.
//  Copyright © 2019 meidebi. All rights reserved.
//

#import "ChangePhoneOldViewController.h"
#import "MDB_UserDefault.h"

#import "ChangePhoneNewViewController.h"

#import "AccountAndSecurityDataController.h"

@interface ChangePhoneOldViewController ()<UITextFieldDelegate>
{
    UITextField *fieldphone;
    UITextField *fieldpass;
    AccountAndSecurityDataController *datacontrol;
    NSString *strtoken;
}
@end

@implementation ChangePhoneOldViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"修改手机号";
    
    
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
    
    UIImage *image = [UIImage imageNamed:@"xiugaishoujihaodiyibu"];
    UIImageView *imgvtemp = [[UIImageView alloc] initWithFrame:CGRectMake(30, 40, kMainScreenW-60, image.size.height*(kMainScreenW-60)/image.size.width)];
    [imgvtemp setImage:image];
    [viewback addSubview:imgvtemp];
    
    
    
    fieldphone = [[UITextField alloc] init];
    [fieldphone setPlaceholder:@"输入手机号"];
    [fieldphone setKeyboardType:UIKeyboardTypeNumberPad];
    [fieldphone setUserInteractionEnabled:NO];
    [fieldphone setText:[NSString nullToString:[MDB_UserDefault defaultInstance].telphone]];
    UIView *viewphone = [self drawitemview:CGRectMake(0, imgvtemp.bottom+40, kMainScreenW, 80) andimage:@"phone" andfield:fieldphone];
    [viewback addSubview:viewphone];
    
    
    fieldpass = [[UITextField alloc] init];
    [fieldpass setPlaceholder:@"输入密码"];
    [fieldpass setSecureTextEntry:YES];
    [fieldpass setKeyboardType:UIKeyboardTypeEmailAddress];
    UIView *viewpass = [self drawitemview:CGRectMake(0, viewphone.bottom, kMainScreenW, viewphone.height) andimage:@"ChangePasswordOldpass_old" andfield:fieldpass];
    [viewback addSubview:viewpass];
    
    UIButton *loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [viewback addSubview:loginBtn];
    [loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(viewback.mas_right).offset(-20);
        make.left.equalTo(viewback.mas_left).offset(20);
        make.top.equalTo(viewpass.mas_bottom).offset(60 *kScale);
        make.height.offset(50 *kScale);
    }];
    [loginBtn setBackgroundImage:[MDB_UserDefault createImageWithColor:[UIColor colorWithHexString:@"#FD7A0E"]] forState:UIControlStateNormal];
    [loginBtn setBackgroundImage:[MDB_UserDefault createImageWithColor:[UIColor colorWithHexString:@"#ff8721"]] forState:UIControlStateHighlighted];
    loginBtn.titleLabel.font = [UIFont systemFontOfSize:16.f];
    [loginBtn setTitleColor:[UIColor whiteColor]
                   forState:UIControlStateNormal];
    [loginBtn setTitle:@"下一步" forState:UIControlStateNormal];
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
    if(strtoken.length>1)
    {
        ChangePhoneNewViewController *cvc = [[ChangePhoneNewViewController alloc] init];
        cvc.strtoken = strtoken;
        [self.navigationController pushViewController:cvc animated:YES];
        return;
    }
    NSString *strphone = fieldphone.text;
    NSString *strpass = fieldpass.text;
    if(strphone.length!=11)
    {
        [MDB_UserDefault showNotifyHUDwithtext:@"手机号码错误" inView:self.view];
        return;
    }
    
    if(datacontrol==nil)
    {
        datacontrol = [[AccountAndSecurityDataController alloc] init];
    }
    
    NSDictionary *dicpusn = @{@"userkey" : [NSString nullToString:[MDB_UserDefault defaultInstance].usertoken],@"mobile":strphone,@"password":strpass};
    
    [datacontrol requestAccountAndSecurityInView:self.view andpush:dicpusn andurl:URL_AccountAnew_Bind_Mobile_Number WithCallback:^(NSError *error, BOOL state, NSString *describle) {
        if(state)
        {
            strtoken = [NSString nullToString:[datacontrol.dicback objectForKey:@"token"]];
            if(strtoken.length>1)
            {
                ChangePhoneNewViewController *cvc = [[ChangePhoneNewViewController alloc] init];
                cvc.strtoken = strtoken;
                [self.navigationController pushViewController:cvc animated:YES];
            }
            
        }
        else
        {
            [MDB_UserDefault showNotifyHUDwithtext:describle inView:self.view];
        }
    }];
    
    
}


@end
