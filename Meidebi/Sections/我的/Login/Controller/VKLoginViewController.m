//
//  VKLoginViewController.m
//  Meidebi
//
//  Created by Yin HuaJun on 13-6-17.
//  Copyright (c) 2013年 meidebi. All rights reserved.
//

#import "VKLoginViewController.h"
#import "HTTPManager.h"
#import "LoginSubjectView.h"
#import "MDB_UserDefault.h"
#import "SVModalWebViewController.h"
#import "RetrievePasswordViewController.h"
#import "RegCodeViewController.h"
#import <ShareSDKExtension/SSEThirdPartyLoginHelper.h>
#import "BindingUserInfoViewController.h"
#import <UMAnalytics/MobClick.h>
#import <AlibabaAuthSDK/ALBBSDK.h>

#import "ResetPasswordViewController.h"

#import "RegCodeDataController.h"

#import <AlibcTradeSDK/AlibcTradeSDK.h>
//#import <ALBBLoginSDK/ALBBLoginService.h>

#import "TaoBaoWebViewViewController.h"

#import "OtherLoginAlterView.h"

#import "OtherLoginBangDingAccountViewController.h"

@interface VKLoginViewController ()
<
UIAlertViewDelegate,
LoginSubjectViewDelegate,
TaoBaoWebViewViewControllerDelegate
>

@end

@implementation VKLoginViewController{
    BOOL     _isQQload;
    
    RegCodeDataController *dataController;
    LoginSubjectView *subView;
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    self.title=@"登录";
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18],NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#666666"]}] ;
    [self setnavigation];
    _isQQload=YES;
    
    subView = [LoginSubjectView new];
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
}

-(void)setnavigation{
    UIButton *butleft=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 44, 44)];
    [butleft setImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    [butleft setImage:[UIImage imageNamed:@"back_click.png"] forState:UIControlStateHighlighted];
    [butleft addTarget:self action:@selector(doClickBackAction) forControlEvents:UIControlEventTouchUpInside];
    [butleft setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    UIBarButtonItem *leftBar=[[UIBarButtonItem alloc]initWithCustomView:butleft];
    
    self.navigationItem.leftBarButtonItem=leftBar;
    
    UIButton *butright=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 44, 44)];
    
    UILabel *lass=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 44, 44)];
    lass.textColor = [UIColor colorWithHexString:@"#666666"];
    lass.text=@"注册";
    [butright addSubview:lass];
    [lass setTextColor:[UIColor colorWithRed:68.0/255.0 green:68.0/255.0 blue:68.0/255.0 alpha:1.0]];
    [butright addTarget:self action:@selector(btnRightRegistClick) forControlEvents:UIControlEventTouchUpInside];
   
    UIBarButtonItem *rightBar=[[UIBarButtonItem alloc]initWithCustomView:butright];
    self.navigationItem.rightBarButtonItem=rightBar;
}

-(void)btnRightRegistClick{
    RegCodeViewController  *regCodeVc = [[RegCodeViewController alloc] init];
    [self.navigationController pushViewController:regCodeVc animated:YES ];
}


