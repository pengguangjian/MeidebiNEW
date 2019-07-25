//
//  BrokeShareDataController.m
//  Meidebi
//
//  Created by mdb-admin on 16/7/28.
//  Copyright © 2016年 meidebi. All rights reserved.
//

#import "BrokeShareDataController.h"
#import "HTTPManager.h"
#import "MDB_UserDefault.h"
#import <FCUUID/FCUUID.h>
@interface BrokeShareDataController ()

@property (nonatomic, strong) NSDictionary *requestBrokeInfoResults;
@property (nonatomic, strong) NSString *resultMessage;
@property (nonatomic, strong) NSArray *requestCateResults;

@end

@implementation BrokeShareDataController


//获取爆料URL的商品信息
- (void)requestGetShareInfoDataWithLink:(NSString *)link
                                   type:(NSString *)type
                                 InView:(UIView *)view
                               callback:(completeCallback)Callback{
    
    NSDictionary *parameters = @{
                                 @"userkey":[NSString nullToString:[MDB_UserDefault defaultInstance].usertoken],
                                 @"url":[NSString nullToString:link]
                                 };
    if (![@"" isEqualToString:type]) {
        NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:parameters];
        [dict setObject:type forKey:@"type"]; 
        parameters = dict.mutableCopy;
    }
    [HTTPManager sendGETRequestUrlToService:URL_shareinfo withParametersDictionry:parameters view:view completeHandle:^(NSURLSessionTask *opration, id responceObjct, NSError *error) {
        BOOL state = NO;
        if (responceObjct==nil) {
            _resultMessage = @"网络错误";
        }else{
            NSString *str=[[NSString alloc]initWithData:responceObjct encoding:NSUTF8StringEncoding];
            NSDictionary *resultDict=[str JSONValue];
            if ([[NSString nullToString:resultDict[@"status"]] intValue] == 1) {
                _requestBrokeInfoResults = resultDict[@"data"];
                state = YES;
                _resultMessage = @"";
            }else{
                _resultMessage = [NSString nullToString:resultDict[@"info"]];
            }
        }
        Callback(error,state,_resultMessage);
    }];
    
}

- (void)requestGetCateDataWithInView:(UIView *)view callback:(completeCallback)Callback{
    
    [HTTPManager sendGETRequestUrlToService:URL_getcatetree withParametersDictionry:nil view:view completeHandle:^(NSURLSessionTask *opration, id responceObjct, NSError *error) {
        BOOL state = NO;
        if (responceObjct==nil) {
            _resultMessage = @"网络错误";
        }else{
            NSString *str=[[NSString alloc]initWithData:responceObjct encoding:NSUTF8StringEncoding];
            NSDictionary *resultDict=[str JSONValue];
            if ([[NSString nullToString:resultDict[@"status"]] intValue] == 1) {
                _requestCateResults = resultDict[@"data"];
                state = YES;
            }else{
                _resultMessage = [NSString nullToString:resultDict[@"info"]];
            }
        }
        Callback(error,state,_resultMessage);
    }];

}

- (void)requestSubmitBrokeWithInfo:(NSDictionary *)infoDict
                            InView:(UIView *)view
                          callback:(completeCallback)Callback{
    
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] initWithDictionary:infoDict];
    NSString *usertoken = [NSString nullToString:[MDB_UserDefault defaultInstance].usertoken];
    [parameters setObject:usertoken forKey:@"userkey"];
    NSString *suuid = [NSString nullToString:[FCUUID uuidForDevice]];
    [parameters setObject:suuid forKey:@"uniquetoken"];
    
    [HTTPManager sendRequestUrlToService:URL_saveshareinfo withParametersDictionry:parameters view:view completeHandle:^(NSURLSessionTask *opration, id responceObjct, NSError *error) {
        BOOL state = NO;
        if (responceObjct==nil) {
            _resultMessage = @"网络错误";
        }else{
            NSString *str=[[NSString alloc]initWithData:responceObjct encoding:NSUTF8StringEncoding];
            NSDictionary *resultDict=[str JSONValue];
            if ([[NSString nullToString:resultDict[@"status"]] intValue] == 1) {
                state = YES;
                _resultMessage = @"";
            }else{
                _resultMessage = [NSString nullToString:resultDict[@"info"]];
            }
        }
        Callback(error,state,_resultMessage);
    }];

}
@end
