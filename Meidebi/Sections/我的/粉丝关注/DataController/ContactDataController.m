//
//  ContactDataController.m
//  Meidebi
//
//  Created by mdb-admin on 2017/6/20.
//  Copyright © 2017年 meidebi. All rights reserved.
//

#import "ContactDataController.h"
#import "HTTPManager.h"
#import "MDB_UserDefault.h"

@implementation ContactDataController

// 关注
- (void)requestFollowListInView:(UIView *)view
                       Callback:(completeCallback)callback{
    NSDictionary *parameter = @{@"userkey":[NSString nullToString:[MDB_UserDefault defaultInstance].usertoken]};
    [HTTPManager sendGETRequestUrlToService:URL_FollowList withParametersDictionry:parameter view:view completeHandle:^(NSURLSessionTask *opration, id responceObjct, NSError *error) {
        BOOL state = NO;
        NSString *describle = @"";
        if (responceObjct==nil) {
            describle = @"网络错误";
        }else{
            NSString *str=[[NSString alloc]initWithData:responceObjct encoding:NSUTF8StringEncoding];
            NSDictionary *dicAll=[str JSONValue];
            if ([[NSString nullToString:dicAll[@"status"]] intValue] == 1) {
                NSArray *arr=[dicAll objectForKey:@"data"];
                _requestResults = arr;
                if (_requestResults.count > 0) {
                    state = YES;
                }else{
                    describle = @"您暂时还没有关注任何人！";
                }
            }
        }
        callback(error,state,describle);
    }];
}

// 粉丝
- (void)requestFansListInView:(UIView *)view
                     Callback:(completeCallback)callback{
    
    NSDictionary *parameter = @{@"userkey":[NSString nullToString:[MDB_UserDefault defaultInstance].usertoken]};
    [HTTPManager sendGETRequestUrlToService:URL_FansList withParametersDictionry:parameter view:view completeHandle:^(NSURLSessionTask *opration, id responceObjct, NSError *error) {
        BOOL state = NO;
        NSString *describle = @"";
        if (responceObjct==nil) {
            describle = @"网络错误";
        }else{
            NSString *str=[[NSString alloc]initWithData:responceObjct encoding:NSUTF8StringEncoding];
            NSDictionary *dicAll=[str JSONValue];
            if ([[NSString nullToString:dicAll[@"status"]] intValue] == 1) {
                NSArray *arr=[dicAll objectForKey:@"data"];
                _requestResults = arr;
                if (_requestResults.count > 0) {
                    state = YES;
                }else{
                    describle = @"您暂时还没有粉丝！";
                }
            }
        }
        callback(error,state,describle);
    }];

}

- (void)requestAddFollwDataWithInView:(UIView *)view
                               userid:(NSString *)userid
                             callback:(completeCallback)callback{
    
    NSDictionary *parmaters = @{@"userkey":[NSString nullToString:[MDB_UserDefault defaultInstance].usertoken],
                                @"userid":[NSString nullToString:userid]};
    [HTTPManager sendRequestUrlToService:URL_AddFollow withParametersDictionry:parmaters view:view completeHandle:^(NSURLSessionTask *opration, id responceObjct, NSError *error) {
        NSString *describle = @"网络错误！";
        BOOL state = NO;
        if (responceObjct) {
            NSString *str=[[NSString alloc]initWithData:responceObjct encoding:NSUTF8StringEncoding];
            NSDictionary *dictResult=[str JSONValue];
            NSInteger status = [dictResult[@"status"] integerValue];
            describle = dictResult[@"info"];
            if (status == 1) {
                if ([dictResult objectForKey:@"data"]) {
                    _resultDict = dictResult[@"data"];
                    state = YES;
                }
            }
        }
        callback(error,state,describle);
    }];
}

- (void)requestCancelFollwDataWithInView:(UIView *)view
                                  userid:(NSString *)userid
                                callback:(completeCallback)callback{
    NSDictionary *parmaters = @{@"userkey":[NSString nullToString:[MDB_UserDefault defaultInstance].usertoken],
                                @"userid":[NSString nullToString:userid]};
    [HTTPManager sendRequestUrlToService:URL_CancelFollow withParametersDictionry:parmaters view:view completeHandle:^(NSURLSessionTask *opration, id responceObjct, NSError *error) {
        NSString *describle = @"网络错误！";
        BOOL state = NO;
        if (responceObjct) {
            NSString *str=[[NSString alloc]initWithData:responceObjct encoding:NSUTF8StringEncoding];
            NSDictionary *dictResult=[str JSONValue];
            NSInteger status = [dictResult[@"status"] integerValue];
            describle = dictResult[@"info"];
            if (status == 1) {
                if ([dictResult objectForKey:@"data"]) {
                    _resultDict = dictResult[@"data"];
                    state = YES;
                }
            }
        }
        callback(error,state,describle);
    }];

}
@end
