//
//  RegCodeDataController.m
//  Meidebi
//
//  Created by mdb-admin on 16/7/13.
//  Copyright © 2016年 meidebi. All rights reserved.
//

#import "RegCodeDataController.h"
#import "HTTPManager.h"
#import "MDB_UserDefault.h"
#import <FCUUID/FCUUID.h>

@interface RegCodeDataController ()

@property (nonatomic, strong) NSString *resultMessage;
@property (nonatomic, strong) NSString *vid;

@end

@implementation RegCodeDataController

- (void)requestGetCodeWithMobilNumber:(NSString *)mobileNumber
                              regType:(RegCodeType)type
                               InView:(UIView *)view
                             callback:(completeCallback)Callback{
    NSString *typeStr = @"";
    if (type == RegCodeTypeNomal) {
        typeStr = @"1";
    }else if (type == RegCodeTypeBinding){
        typeStr = @"2";
    }else if (type == RegCodeTypeRetrieve){
        typeStr = @"3";
    }else if (type == RegCodeTypeLogin){
        typeStr = @"5";
    }
    
//    NSString *sign = [NSString stringWithFormat:@"%@%@",[NSString nullToString:mobileNumber],[FCUUID uuidForDevice]];
    NSString *appVersion =[[MDB_UserDefault defaultInstance] applicationVersion];
    NSString *sign = [NSString stringWithFormat:@"mdb%@%@",appVersion,[NSString nullToString:mobileNumber]];
    sign = [[sign md532BitUpper] md532BitUpper];
    NSDictionary *parameters = @{@"phone":[NSString nullToString:mobileNumber],
                                 @"userkey":[NSString nullToString:[MDB_UserDefault defaultInstance].usertoken],
                                 @"uniquetoken":[FCUUID uuidForDevice],
                                 @"type":typeStr,
                                 @"sign":[NSString nullToString:sign]};
    [HTTPManager sendRequestUrlToService:URL_sendverify withParametersDictionry:parameters view:view completeHandle:^(NSURLSessionTask *opration, id responceObjct, NSError *error) {
        BOOL state = NO;
        if (responceObjct==nil) {
            _resultMessage = @"网络错误";
        }else{
            NSString *str=[[NSString alloc]initWithData:responceObjct encoding:NSUTF8StringEncoding];
            NSDictionary *dicAll=[str JSONValue];
            if ([[NSString nullToString:dicAll[@"status"]] intValue] == 1) {
                state = YES;
                _resultMessage = @"";
            }else{
                _resultMessage = [NSString nullToString:dicAll[@"info"]];
            }
        }
        Callback(error,state,_resultMessage);
    }];
    
    
}


- (void)requestVerificationCodeWithMobilNumber:(NSString *)mobileNumber
                                          code:(NSString *)code
                                          type:(NSString *)type
                                        InView:(UIView *)view
                                      callback:(completeCallback)Callback{
        NSDictionary *parameters = [NSDictionary dictionary];
        parameters = @{@"phone":[NSString nullToString:mobileNumber],
                       @"userkey":[NSString nullToString:[MDB_UserDefault defaultInstance].usertoken],
                       @"code":code,
                       @"type":type,
                       @"uniquetoken":[FCUUID uuidForDevice]};
    
    
    
       [HTTPManager sendRequestUrlToService:URL_doverify withParametersDictionry:parameters view:view completeHandle:^(NSURLSessionTask *opration, id responceObjct, NSError *error) {
        BOOL state = NO;
        if (responceObjct==nil) {
            _resultMessage = @"网络错误";
        }else{
            NSString *str=[[NSString alloc]initWithData:responceObjct encoding:NSUTF8StringEncoding];
            NSDictionary *dicAll=[str JSONValue];
            if ([[NSString nullToString:dicAll[@"status"]] intValue] == 1) {
                _resultMessage = @"";
                _vid = [NSString stringWithFormat:@"%@",[NSString nullToString:dicAll[@"data"]]];
                state = YES;
            }else{
                _resultMessage = [NSString nullToString:dicAll[@"info"]];
            }
        }
        Callback(error,state,_resultMessage);
    }];
}



