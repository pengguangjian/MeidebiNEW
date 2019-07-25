//
//  BangDingSheJiaoAccountViewController.m
//  Meidebi
//绑定社交账号
//  Created by mdb-losaic on 2019/3/4.
//  Copyright © 2019年 meidebi. All rights reserved.
//

#import "BangDingSheJiaoAccountViewController.h"
#import "BangDingAccountModel.h"

#import "BangDingAccountTableViewCell.h"
#import "TaoBaoWebViewViewController.h"
#import <ShareSDKExtension/SSEThirdPartyLoginHelper.h>

#import "MDB_UserDefault.h"

#import <AlibabaAuthSDK/ALBBSDK.h>

#import "HTTPManager.h"

#import "TaoBaoBangdingViewController.h"

typedef NS_ENUM(NSInteger, BaingDingType) {
    LoginTypeWeiBo=0,
    LoginTypeQQ = 1,
    LoginTypeWx = 2,
    LoginTypeTaoBao = 3
};

@interface BangDingSheJiaoAccountViewController ()<UITableViewDelegate,UITableViewDataSource,TaoBaoBangdingViewControllerDelegate,UIAlertViewDelegate>
{
    UITableView *tabview;
    
    NSMutableArray *arrdata;
    
    BangDingAccountModel *nowselectmodel;
    
}
@end

@implementation BangDingSheJiaoAccountViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"绑定社交账号";
    
    NSArray *arrname = @[@"新浪微博",@"腾讯QQ",@"微信",@"淘宝"];
    NSArray *arrimage = @[@"bangdingweibo.png",@"bangdingqq.png",@"bangdingweixin.png",@"bangdingtaobao.png"];
    NSArray *arrtype = @[@"2",@"1",@"4",@"3"];
    arrdata = [NSMutableArray new];
    for(int i = 0 ; i < 4; i++)
    {
        BangDingAccountModel *model = [BangDingAccountModel new];
        model.strtitle = arrname[i];
        model.isbangding = NO;
        model.strimage = arrimage[i];
        model.strname = @"未绑定";
        model.type = [arrtype[i] intValue];
        [arrdata addObject:model];
        
    }
    
    UITableView *tableV = [[UITableView alloc] init];
    tableV.bounces= NO;
    [self.view addSubview: tableV];
    [tableV mas_makeConstraints:^(MASConstraintMaker *make) {
        if (@available(iOS 11.0, *)) {
            make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop);
            make.left.equalTo(self.view.mas_safeAreaLayoutGuideLeft);
            make.right.equalTo(self.view.mas_safeAreaLayoutGuideRight);
            make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom);
        }else{
            make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(kTopHeight, 0, 0, 0));
        }
    }];
    tabview = tableV;
    
    tableV.delegate = self;
    tableV.dataSource = self;
    tableV.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self getdata];
}

///获取绑定状态
-(void)getdata
{
    NSDictionary *dicll = @{@"userkey":[NSString nullToString:[MDB_UserDefault defaultInstance].usertoken]};
    [HTTPManager sendGETRequestUrlToService:url_bangding_status withParametersDictionry:dicll view:self.view completeHandle:^(NSURLSessionTask *opration, id responceObjct, NSError *error) {
        if(responceObjct)
        {
            NSString* hexString = [[NSString alloc]initWithData:responceObjct encoding:NSUTF8StringEncoding];
            NSDictionary* dictResult = (NSDictionary*)[hexString JSONValue];
            if ([[dictResult objectForKey:@"status"] intValue] == 1)
            {
                if([[dictResult objectForKey:@"data"] isKindOfClass:[NSDictionary class]])
                {
                    NSDictionary *dicdata = [dictResult objectForKey:@"data"];
                    NSArray *arrallkey = [dicdata allKeys];
                    for(int i = 0 ; i < arrallkey.count; i++)
                    {
                        NSString *strkey = [NSString nullToString:arrallkey[i]];
                        NSString *strname = [NSString nullToString:[dicdata objectForKey:strkey]];
                        if(strname.length<1)
                        {
                            strname = @"已绑定";
                        }
                        if(strkey.intValue>4)
                        {
                            continue;
                        }
                        for(BangDingAccountModel *model in arrdata)
                        {
                            if(model.type == strkey.intValue)
                            {
                                model.isbangding = YES;
                                model.strname = strname;
                                break;
                            }
                        }
                        
                    }
                    [tabview reloadData];
                    
                }
            }
            else
            {
                [MDB_UserDefault showNotifyHUDwithtext:[NSString nullToString:[dictResult objectForKey:@"info"]] inView:self.view];
            }
        }
        else
        {
            [MDB_UserDefault showNotifyHUDwithtext:@"加载失败" inView:self.view];
        }
    }];
}

