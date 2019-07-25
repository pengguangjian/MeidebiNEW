//
//  SocialBoundDataController.m
//  Meidebi
//
//  Created by mdb-admin on 2017/6/29.
//  Copyright © 2017年 meidebi. All rights reserved.
//

#import "SocialBoundDataController.h"
#import "MDB_UserDefault.h"
#import "HTTPManager.h"
@implementation SocialBoundDataController

// 绑定QQ
- (void)requestBoundQQWithInView:(UIView *)view
                           token:(NSString *)token
                          openid:(NSString *)openid
                        nickname:(NSString *)nickname
                       expiresIn:(NSString *)expiresIn
                        callback:(completeCallback)callback{
    NSDictionary *parameters = @{@"userkey":[NSString nullToString:[MDB_UserDefault defaultInstance].usertoken],
                                 @"access_token":[NSString nullToString:token],
                                 @"openid":[NSString nullToString:openid],
                                 @"nickname":[NSString nullToString:nickname],
                                 @"expires_in":[NSString nullToString:expiresIn]};
    [HTTPManager sendRequestUrlToService:URL_BoundQQ withParametersDictionry:parameters view:view completeHandle:^(NSURLSessionTask *opration, id responceObjct, NSError *error) {
        BOOL state = NO;
        NSString *describle = @"";
        if (responceObjct) {
            NSString *str=[[NSString alloc]initWithData:responceObjct encoding:NSUTF8StringEncoding];
            NSDictionary *dictResult=[str JSONValue];
            NSString* info = [NSString stringWithFormat:@"%d",[[dictResult objectForKey:@"status"] intValue]];
            if ([info isEqualToString:@"1"]) {
                _resultDict = dictResult[@"data"];
                state = YES;
            }else{
                describle = dictResult[@"info"];
            }
        }
        callback(error,state,describle);
    }];

}

// 绑定sina
- (void)requestBoundSinaWithInView:(UIView *)view
                             token:(NSString *)token
                               uid:(NSString *)uid
                          nickname:(NSString *)nickname
                         expiresIn:(NSString *)expiresIn
                          callback:(completeCallback)callback{
    NSDictionary *parameters = @{@"userkey":[NSString nullToString:[MDB_UserDefault defaultInstance].usertoken],
                                 @"access_token":[NSString nullToString:token],
                                 @"uid":[NSString nullToString:uid],
                                 @"nickname":[NSString nullToString:nickname],
                                 @"expires_in":[NSString nullToString:expiresIn]};
    [HTTPManager sendRequestUrlToService:URL_BoundSina withParametersDictionry:parameters view:view completeHandle:^(NSURLSessionTask *opration, id responceObjct, NSError *error) {
        BOOL state = NO;
        NSString *describle = @"";
        if (responceObjct) {
            NSString *str=[[NSString alloc]initWithData:responceObjct encoding:NSUTF8StringEncoding];
            NSDictionary *dictResult=[str JSONValue];
            NSString* info = [NSString stringWithFormat:@"%d",[[dictResult objectForKey:@"status"] intValue]];
            if ([info isEqualToString:@"1"]) {
                _resultDict = dictResult[@"data"];
                state = YES;
            }else{
                describle = dictResult[@"info"];
            }
        }
        callback(error,state,describle);
    }];

}

// 绑定列表
- (void)requestBoundListWithInView:(UIView *)view
                          callback:(completeCallback)callback{
    NSDictionary *parameters = @{@"userkey":[NSString nullToString:[MDB_UserDefault defaultInstance].usertoken]};
    [HTTPManager sendRequestUrlToService:URL_BoundList withParametersDictionry:parameters view:view completeHandle:^(NSURLSessionTask *opration, id responceObjct, NSError *error) {
        BOOL state = NO;
        NSString *describle = @"";
        if (responceObjct) {
            NSString *str=[[NSString alloc]initWithData:responceObjct encoding:NSUTF8StringEncoding];
            NSDictionary *dictResult=[str JSONValue];
            NSString* info = [NSString stringWithFormat:@"%d",[[dictResult objectForKey:@"status"] intValue]];
            if ([info isEqualToString:@"1"]) {
                _resultDict = dictResult[@"data"];
                state = YES;
            }else{
                describle = dictResult[@"info"];
            }
        }
        callback(error,state,describle);
    }];

}

// 解绑
- (void)requestRelieveBoundWithInView:(UIView *)view
                                 type:(NSString *)type
                             callback:(completeCallback)callback{
    NSDictionary *parameters = @{@"userkey":[NSString nullToString:[MDB_UserDefault defaultInstance].usertoken],
                                 @"type":[NSString nullToString:type]};
    [HTTPManager sendRequestUrlToService:URL_BoundRelieve withParametersDictionry:parameters view:view completeHandle:^(NSURLSessionTask *opration, id responceObjct, NSError *error) {
        BOOL state = NO;
        NSString *describle = @"";
        if (responceObjct) {
            NSString *str=[[NSString alloc]initWithData:responceObjct encoding:NSUTF8StringEncoding];
            NSDictionary *dictResult=[str JSONValue];
            NSString* info = [NSString stringWithFormat:@"%d",[[dictResult objectForKey:@"status"] intValue]];
            if ([info isEqualToString:@"1"]) {
                _resultDict = dictResult[@"data"];
                state = YES;
            }else{
                describle = dictResult[@"info"];
            }
        }
        callback(error,state,describle);
    }];

}

@end
