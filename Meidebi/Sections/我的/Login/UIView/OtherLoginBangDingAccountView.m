//
//  OtherLoginBangDingAccountView.m
//  Meidebi
//
//  Created by mdb-losaic on 2019/3/11.
//  Copyright © 2019年 meidebi. All rights reserved.
//

#import "OtherLoginBangDingAccountView.h"

#import "MDB_UserDefault.h"

#import "OtherLoginBangDingPhoneViewController.h"

#import "HTTPManager.h"

@interface OtherLoginBangDingAccountView ()
{
    UILabel *lbtop;
    UITextField *fieldaccount;
    UITextField *fieldpass;
    
}

@end


@implementation OtherLoginBangDingAccountView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(id)initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame])
    {
        
        [self setupSubviews];
    }
    return self;
}

-(void)setupSubviews
{
    UITapGestureRecognizer *tapview = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiskey)];
    [self addGestureRecognizer:tapview];
    UIScrollView *scv = [[UIScrollView alloc] init];
    [self addSubview:scv];
    [scv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    UIView *contairView = [UIView new];
    [scv addSubview:contairView];
    [contairView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(scv);
        make.width.equalTo(scv);
    }];
    
    lbtop = [[UILabel alloc] init];
    [contairView addSubview:lbtop];
    [lbtop mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(contairView.mas_left).offset(15);
        make.right.equalTo(contairView.mas_right).offset(-15);
        make.height.offset(40);
        make.top.offset(30);
    }];

    [lbtop setTextColor:RGB(188, 188, 188)];
    [lbtop setText:[NSString stringWithFormat:@"Hi，%@欢迎来没得比，完成绑定后%@/账号都可以登录哦~",_strname,_strtype]];
    [lbtop setTextAlignment:NSTextAlignmentLeft];
    [lbtop setNumberOfLines:2];
    [lbtop setFont:[UIFont systemFontOfSize:15]];
    
    
    fieldaccount = [[UITextField alloc] init];
    [fieldaccount setPlaceholder:@"邮箱/用户名/手机号"];
    UIView *viewaccount = [self drawitem:CGRectZero andimage:[UIImage imageNamed:@"bangdingaccount"] andname:@"没得比账号" andfield:fieldaccount];
    [contairView addSubview:viewaccount];
    [viewaccount mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(contairView.mas_left).offset(15);
        make.right.equalTo(contairView.mas_right).offset(-15);
        make.top.equalTo(lbtop.mas_bottom).offset(30);
        make.height.offset(60*kScale);
    }];
    
    fieldpass = [[UITextField alloc] init];
    [fieldpass setPlaceholder:@"密码"];
    [fieldpass setSecureTextEntry:YES];
    UIView *viewpass = [self drawitem:CGRectZero andimage:[UIImage imageNamed:@"bangdingpass"] andname:@"请输入密码" andfield:fieldpass];
    [contairView addSubview:viewpass];
    [viewpass mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(contairView.mas_left).offset(15);
        make.right.equalTo(contairView.mas_right).offset(-15);
        make.top.equalTo(viewaccount.mas_bottom).offset(5);
        make.height.offset(60*kScale);
    }];
    
    UIButton *loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [contairView addSubview:loginBtn];
    [loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(contairView.mas_right).offset(-20);
        make.left.equalTo(contairView.mas_left).offset(20);
        make.top.equalTo(viewpass.mas_bottom).offset(40 *kScale);
        make.height.offset(50 *kScale);
    }];
    [loginBtn setBackgroundImage:[MDB_UserDefault createImageWithColor:[UIColor colorWithHexString:@"#FD7A0E"]] forState:UIControlStateNormal];
    [loginBtn setBackgroundImage:[MDB_UserDefault createImageWithColor:[UIColor colorWithHexString:@"#ff8721"]] forState:UIControlStateHighlighted];
    loginBtn.titleLabel.font = [UIFont systemFontOfSize:16.f];
    [loginBtn setTitleColor:[UIColor whiteColor]
                   forState:UIControlStateNormal];
    [loginBtn setTitle:@"登录" forState:UIControlStateNormal];
    loginBtn.layer.masksToBounds  =YES;
    loginBtn.layer.cornerRadius = 4.f;
    loginBtn.tag = 101;
    [loginBtn addTarget:self action:@selector(responsToButtonEvents:) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [contairView addSubview:backBtn];
    [backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(contairView.mas_right).offset(-20);
        make.left.equalTo(contairView.mas_left).offset(20);
        make.top.equalTo(loginBtn.mas_bottom);
        make.height.offset(50 *kScale);
    }];
    
    backBtn.titleLabel.font = [UIFont systemFontOfSize:15.f];
    [backBtn setTitleColor:RGB(203, 203, 203)
                   forState:UIControlStateNormal];
    [backBtn setTitle:@"跳过" forState:UIControlStateNormal];
    backBtn.layer.masksToBounds  =YES;
    backBtn.layer.cornerRadius = 4.f;
    backBtn.tag = 102;
    [backBtn addTarget:self action:@selector(responsToButtonEvents:) forControlEvents:UIControlEventTouchUpInside];
    
    
    
