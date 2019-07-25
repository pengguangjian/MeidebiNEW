//
//  PushSubscibeDataController.m
//  Meidebi
//
//  Created by mdb-admin on 16/9/21.
//  Copyright © 2016年 meidebi. All rights reserved.
//

#import "PushSubscibeDataController.h"
#import "HTTPManager.h"
#import "MDB_UserDefault.h"

@interface PushSubscibeDataController ()

@property (nonatomic, strong) NSString *requestResults;
@property (nonatomic, strong) NSString *resultMessage;

@end

@implementation PushSubscibeDataController

- (void)requestSubjectDataInView:(UIView *)view
                        callback:(completeCallback)Callback{
    
//    if([[NSString nullToString:[MDB_UserDefault getUmengDeviceToken]] isEqualToString:@""])
//    {
//        [MDB_UserDefault setUmengDeviceToken:@"123"];
//    }
    
    NSDictionary *parameters = @{
                                 @"umengtoken":[NSString nullToString:[MDB_UserDefault getUmengDeviceToken]],
                                 @"userkey":[NSString nullToString:[MDB_UserDefault defaultInstance].usertoken]
                                 };
    [HTTPManager sendGETRequestUrlToService:URL_getsubscrib withParametersDictionry:parameters view:view completeHandle:^(NSURLSessionTask *opration, id responceObjct, NSError *error) {
        BOOL state = NO;
        if (responceObjct==nil) {
            _resultMessage = @"网络错误";
        }else{
            NSString *str=[[NSString alloc]initWithData:responceObjct encoding:NSUTF8StringEncoding];
            NSDictionary *resultDict=[str JSONValue];
            if ([[NSString nullToString:resultDict[@"status"]] intValue] == 1) {
                if ([resultDict[@"data"] isKindOfClass:[NSArray class]]) {
                    _requestResults = [resultDict[@"data"] componentsJoinedByString:@","];
                }else if([resultDict[@"data"] isKindOfClass:[NSString class]]){
                    _requestResults = resultDict[@"data"];
                }
                state = YES;
            }else{
                if ([@"PARAMETER_ERROR" isEqualToString:resultDict[@"info"]] && [@"" isEqualToString:[NSString nullToString:[MDB_UserDefault getUmengDeviceToken]]]) {
                    _resultMessage = @"请在设置中打开允许接收通知！";
                }else{
                    _resultMessage = resultDict[@"info"];
                }
            }
        }
        Callback(error,state,_resultMessage);
    }];
}

- (void)requestSetPushKeywordDataInView:(UIView *)view
                                keyword:(NSString *)keyword
                               callback:(completeCallback)Callback{

    NSDictionary *parameters = @{
                                 @"umengtoken":[NSString nullToString:[MDB_UserDefault getUmengDeviceToken]],
                                 @"keyword":[NSString nullToString:keyword],
                                 @"userkey":[NSString nullToString:[MDB_UserDefault defaultInstance].usertoken]
                                 };
    [HTTPManager sendRequestUrlToService:URL_setsubscrib withParametersDictionry:parameters view:view completeHandle:^(NSURLSessionTask *opration, id responceObjct, NSError *error) {
        BOOL state = NO;
        if (responceObjct==nil) {
            _resultMessage = @"网络错误";
        }else{
            NSString *str=[[NSString alloc]initWithData:responceObjct encoding:NSUTF8StringEncoding];
            NSDictionary *resultDict=[str JSONValue];
            if ([[NSString nullToString:resultDict[@"status"]] intValue] == 1) {
                state = YES;
                _resultMessage = resultDict[@"info"];
            }else{
                _resultMessage = resultDict[@"info"];
            }
        }
        Callback(error,state,_resultMessage);
    }];

}
@end