-(void)bangdingtype:(BaingDingType)type
{
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
        
        TaoBaoBangdingViewController *tvc = [[TaoBaoBangdingViewController alloc] init];
        [tvc setDeletate:self];
        [self.navigationController pushViewController:tvc animated:YES];
        
    }
    else
    {
        [SSEThirdPartyLoginHelper loginByPlatform:platformType
                                       onUserSync:^(SSDKUser *user, SSEUserAssociateHandler associateHandler) {
                                           associateHandler(user.uid, user, user);
                                           if (user.credential) {
                                               [self doBangDingUser:user type:platformType];
                                               
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


-(void)doBangDingUser:(id)uservalue type:(SSDKPlatformType)typet
{
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
    NSString * userkey = @"userkey";
    NSString *stl=[user.credential token]?[user.credential token]:@"tongx";
    NSDictionary *dicll= nil;
    if (typet==SSDKPlatformTypeQQ) {
        url = url_bangding_QQ;
        reqkey=@"openid";
        token=@"access_token";
        nickname=@"qqnickname";
        
        dicll = @{reqkey:[NSString nullToString:user.uid],nickname:[NSString nullToString:user.nickname],token:stl,userkey:[NSString nullToString:[MDB_UserDefault defaultInstance].usertoken]};
    }else if (typet==SSDKPlatformTypeSinaWeibo) {
        url=url_bangding_WeiBo;
        reqkey=@"uid";
        nickname=@"weibo_nickname";
        token=@"weibo_access_token";
        dicll = @{reqkey:[NSString nullToString:user.uid],nickname:[NSString nullToString:user.nickname],token:stl,userkey:[NSString nullToString:[MDB_UserDefault defaultInstance].usertoken]};
    }else if (typet == SSDKPlatformTypeWechat){
        url=url_bangding_Weixin;
        NSDictionary *credentialDict = user.credential.rawData;
        NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:user.rawData];
        [dict addEntriesFromDictionary:credentialDict];
        nickname = @"nickname";
        dicll = @{
                  @"unionid":[NSString nullToString:dict[@"unionid"]],
                  @"access_token":[NSString nullToString:dict[@"access_token"]],
                  @"avatar":[NSString nullToString:dict[@"headimgurl"]],
                  @"nickname":[NSString nullToString:dict[@"nickname"]],
                  @"openid":[NSString nullToString:dict[@"openid"]],
                  userkey:[NSString nullToString:[MDB_UserDefault defaultInstance].usertoken]
                  };
    }else{
        
        [MDB_UserDefault showNotifyHUDwithtext:@"登录失败" inView:[[UIApplication sharedApplication].windows firstObject]];
        
        return;
    }
    
    [HTTPManager sendRequestUrlToService:url withParametersDictionry:dicll view:self.view completeHandle:^(NSURLSessionTask *opration, id responceObjct, NSError *error) {

        if(responceObjct)
        {
            NSString* hexString = [[NSString alloc]initWithData:responceObjct encoding:NSUTF8StringEncoding];
            NSDictionary* dictResult = (NSDictionary*)[hexString JSONValue];
            if ([[dictResult objectForKey:@"status"] intValue] == 1)
            {
                nowselectmodel.isbangding = YES;
                nowselectmodel.strname = [NSString nullToString:[dicll objectForKey:nickname]];
                if(nowselectmodel.strname.length<1)
                {
                    nowselectmodel.strname = @"已绑定";
                }
                [tabview reloadData];
            }
            else
            {
                [MDB_UserDefault showNotifyHUDwithtext:[NSString nullToString:[dictResult objectForKey:@"info"]] inView:self.view];
            }
        }
        else
        {
            [MDB_UserDefault showNotifyHUDwithtext:@"绑定失败" inView:self.view];
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
- (void)taobaobangdingBackUrl:(NSString *)strurl
{
    NSDictionary *dicll = @{@"userkey":[NSString nullToString:[MDB_UserDefault defaultInstance].usertoken],@"code":[NSString nullToString:[self paramValueOfUrl:strurl withParam:@"code"]],@"state":[NSString nullToString:[self paramValueOfUrl:strurl withParam:@"state"]]};
    
    
    NSString *url = [NSString stringWithFormat:@"%@V2-Oauth-tbWebAuthCallback",URL_HR];
    [HTTPManager sendRequestUrlToService:url withParametersDictionry:dicll view:self.view completeHandle:^(NSURLSessionTask *opration, id responceObjct, NSError *error) {
        if(responceObjct)
        {
            NSString* hexString = [[NSString alloc]initWithData:responceObjct encoding:NSUTF8StringEncoding];
            NSDictionary* dictResult = (NSDictionary*)[hexString JSONValue];
            if ([[dictResult objectForKey:@"status"] intValue] == 1)
            {
                nowselectmodel.isbangding = YES;
                NSString *strtemp = [NSString nullToString:[dictResult objectForKey:@"data"]];
                if(strtemp.length<1)
                {
                    strtemp = @"已绑定";
                }
                nowselectmodel.strname = strtemp;
                [tabview reloadData];
            }
            else
            {
                [MDB_UserDefault showNotifyHUDwithtext:[NSString nullToString:[dictResult objectForKey:@"info"]] inView:self.view];
            }
        }
        else
        {
            [MDB_UserDefault showNotifyHUDwithtext:@"绑定失败" inView:self.view];
        }
            
    }];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return arrdata.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *strcell = @"BangDingAccountTableViewCell";
    BangDingAccountTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:strcell];
    if(!cell)
    {
        cell = [[BangDingAccountTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:strcell];
    }
    cell.model = arrdata[indexPath.row];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 65;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    BangDingAccountModel *model = arrdata[indexPath.row];
    nowselectmodel = model;
    if(model.isbangding)
    {///解绑
        UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"提示" message:@"是否解除绑定" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alter show];
    }
    else
    {///绑定
        [self bangdingtype:indexPath.row];   
    }
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 1)
    {
        NSDictionary *dicll = @{@"userkey":[NSString nullToString:[MDB_UserDefault defaultInstance].usertoken],@"type":[NSString stringWithFormat:@"%d",nowselectmodel.type]};
        [HTTPManager sendRequestUrlToService:url_bangding_unBind withParametersDictionry:dicll view:self.view completeHandle:^(NSURLSessionTask *opration, id responceObjct, NSError *error) {
            
            if(responceObjct)
            {
                NSString* hexString = [[NSString alloc]initWithData:responceObjct encoding:NSUTF8StringEncoding];
                NSDictionary* dictResult = (NSDictionary*)[hexString JSONValue];
                if ([[dictResult objectForKey:@"status"] intValue] == 1)
                {
                    nowselectmodel.isbangding = NO;
                    nowselectmodel.strname = @"未绑定";
                    [tabview reloadData];
                }
                else
                {
                    [MDB_UserDefault showNotifyHUDwithtext:[NSString nullToString:[dictResult objectForKey:@"info"]] inView:self.view];
                }
            }
            else
            {
                [MDB_UserDefault showNotifyHUDwithtext:@"解除绑定失败" inView:self.view];
            }
        }];
        
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
