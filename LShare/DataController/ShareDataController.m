//
//  ShareDataController.m
//  Meidebi
//
//  Created by losaic on 16/8/2.
//  Copyright © 2016年 meidebi. All rights reserved.
//

#import "ShareDataController.h"
#import "HTTPManager.h"
#import "MDB_ShareExstensionUserDefault.h"
#import "NSString+extend.h"
#import "Constants.h"
#import <FCUUID/FCUUID.h>
@interface ShareDataController ()

@property (nonatomic, strong) NSDictionary *requestBrokeInfoResults;
@property (nonatomic, strong) NSString *resultMessage;
@property (nonatomic, strong) NSArray *requestCateResults;

@end

@implementation ShareDataController


//获取爆料URL的商品信息
- (void)requestGetShareInfoDataWithLink:(NSString *)link
                                 InView:(UIView *)view
                               callback:(completionCallback)Callback{
    
    if ([[NSString nullToString:[[MDB_ShareExstensionUserDefault defaultInstance] readUserTokenFromNSUserDefaults]] isEqualToString:@""]) {
        [MDB_ShareExstensionUserDefault showNotifyHUDwithtext:@"您未登录,请先登录" inView:view];
        return;
    }
    NSDictionary *parameters = @{
                                 @"userkey":[NSString nullToString:[[MDB_ShareExstensionUserDefault defaultInstance] readUserTokenFromNSUserDefaults]],
                                 @"url":[NSString nullToString:link]
                                 };
    [HTTPManager sendGETRequestUrlToService:URL_shareinfo withParametersDictionry:parameters view:view completeHandle:^(NSURLSessionTask *opration, id responceObjct, NSError *error) {
        if (responceObjct==nil) {
            _resultMessage = @"网络错误";
        }else{
            NSString *str=[[NSString alloc]initWithData:responceObjct encoding:NSUTF8StringEncoding];
            NSDictionary *resultDict=[str JSONValue];
            if ([[NSString nullToString:resultDict[@"status"]] intValue] == 1) {
                _requestBrokeInfoResults = resultDict[@"data"];
            }else{
                _resultMessage = resultDict[@"info"];
            }
        }
        Callback(error);
    }];
    
}

- (void)requestGetCateDataWithInView:(UIView *)view callback:(completionCallback)Callback{
    
    [HTTPManager sendGETRequestUrlToService:URL_getcatetree withParametersDictionry:nil view:view completeHandle:^(NSURLSessionTask *opration, id responceObjct, NSError *error) {
        if (responceObjct==nil) {
            _resultMessage = @"网络错误";
        }else{
            NSString *str=[[NSString alloc]initWithData:responceObjct encoding:NSUTF8StringEncoding];
            NSDictionary *resultDict=[str JSONValue];
            if ([[NSString nullToString:resultDict[@"status"]] intValue] == 1) {
                _requestCateResults = resultDict[@"data"];
            }else{
                _resultMessage = resultDict[@"info"];
            }
        }
        Callback(error);
    }];
    
}

- (void)requestSubmitBrokeWithInfo:(NSDictionary *)infoDict
                            InView:(UIView *)view
                          callback:(completionCallback)Callback{
    
    if ([[NSString nullToString:[[MDB_ShareExstensionUserDefault defaultInstance] readUserTokenFromNSUserDefaults]] isEqualToString:@""]) {
        [MDB_ShareExstensionUserDefault showNotifyHUDwithtext:@"您未登录,请先登录" inView:view];
        return;
    }
    
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] initWithDictionary:infoDict];
    [parameters setObject:[NSString nullToString:[[MDB_ShareExstensionUserDefault defaultInstance] readUserTokenFromNSUserDefaults]] forKey:@"userkey"];
    [parameters setObject:[FCUUID uuidForDevice] forKey:@"uniquetoken"];

    [HTTPManager sendRequestUrlToService:URL_saveshareinfo withParametersDictionry:parameters view:view completeHandle:^(NSURLSessionTask *opration, id responceObjct, NSError *error) {
        if (responceObjct==nil) {
            _resultMessage = @"网络错误";
        }else{
            NSString *str=[[NSString alloc]initWithData:responceObjct encoding:NSUTF8StringEncoding];
            NSDictionary *resultDict=[str JSONValue];
            if ([[NSString nullToString:resultDict[@"status"]] intValue] == 1) {
            }else{
                _resultMessage = resultDict[@"info"];
            }
        }
        Callback(error);
    }];
    
}
@end