- (void)requestRegUserInfoWithData:(NSDictionary *)dataDict
                               vid:(NSString *)vid
                            InView:(UIView *)view
                        withInvite:(NSString *)invite
                          callback:(regCompleteCallback)Callback{
    
    __block BOOL statue;
    __block NSString *mailAddress = @"";
    NSMutableDictionary *tempDict = [NSMutableDictionary dictionaryWithDictionary:dataDict];
    [tempDict setObject:[NSString nullToString:vid] forKey:@"vid"];
    if (invite.length > 0) {
        [tempDict setObject:[NSString nullToString:invite] forKey:@"invitation_code"];
    }
    NSDictionary *parameters = [tempDict mutableCopy];
    
    [HTTPManager sendRequestUrlToService:URL_mobilereg withParametersDictionry:parameters view:view completeHandle:^(NSURLSessionTask *opration, id responceObjct, NSError *error) {
        if (responceObjct==nil) {
            _resultMessage = @"网络错误";
            statue = NO;
        }else{
            NSString *str=[[NSString alloc]initWithData:responceObjct encoding:NSUTF8StringEncoding];
            NSDictionary *dicAll=[str JSONValue];
            if ([[NSString nullToString:dicAll[@"status"]] intValue] == 1) {
                _resultMessage = [NSString stringWithFormat:@"%@",[dicAll objectForKey:@"info"]];
                statue = YES;
            }else if([@"USERNAME_EXIST" isEqualToString:[NSString stringWithFormat:@"%@",[dicAll objectForKey:@"info"]]]){
                _resultMessage = @"帐号已存在！";
                statue = NO;
            }else if([[NSString stringWithFormat:@"%@",[dicAll objectForKey:@"info"]] hasPrefix:@"账号创建成功"]&&[[NSString stringWithFormat:@"%@",[dicAll objectForKey:@"data"]] hasPrefix:@"http"]){
                _resultMessage = @"账号创建成功";
                mailAddress = [NSString stringWithFormat:@"%@",[dicAll objectForKey:@"data"]];
                statue = YES;
            }else{
                _resultMessage = [NSString stringWithFormat:@"%@",[dicAll objectForKey:@"info"]];
                statue = NO;
            }
            
        }
        Callback(error,statue,mailAddress);
    }];
    
    
}

////新版注册
- (void)requestNewRegUserInfoWithData:(NSDictionary *)dataDict
                               InView:(UIView *)view
                             callback:(regCompleteCallback)Callback
{
    
    __block BOOL statue;
    __block NSString *mailAddress = @"";
    [HTTPManager sendRequestUrlToService:URL_mobileregV2 withParametersDictionry:dataDict view:view completeHandle:^(NSURLSessionTask *opration, id responceObjct, NSError *error) {
        if (responceObjct==nil) {
            _resultMessage = @"网络错误";
            statue = NO;
        }else{
            NSString *str=[[NSString alloc]initWithData:responceObjct encoding:NSUTF8StringEncoding];
            NSDictionary *dicAll=[str JSONValue];
            if ([[NSString nullToString:dicAll[@"status"]] intValue] == 1) {
                _resultMessage = [NSString stringWithFormat:@"%@",[dicAll objectForKey:@"info"]];
                statue = YES;
            }else if([@"USERNAME_EXIST" isEqualToString:[NSString stringWithFormat:@"%@",[dicAll objectForKey:@"info"]]]){
                _resultMessage = @"帐号已存在！";
                statue = NO;
            }else if([[NSString stringWithFormat:@"%@",[dicAll objectForKey:@"info"]] hasPrefix:@"账号创建成功"]&&[[NSString stringWithFormat:@"%@",[dicAll objectForKey:@"data"]] hasPrefix:@"http"]){
                _resultMessage = @"账号创建成功";
                mailAddress = [NSString stringWithFormat:@"%@",[dicAll objectForKey:@"data"]];
                statue = YES;
            }else{
                _resultMessage = [NSString stringWithFormat:@"%@",[dicAll objectForKey:@"info"]];
                statue = NO;
            }
            
        }
        Callback(error,statue,mailAddress);
    }];
}


///判断用户密码是否存在
- (void)requestisPwdInView:(UIView *)view
                  callback:(completeCallback)Callback
{
    NSDictionary *parameters = [NSDictionary dictionary];
    parameters = @{@"userkey":[NSString nullToString:[MDB_UserDefault defaultInstance].usertoken]};
    
    [HTTPManager sendRequestUrlToService:URL_isPwd withParametersDictionry:parameters view:view completeHandle:^(NSURLSessionTask *opration, id responceObjct, NSError *error) {
        BOOL state = NO;
        if (responceObjct==nil) {
            _resultMessage = @"网络错误";
        }else{
            NSString *str=[[NSString alloc]initWithData:responceObjct encoding:NSUTF8StringEncoding];
            NSDictionary *dicAll=[str JSONValue];
            if ([[NSString nullToString:dicAll[@"status"]] intValue] == 1) {
                _resultMessage = @"";
                NSDictionary *dicpas = [dicAll objectForKey:@""];
                _strpass = [NSString nullToString:[dicpas objectForKey:@"password"]];
                state = YES;
            }else{
                _resultMessage = [NSString nullToString:dicAll[@"info"]];
            }
        }
        Callback(error,state,_resultMessage);
    }];
    
}

///添加空置密码
- (void)requestAddPwdWithData:(NSDictionary *)dataDict
                       InView:(UIView *)view
                     callback:(completeCallback)Callback
{
    
    [HTTPManager sendRequestUrlToService:URL_AddPwd withParametersDictionry:dataDict view:view completeHandle:^(NSURLSessionTask *opration, id responceObjct, NSError *error) {
        BOOL state = NO;
        if (responceObjct==nil) {
            _resultMessage = @"网络错误";
        }else{
            NSString *str=[[NSString alloc]initWithData:responceObjct encoding:NSUTF8StringEncoding];
            NSDictionary *dicAll=[str JSONValue];
            if ([[NSString nullToString:dicAll[@"status"]] intValue] == 1) {
                _resultMessage = @"";
                
                state = YES;
            }else{
                _resultMessage = [NSString nullToString:dicAll[@"info"]];
            }
        }
        Callback(error,state,_resultMessage);
    }];
    
}




@end