//    UIButton *bangdingphoneBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    [contairView addSubview:bangdingphoneBtn];
//    [bangdingphoneBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(contairView.mas_left).offset(20);
//        make.bottom.equalTo(self.mas_bottom).offset(-10);
//        make.height.offset(50 *kScale);
//    }];
//    
//    bangdingphoneBtn.titleLabel.font = [UIFont systemFontOfSize:14.f];
//    NSDictionary *attribtDic = @{NSUnderlineStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle],NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#69BAF1"]};
//    NSMutableAttributedString *attribtStr = [[NSMutableAttributedString alloc]initWithString:@"已有账号，绑定手机" attributes:attribtDic];
//    [bangdingphoneBtn setAttributedTitle:attribtStr forState:UIControlStateNormal];
//    bangdingphoneBtn.tag = 103;
//    [bangdingphoneBtn addTarget:self action:@selector(responsToButtonEvents:) forControlEvents:UIControlEventTouchUpInside];
    
    
    [contairView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(backBtn.mas_bottom);
    }];
    
}


-(UIView *)drawitem:(CGRect)rect andimage:(UIImage *)image andname:(NSString *)name andfield:(UITextField *)field
{
    UIView *view = [[UIView alloc] initWithFrame:rect];
    
    UIImageView *imgv = [[UIImageView alloc] init];
    [imgv setImage:image];
    [view addSubview:imgv];
    [imgv mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.offset(10);
        make.height.equalTo(view.mas_height).multipliedBy(0.3);
        make.width.equalTo(view.mas_height).multipliedBy(0.3);
        make.centerY.equalTo(view);
        
    }];
    [imgv setContentMode:UIViewContentModeScaleAspectFit];
    
    UILabel *lbname = [[UILabel alloc] init];
    [view addSubview:lbname];
    [lbname mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(imgv.mas_right).offset(10);
        make.top.bottom.equalTo(view);
        make.width.offset(80);
    }];
    [lbname setTextAlignment:NSTextAlignmentLeft];
    [lbname setText:name];
    [lbname setTextColor:RGB(150, 150, 150)];
    [lbname setFont:[UIFont systemFontOfSize:15]];
    
    [view addSubview:field];
    [field mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(lbname.mas_right).offset(15);
        make.top.bottom.equalTo(view);
        make.right.equalTo(view.mas_right).offset(-10);
    }];
    [field setTextColor:RGB(50, 50, 50)];
    [field setFont:[UIFont systemFontOfSize:15]];
    [field setTextAlignment:NSTextAlignmentLeft];
    
    UIView *viewline = [[UIView alloc] init];
    [viewline setBackgroundColor:RGB(235, 235, 235)];
    [view addSubview:viewline];
    [viewline mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(view);
        make.bottom.equalTo(view);
        make.height.offset(1);
    }];
    
    return view;
}
-(void)dismiskey
{
   [self endEditing:YES];
}
-(void)valueInput
{
   [lbtop setText:[NSString stringWithFormat:@"Hi，%@欢迎来没得比，完成绑定后%@/账号都可以登录哦~",_strname,_strtype]];
}