#pragma mark - 第三方登录获取服务器数据
-(void)doAuthLoginWithUser:(id)uservalue type:(SSDKPlatformType)typet
{///SSDKUser ALBBUser
    SSDKUser *user;
    ALBBUser *user1;
    if([uservalue isKindOfClass:[SSDKUser class]])
    {
        user = uservalue;
    }
    else if([uservalue isKindOfClass:[ALBBUser class]])
    {
        user1 = uservalue;
    }
    
    NSString *reqkey=@"";
    NSString *url=@"";
    NSString *token=@"";
    NSString *nickname;
    NSString *stl=[user.credential token]?[user.credential token]:@"tongx";
    NSString *strdenglutype = @"";
    NSDictionary *dicll= nil;
    if (typet==SSDKPlatformTypeQQ) {
        url = url_login_QQ;
        strdenglutype = @"QQ";
        reqkey=@"openid";
        token=@"access_token";
        nickname=@"qqnickname";
        dicll = @{reqkey:[NSString nullToString:user.uid],nickname:[NSString nullToString:user.nickname],token:stl,@"type":@"1"};
    }else if (typet==SSDKPlatformTypeSinaWeibo) {
        url=url_login_weibo;
        strdenglutype = @"微博";
        reqkey=@"uid";
        nickname=@"weibo_nickname";
        token=@"weibo_access_token";
        dicll = @{reqkey:[NSString nullToString:user.uid],nickname:[NSString nullToString:user.nickname],token:stl,@"type":@"2"};
    }else if (typet == SSDKPlatformTypeWechat){
        url=url_login_wx;
        nickname=@"nickname";
        strdenglutype = @"微信";
        NSDictionary *credentialDict = user.credential.rawData;
        NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:user.rawData];
        [dict addEntriesFromDictionary:credentialDict];
        dicll = @{
                  @"unionid":[NSString nullToString:dict[@"unionid"]],
                  @"access_token":[NSString nullToString:dict[@"access_token"]],
                  @"avatar":[NSString nullToString:dict[@"headimgurl"]],
                  nickname:[NSString nullToString:dict[@"nickname"]],
                   @"openid":[NSString nullToString:dict[@"openid"]],
                  @"type":@"4"
                  };
    }else if (typet == SSDKPlatformTypeAny)
    {
        url=url_login_taobao;
        strdenglutype = @"淘宝";
        nickname=@"tbnickname";
//        user.avatarUrl
        dicll = @{
                  @"tbuser_id":[NSString nullToString:[self paramValueOfUrl:user1.avatarUrl withParam:@"userId"]],
                  nickname:[NSString nullToString:user1.nick],
                  @"tbaccess_token":[NSString nullToString:user1.topAccessToken],
                  @"type":[NSString nullToString:@"3"]
                  };
        
        
        
    }else{
        
        [MDB_UserDefault showNotifyHUDwithtext:@"登录失败" inView:[[UIApplication sharedApplication].windows firstObject]];
        
        return;
    }
   
    ///这里添加邀请码
    ///将邀请码发送给后台
    NSString *stryaoqingma = [NSString nullToString:[[NSUserDefaults standardUserDefaults] objectForKey:@"meb_user_yaoqingma"]];
    NSMutableDictionary *dictemp = [[NSMutableDictionary alloc] initWithDictionary:dicll];
    
    if(stryaoqingma.length>6)
    {
        NSString *strtimec = [MDB_UserDefault getNowTimeTimestamp];
        
        NSArray *arrtemp = [stryaoqingma componentsSeparatedByString:@"-"];
        if(arrtemp.count == 2)
        {
            NSString *strtimecL = arrtemp[1];
            if(([strtimec integerValue] - [strtimecL integerValue])<=1296000)
            {
                [dictemp setObject:arrtemp[0] forKey:@"pucode"];
            }
        }
        
    }
    
    [HTTPManager sendRequestUrlToService:url_login_IsBangding withParametersDictionry:dictemp view:self.view completeHandle:^(NSURLSessionTask *opration, id responceObjct, NSError *error) {
        if (responceObjct) {
            
            NSString* hexString = [[NSString alloc]initWithData:responceObjct encoding:NSUTF8StringEncoding];
            NSDictionary* dictResult = (NSDictionary*)[hexString JSONValue];
            if ([[dictResult objectForKey:@"status"] intValue] == 1) {
                NSDictionary *dicdata = [dictResult objectForKey:@"data"];
                
                if([[NSString nullToString:[dicdata objectForKey:@"warn"]] integerValue] == 1)
                {///需要绑定
                    OtherLoginBangDingAccountViewController *ovc = [[OtherLoginBangDingAccountViewController alloc] init];
                    ovc.strname = [NSString nullToString:[dictemp objectForKey:nickname]];
                    ovc.strtype = strdenglutype;
                    ovc.dicparams = dictemp;
                    ovc.strpushurl = url;
                    [self.navigationController pushViewController:ovc animated:YES];
                }
                else
                {///不需要绑定
                    [self otherLogindValue:dictemp andurl:url];
                }
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

-(void)otherLogindValue:(NSDictionary *)dicll andurl:(NSString *)url
{
    
    
    [HTTPManager sendRequestUrlToService:url withParametersDictionry:dicll view:self.view completeHandle:^(NSURLSessionTask *opration, id responceObjct, NSError *error) {
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
                _isQQload=NO;
                [MDB_UserDefault showNotifyHUDwithtext:@"登录成功" inView:[[UIApplication sharedApplication].windows firstObject]];
                NSString *telphone = [[dictResult objectForKey:@"user"] objectForKey:@"telphone"];
                
                [self backToWithtelphone:telphone];
                [self setHttpToken];
                
                
            }
            else {
                [[MDB_UserDefault defaultInstance]setUserNil];
                NSString* message = @"登录失败";
                NSString* info = [NSString nullToString:[dictResult objectForKey:@"info"]];
                if (info && [info isKindOfClass:[NSString class]]) {
                    if( [info hasSuffix:@"NOT_BIND"]){
                        //跳过绑定账号
                        return ;
                    }
                    else{
                        message = info;
                    }
                }
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                                    message:message
                                                                   delegate:nil
                                                          cancelButtonTitle:@"确定"
                                                          otherButtonTitles:nil, nil];
                
                [alertView show];
                
            }
            
        }else{
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                                message:@"网络连接超时"
                                                               delegate:nil
                                                      cancelButtonTitle:@"确定"
                                                      otherButtonTitles:nil, nil];
            
            [alertView show];
        }
    }];
}

////淘宝登录成功返回
- (void)taobaoLoginBackUrl:(NSString *)strurl
{
    NSString *strcode = [self paramValueOfUrl:strurl withParam:@"code"];
    NSString *strstate = [self paramValueOfUrl:strurl withParam:@"state"];
    strurl = [NSString stringWithFormat:@"%@/Customer-tbWebLogin?code=%@&state=%@",URL_HR,strcode,strstate];
    NSDictionary *dicpush = @{@"type":@"3",@"code":strcode,@"state":strstate};
    
    [HTTPManager sendRequestUrlToService:url_login_IsBangding withParametersDictionry:dicpush view:self.view completeHandle:^(NSURLSessionTask *opration, id responceObjct, NSError *error) {
        if (responceObjct) {
            
            NSString* hexString = [[NSString alloc]initWithData:responceObjct encoding:NSUTF8StringEncoding];
            NSDictionary* dictResult = (NSDictionary*)[hexString JSONValue];
            if ([[dictResult objectForKey:@"status"] intValue] == 1) {
                NSDictionary *dicdata = [dictResult objectForKey:@"data"];
                
                if([[NSString nullToString:[dicdata objectForKey:@"warn"]] integerValue] == 1)
                {///需要绑定
                    OtherLoginBangDingAccountViewController *ovc = [[OtherLoginBangDingAccountViewController alloc] init];
//                    ovc.strname = [NSString nullToString:[dicll objectForKey:nickname]];
                    ovc.strname = [NSString nullToString:[dicdata objectForKey:@"nickname"]];
                    ovc.strtype = @"淘宝";
                    ovc.dicparams = dicpush;
                    ovc.strpushurl = strurl;
                    [self.navigationController pushViewController:ovc animated:YES];
                }
                else
                {///不需要绑定
                    [self otherLogindValue:dicpush  andurl:strurl];
                    
                }
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
    /*
    [HTTPManager sendRequestUrlToService:strurl withParametersDictionry:nil view:self.view.window completeHandle:^(NSURLSessionTask *opration, id responceObjct, NSError *error) {
        if (responceObjct) {
            NSString* hexString = [[NSString alloc]initWithData:responceObjct encoding:NSUTF8StringEncoding];
            NSDictionary* dictResult = (NSDictionary*)[hexString JSONValue];
            if ([[dictResult objectForKey:@"status"] intValue] == 1) {
                [MobClick event:@"wode_denglu"];
                [[MDB_UserDefault defaultInstance] setUserWithDic:[dictResult objectForKey:@"user"] token:[dictResult objectForKey:@"data"]];
                [MDB_UserDefault setThirdPartyLoginSuccess:YES];
                _isQQload=NO;
                [MDB_UserDefault showNotifyHUDwithtext:@"登录成功" inView:[[UIApplication sharedApplication].windows firstObject]];
                NSString *telphone = [[dictResult objectForKey:@"user"] objectForKey:@"telphone"];
                [self backToWithtelphone:telphone];
                //                [self.navigationController popViewControllerAnimated:YES];
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
                
            }
            
        }else{
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                                message:@"网络连接超时"
                                                               delegate:nil
                                                      cancelButtonTitle:@"确定"
                                                      otherButtonTitles:nil, nil];
            
            [alertView show];
        }
    }];
    */
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

-(void)doClickBackAction;
{
    [MDB_UserDefault setIsUserInfoLogin:NO];
    if (_LoginViewDidConfi) {
        _LoginViewDidConfi();
    }

    NSArray *arrvcs = self.navigationController.viewControllers;
    for(UIViewController *vc in arrvcs)
    {
        if([vc isKindOfClass:[ResetPasswordViewController class]])
        {
            [self.navigationController popToRootViewControllerAnimated:YES];
            return;
        }
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)backToWithtelphone: (NSString *)telphone{
    [MDB_UserDefault setIsUserInfoLogin:NO];
    if (_LoginViewDidConfi) {
        _LoginViewDidConfi();
    }
//    if (telphone.length == 11) {
    
        NSArray *arrvcs = self.navigationController.viewControllers;
        for(UIViewController *vc in arrvcs)
        {
            if([vc isKindOfClass:[ResetPasswordViewController class]])
            {
                [self.navigationController popToRootViewControllerAnimated:YES];
                return;
            }
        }
        
        [self.navigationController popViewControllerAnimated:YES];
//    }else{
//        BindingUserInfoViewController *bindingVc = [[BindingUserInfoViewController alloc] init];
//        [self.navigationController pushViewController:bindingVc animated:YES];
//    }
}

#pragma mark - UIAlertViewDelegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex==1){
        NSString* url = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"mailAddressReg"]];//返利跳转链接
        SVModalWebViewController  *svweb=[[SVModalWebViewController alloc] initWithAddress:url];
        svweb.modalTransitionStyle=UIModalTransitionStyleCrossDissolve;
        
        [self presentViewController:svweb animated:YES completion:^{
            
        }];
    }
}

#pragma mark - LoginSubjectViewDelegate
- (void)loginSubjectViewDidPressForgetBtn{
    RetrievePasswordViewController *retrievePassVc = [[RetrievePasswordViewController alloc] init];
    [self.navigationController pushViewController:retrievePassVc animated:YES];
}

- (void)loginSubjectView:(LoginSubjectView *)subView didPressLoginBtnWithUserName:(NSString *)userName andPassword:(NSString *)password{
    
    NSDictionary *dictic=@{@"username":userName,@"password":password};
    
    [HTTPManager sendRequestUrlToService:URL_login withParametersDictionry:dictic view:self.view completeHandle:^(NSURLSessionTask *opration, id responceObjct, NSError *error) {
        if(responceObjct){
            NSString *str=[[NSString alloc]initWithData:responceObjct encoding:NSUTF8StringEncoding];
            NSDictionary *dictResult=[str JSONValue];
            if ([[dictResult objectForKey:@"status"] intValue]==1) {
                [MobClick event:@"wode_denglu"];
                [[MDB_UserDefault defaultInstance] setUserWithDic:[dictResult objectForKey:@"user"] token:[dictResult objectForKey:@"data"]];
                [MDB_UserDefault showNotifyHUDwithtext:@"登录成功" inView:[UIApplication sharedApplication].keyWindow];
                NSString *telphone = [[dictResult objectForKey:@"user"] objectForKey:@"telphone"];
//                [self doClickBackAction];
                [self backToWithtelphone:telphone];
                [self setHttpToken];
            }else if ([[dictResult objectForKey:@"status"] intValue]==2&&[[NSString stringWithFormat:@"%@",[dictResult objectForKey:@"info"]] hasPrefix:@"账号未激活"]) {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                                    message:[NSString stringWithFormat:@"%@",[dictResult objectForKey:@"info"]]
                                                                   delegate:self
                                                          cancelButtonTitle:@"取消"
                                                          otherButtonTitles:@"去验证邮箱",nil];
                [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%@",[dictResult objectForKey:@"data"]] forKey:@"mailAddressReg"];
                [alertView show];
            }else{
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                                    message:[NSString nullToString:dictResult[@"info"]]
                                                                   delegate:nil
                                                          cancelButtonTitle:@"确定"
                                                          otherButtonTitles:nil, nil];
                [alertView show];
                
            }
            
        }else{
            
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                                message:@"网络连接超时"
                                                               delegate:nil
                                                      cancelButtonTitle:@"确定"
                                                      otherButtonTitles:nil, nil];
            [alertView show];
        }
    }];

}