-(void)responsToButtonEvents:(UIButton *)sender
{
    switch (sender.tag) {
        case 101:
        {////登录
            if (fieldaccount.text.length <= 0) {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                                    message:@"请输入登录帐号！"
                                                                   delegate:self
                                                          cancelButtonTitle:@"确定"
                                                          otherButtonTitles:nil, nil];
                [alertView show];
                
                break;
            }
            
            if (fieldpass.text.length <= 0) {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                                    message:@"请输入登录密码！"
                                                                   delegate:self
                                                          cancelButtonTitle:@"确定"
                                                          otherButtonTitles:nil, nil];
                [alertView show];
                
                break;
            }
            NSMutableDictionary *dicpus = [NSMutableDictionary new];
            [dicpus setDictionary:_dicparams];
            [dicpus setObject:fieldaccount.text forKey:@"username"];
            [dicpus setObject:fieldpass.text forKey:@"password"];
            
            [HTTPManager sendRequestUrlToService:url_loginAndBind withParametersDictionry:dicpus view:self completeHandle:^(NSURLSessionTask *opration, id responceObjct, NSError *error) {
                if (responceObjct) {
                    
                    NSString* hexString = [[NSString alloc]initWithData:responceObjct encoding:NSUTF8StringEncoding];
                    NSDictionary* dictResult = (NSDictionary*)[hexString JSONValue];
                    if ([[dictResult objectForKey:@"status"] intValue] == 1) {
                        
                        [MobClick event:@"wode_denglu"];
                        [[MDB_UserDefault defaultInstance] setUserWithDic:[dictResult objectForKey:@"user"] token:[dictResult objectForKey:@"data"]];
                        [MDB_UserDefault setThirdPartyLoginSuccess:YES];
                        [MDB_UserDefault showNotifyHUDwithtext:@"登录成功" inView:[[UIApplication sharedApplication].windows firstObject]];
                        NSString *telphone = [[dictResult objectForKey:@"user"] objectForKey:@"telphone"];
                        
                        [self backToWithtelphone:telphone];
                        [self setHttpToken];
                        
                        
                    }
                    else
                    {
                        
                        NSString* info = [NSString nullToString:[dictResult objectForKey:@"info"]];
                        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                                            message:info
                                                                           delegate:nil
                                                                  cancelButtonTitle:@"确定"
                                                                  otherButtonTitles:nil, nil];
                        
                        [alertView show];
                    }
                }
                else
                {
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                                        message:@"登录失败"
                                                                       delegate:nil
                                                              cancelButtonTitle:@"确定"
                                                              otherButtonTitles:nil, nil];
                    
                    [alertView show];
                }
                
            }];
            
           
        }
            break;
        case 102:
        {////跳过
            [self otherLogindValue:_dicparams andurl:_strpushurl andisback:NO];
            
        }
            break;
        case 103:
        {////已有账号，绑定手机
            OtherLoginBangDingPhoneViewController *ovc = [[OtherLoginBangDingPhoneViewController alloc] init];
            ovc.strtype = _strtype;
            ovc.strname = _strname;
            ovc.dicparams = _dicparams;
            ovc.strpushurl = _strpushurl;
            [self.viewController.navigationController pushViewController:ovc animated:YES];
            
        }
            break;
        default:
            break;
    }
    
}
-(void)backsAction
{
    [self otherLogindValue:_dicparams andurl:_strpushurl andisback:YES];
}
-(void)otherLogindValue:(NSDictionary *)dicll andurl:(NSString *)url andisback:(BOOL)isback
{
    
    
    [HTTPManager sendRequestUrlToService:url withParametersDictionry:dicll view:self completeHandle:^(NSURLSessionTask *opration, id responceObjct, NSError *error) {
        //        if(error)
        //        {
        //            NSData *data = [error.userInfo objectForKey:@"com.alamofire.serialization.response.error.data"];
        //            NSString *strerr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        //            NSString *strtemp = @"1";
        //            NSLog(@"%@",strerr);
        //        }
        if (responceObjct) {
            
            NSString* hexString = [[NSString alloc]initWithData:responceObjct encoding:NSUTF8StringEncoding];
            NSDictionary* dictResult = (NSDictionary*)[hexString JSONValue];
            if ([[dictResult objectForKey:@"status"] intValue] == 1) {
                [MobClick event:@"wode_denglu"];
                [[MDB_UserDefault defaultInstance] setUserWithDic:[dictResult objectForKey:@"user"] token:[dictResult objectForKey:@"data"]];
                [MDB_UserDefault setThirdPartyLoginSuccess:YES];
                [MDB_UserDefault showNotifyHUDwithtext:@"登录成功" inView:[[UIApplication sharedApplication].windows firstObject]];
                NSString *telphone = [[dictResult objectForKey:@"user"] objectForKey:@"telphone"];
                
                [self backToWithtelphone:telphone];
                [self setHttpToken];
                
                
            }
            else {
                [[MDB_UserDefault defaultInstance]setUserNil];
                NSString* message = @"登录失败";
                NSString* info = [dictResult objectForKey:@"info"];
                if (info && [info isKindOfClass:[NSString class]]) {
                    if( [info hasSuffix:@"NOT_BIND"]){
                        //跳过绑定账号
                        return ;
                    }
                }
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                                    message:message
                                                                   delegate:nil
                                                          cancelButtonTitle:@"确定"
                                                          otherButtonTitles:nil, nil];
                
                [alertView show];
                if(isback)
                {
                    [self backToWithtelphone:@""];
                }
                
            }
            
        }else{
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                                message:@"网络连接超时"
                                                               delegate:nil
                                                      cancelButtonTitle:@"确定"
                                                      otherButtonTitles:nil, nil];
            
            [alertView show];
            if(isback)
            {
                [self backToWithtelphone:@""];
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


- (void)backToWithtelphone: (NSString *)telphone{
    NSArray *arrvcs = self.viewController.navigationController.viewControllers;
    if(arrvcs.count>=3)
    {
        UIViewController *vc = arrvcs[arrvcs.count-3];
        [self.viewController.navigationController popToViewController:vc animated:YES];
    }
    else
    {
        [self.viewController.navigationController popViewControllerAnimated:YES];
    }
    
}

@end