- (void)loginSubjectView:(LoginSubjectView *)subView didPressTriplicitiesLoginWithType:(LoginType)type{
    
//    OtherLoginAlterView *oview = [[OtherLoginAlterView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height)];
//    [self.view addSubview:oview];
//    
//    return;
    
    if (_isQQload) {
        SSDKPlatformType platformType ;
        if (type == LoginTypeQQ) {
            platformType = SSDKPlatformTypeQQ;
        }else if (type == LoginTypeWeiBo){
            platformType = SSDKPlatformTypeSinaWeibo;
        }else if (type == LoginTypeWx){
            platformType = SSDKPlatformTypeWechat;
        }else if (type == LoginTypeTaoBao){
            platformType = SSDKPlatformTypeAny;
        }else{
            return;
        }
        if(platformType == SSDKPlatformTypeAny)
        {///淘宝登录
            
            TaoBaoWebViewViewController *tvc = [[TaoBaoWebViewViewController alloc] init];
            [tvc setDeletate:self];
            [self.navigationController pushViewController:tvc animated:YES];
            
            
//             ALBBSDK *albbSDK = [ALBBSDK sharedInstance];
//            [albbSDK setAppkey:taobao_app_key];
//            [albbSDK setAuthOption:H5Only];
//
//            [albbSDK auth:self successCallback:^(ALBBSession *session){
//
//                ALBBUser *user = [session getUser];
//                NSLog(@"session == %@, user.nick == %@,user.avatarUrl == %@,user.openId == %@,user.openSid == %@,user.topAccessToken == %@",session,user.nick,user.avatarUrl,user.openId,user.openSid,user.topAccessToken);
//
//
//                if(user.openId.length>0)
//                {
//                    [self doAuthLoginWithUser:user type:platformType];
//                }
//                else
//                {
//                    [MDB_UserDefault showNotifyHUDwithtext:@"授权失败" inView:self.view];
//                }
//
//            } failureCallback:^(ALBBSession *session,NSError *error){
//                [MDB_UserDefault showNotifyHUDwithtext:@"授权失败" inView:self.view];
//            }];
            
        }
        else
        {
            [SSEThirdPartyLoginHelper loginByPlatform:platformType
                                           onUserSync:^(SSDKUser *user, SSEUserAssociateHandler associateHandler) {
                                               associateHandler(user.uid, user, user);
                                               if (user.credential) {
                                                   [self doAuthLoginWithUser:user type:platformType];
                                               }else{
                                                   [MDB_UserDefault showNotifyHUDwithtext:@"授权失败" inView:self.view];
                                               }
                                           }
                                        onLoginResult:^(SSDKResponseState state, SSEBaseUser *user, NSError *error) {
                                            
                                            if (state == SSDKResponseStateFail)
                                            {
                                                [SSEThirdPartyLoginHelper logout:user];
                                                [MDB_UserDefault showNotifyHUDwithtext:@"授权失败" inView:self.view];
                                            }
                                            
                                        }];
        }
        
        
    }
   }


-(void)loginCodeAction:(LoginSubjectView *)subView phone:(NSString *)strphone
{
    
    if(dataController== nil)
    {
        dataController = [[RegCodeDataController alloc] init];
    }
    
    
    [dataController requestGetCodeWithMobilNumber:strphone regType:RegCodeTypeLogin InView:subView callback:^(NSError *error, BOOL state, NSString *describle) {
        if(state)
        {
            [subView timing];
        }
        else
        {
            [MDB_UserDefault showNotifyHUDwithtext:describle inView:subView];
        }
        
    }];
}

///验证码登录
- (void)loginFastSubjectView:(LoginSubjectView *)subView
   didPressLoginBtnWithPhone:(NSString *)Phone
                     andcode:(NSString *)code
{
    
    NSMutableDictionary *dicll = [NSMutableDictionary new];
    [dicll setObject:Phone forKey:@"phone"];
    [dicll setObject:code forKey:@"code"];
    [dicll setObject:@"1" forKey:@"devicetype"];
    
    [HTTPManager sendRequestUrlToService:URL_mobileFastLogin withParametersDictionry:dicll view:self.view completeHandle:^(NSURLSessionTask *opration, id responceObjct, NSError *error) {
        if (responceObjct) {
            NSString* hexString = [[NSString alloc]initWithData:responceObjct encoding:NSUTF8StringEncoding];
            NSDictionary* dictResult = (NSDictionary*)[hexString JSONValue];
            if ([[dictResult objectForKey:@"status"] intValue] == 1) {
                [MobClick event:@"wode_denglu"];
                [[MDB_UserDefault defaultInstance] setUserWithDic:[dictResult objectForKey:@"user"] token:[dictResult objectForKey:@"data"]];
                [MDB_UserDefault showNotifyHUDwithtext:@"登录成功" inView:[UIApplication sharedApplication].keyWindow];
                NSString *telphone = [[dictResult objectForKey:@"user"] objectForKey:@"telphone"];
                [self backToWithtelphone:telphone];
            }
            else {
                [[MDB_UserDefault defaultInstance]setUserNil];
                NSString* message = @"登录失败";
                if([[NSString nullToString:[dictResult objectForKey:@"info"]] length]>0)
                {
                    message = [NSString nullToString:[dictResult objectForKey:@"info"]];
                }
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
                
            }
            
        }else{
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                                message:@"网络连接超时"
                                                               delegate:nil
                                                      cancelButtonTitle:@"确定"
                                                      otherButtonTitles:nil, nil];
            
            [alertView show];
        }
    }];
}

////获取URL的指定参数对应值

-(NSString *)paramValueOfUrl:(NSString *) url withParam:(NSString *) param{
    
    NSError *error;
    NSString *regTags=[[NSString alloc] initWithFormat:@"(^|&|\\?)+%@=+([^&]*)(&|$)",param];
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regTags
                                                                           options:NSRegularExpressionCaseInsensitive
                                                                             error:&error];
    
    // 执行匹配的过程
    NSArray *matches = [regex matchesInString:url
                                      options:0
                                        range:NSMakeRange(0, [url length])];
    for (NSTextCheckingResult *match in matches) {
        NSString *tagValue = [url substringWithRange:[match rangeAtIndex:2]];  // 分组2所对应的串
        return tagValue;
    }
    return nil;
}

@end
