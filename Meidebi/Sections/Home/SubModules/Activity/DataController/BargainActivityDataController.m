
//
//  BargainActivityDataController.m
//  Meidebi
//
//  Created by mdb-admin on 2017/10/17.
//  Copyright © 2017年 meidebi. All rights reserved.
//

#import "BargainActivityDataController.h"
#import "MDB_UserDefault.h"
#import "HTTPManager.h"
@implementation BargainActivityDataController

- (void)requestActivityDetailWithID:(NSString *)activityID
                         targetView:(UIView *)view
                           callback:(completeCallback)callback{
    NSDictionary *parmarter = @{@"id":[NSString nullToString:activityID],
                                @"userkey":[NSString nullToString:[MDB_UserDefault defaultInstance].usertoken]};
    [HTTPManager sendGETRequestUrlToService:URL_BargainActivityDetail
                    withParametersDictionry:parmarter
                                       view:view
                             completeHandle:^(NSURLSessionTask *opration, id responceObjct, NSError *error) {
        BOOL state = NO;
        NSString *describle = @"";
        if (responceObjct==nil) {
            describle = @"网络错误";
        }else{
            NSString *str=[[NSString alloc]initWithData:responceObjct encoding:NSUTF8StringEncoding];
            NSDictionary *dicAll=[str JSONValue];
            describle = dicAll[@"info"];
            if ([[NSString nullToString:dicAll[@"status"]] intValue] == 1) {
                NSDictionary *dict=[dicAll objectForKey:@"data"];
                if (dict) {
                    _resultDict = dict;
                    state = YES;
                }
            }
        }
        callback(error,state,describle);
    }];
}

- (void)requestActivityItemDetailWithID:(NSString *)itemID
                             targetView:(UIView *)view
                               callback:(completeCallback)callback{
    NSDictionary *parmarter = @{@"id":[NSString nullToString:itemID],
                                @"userkey":[NSString nullToString:[MDB_UserDefault defaultInstance].usertoken]};
    [HTTPManager sendGETRequestUrlToService:URL_BargainActivityCommodityDetail
                    withParametersDictionry:parmarter
                                       view:view
                             completeHandle:^(NSURLSessionTask *opration, id responceObjct, NSError *error) {
                                 BOOL state = NO;
                                 NSString *describle = @"";
                                 if (responceObjct==nil) {
                                     describle = @"网络错误";
                                 }else{
                                     NSString *str=[[NSString alloc]initWithData:responceObjct encoding:NSUTF8StringEncoding];
                                     NSDictionary *dicAll=[str JSONValue];
                                     describle = dicAll[@"info"];
                                     if ([[NSString nullToString:dicAll[@"status"]] intValue] == 1) {
                                         NSDictionary *dict=[dicAll objectForKey:@"data"];
                                         if (dict) {
                                             _resultDict = dict;
                                             state = YES;
                                         }
                                     }
                                 }
                                 callback(error,state,describle);
                             }];
}

- (void)requestParticipationActivityWithID:(NSString *)itemID
                                targetView:(UIView *)view
                                  callback:(completeCallback)callback{
    NSDictionary *parmarter = @{@"id":[NSString nullToString:itemID],
                                @"userkey":[NSString nullToString:[MDB_UserDefault defaultInstance].usertoken]};
    [HTTPManager sendGETRequestUrlToService:URL_BargainActivityJoin
                    withParametersDictionry:parmarter
                                       view:view
                             completeHandle:^(NSURLSessionTask *opration, id responceObjct, NSError *error) {
                                 BOOL state = NO;
                                 NSString *describle = @"";
                                 if (responceObjct==nil) {
                                     describle = @"网络错误";
                                 }else{
                                     NSString *str=[[NSString alloc]initWithData:responceObjct encoding:NSUTF8StringEncoding];
                                     NSDictionary *dicAll=[str JSONValue];
                                     describle = dicAll[@"info"];
                                     if ([[NSString nullToString:dicAll[@"status"]] intValue] == 1) {
                                         NSDictionary *dict=[dicAll objectForKey:@"data"];
                                         if (dict) {
                                             _resultDict = dict;
                                             state = YES;
                                         }
                                     }
                                 }
                                 callback(error,state,describle);
                             }];
}

- (void)requestBargainSelfActivityWithID:(NSString *)itemID
                              targetView:(UIView *)view
                                callback:(completeCallback)callback{
    
    NSDictionary *parmarter = @{@"c_id":[NSString nullToString:itemID],
                                @"userkey":[NSString nullToString:[MDB_UserDefault defaultInstance].usertoken],
                                @"u_id":[NSString nullToString:[MDB_UserDefault defaultInstance].userID]};
    [HTTPManager sendGETRequestUrlToService:URL_BargainActivityHaggle
                    withParametersDictionry:parmarter
                                       view:view
                             completeHandle:^(NSURLSessionTask *opration, id responceObjct, NSError *error) {
                                 BOOL state = NO;
                                 NSString *describle = @"";
                                 if (responceObjct==nil) {
                                     describle = @"网络错误";
                                 }else{
                                     NSString *str=[[NSString alloc]initWithData:responceObjct encoding:NSUTF8StringEncoding];
                                     NSDictionary *dicAll=[str JSONValue];
                                     describle = dicAll[@"info"];
                                     if ([[NSString nullToString:dicAll[@"status"]] intValue] == 1) {
                                         NSDictionary *dict=[dicAll objectForKey:@"data"];
                                         if (dict) {
                                             _resultDict = dict;
                                             state = YES;
                                         }
                                     }
                                 }
                                 callback(error,state,describle);
                             }];
}

- (void)requestShareBargainActivityWithID:(NSString *)itemID
                                      cID:(NSString *)cID
                               targetView:(UIView *)view
                                 callback:(completeCallback)callback{
    
    NSDictionary *parmarter = @{@"a_id":[NSString nullToString:itemID],
                                @"c_id":[NSString nullToString:cID],
                                @"userkey":[NSString nullToString:[MDB_UserDefault defaultInstance].usertoken]};
    [HTTPManager sendGETRequestUrlToService:URL_BargainActivityShare
                    withParametersDictionry:parmarter
                                       view:view
                             completeHandle:^(NSURLSessionTask *opration, id responceObjct, NSError *error) {
                                 BOOL state = NO;
                                 NSString *describle = @"";
                                 if (responceObjct==nil) {
                                     describle = @"网络错误";
                                 }else{
                                     NSString *str=[[NSString alloc]initWithData:responceObjct encoding:NSUTF8StringEncoding];
                                     NSDictionary *dicAll=[str JSONValue];
                                     describle = dicAll[@"info"];
                                     if ([[NSString nullToString:dicAll[@"status"]] intValue] == 1) {
                                         NSDictionary *dict=[dicAll objectForKey:@"data"];
                                         if (dict) {
                                             _resultShareInfoDict = dict;
                                             state = YES;
                                         }
                                     }
                                 }
                                 callback(error,state,describle);
                             }];
}

- (void)requestZanDataWithInView:(UIView *)view
                     Commodityid:(NSString *)commodityid
                        callback:(completeCallback)callback{
    NSString *userkey=[NSString nullToString:[MDB_UserDefault defaultInstance].usertoken];
    NSDictionary *dicURL=@{@"id":[NSString nullToString:commodityid],
                           @"votes":@"1",
                           @"userid":[NSString nullToString:userkey],
                           @"type":@"4"};
    [HTTPManager sendRequestUrlToService:URL_prace withParametersDictionry:dicURL view:view completeHandle:^(NSURLSessionTask *opration, id responceObjct, NSError *error) {
        NSString *describle = @"";
        BOOL state = NO;
        if (responceObjct) {
            NSString *str=[[NSString alloc]initWithData:responceObjct encoding:NSUTF8StringEncoding];
            NSDictionary *dic=[str JSONValue];
            if ([[NSString stringWithFormat:@"%@",[dic objectForKey:@"info"]] isEqualToString:@"VOTES_SUCCESS"]&&[[dic objectForKey:@"status"] integerValue] == 1) {
                _isSuccessZan = YES;
                [MDB_UserDefault showNotifyHUDwithtext:@"投票成功" inView:view];
            }else if ([[NSString stringWithFormat:@"%@",[dic objectForKey:@"info"]] isEqualToString:@"YOUR_ARE_VOTEED"]){
                _isSuccessZan = NO;
                [MDB_UserDefault showNotifyHUDwithtext:@"你已经投过票了" inView:view];
            }
            state = YES;
            describle = dic[@"info"];
        }
        callback(error,state,describle);
    }];
    
}

- (void)requestBargainRankActivityWithID:(NSString *)itemID
                              targetView:(UIView *)view
                                callback:(completeCallback)callback{
    NSDictionary *parmarter = @{@"id":[NSString nullToString:itemID],
                                @"userkey":[NSString nullToString:[MDB_UserDefault defaultInstance].usertoken]};
    [HTTPManager sendGETRequestUrlToService:URL_BargainActivityRank
                    withParametersDictionry:parmarter
                                       view:view
                             completeHandle:^(NSURLSessionTask *opration, id responceObjct, NSError *error) {
                                 BOOL state = NO;
                                 NSString *describle = @"";
                                 if (responceObjct==nil) {
                                     describle = @"网络错误";
                                 }else{
                                     NSString *str=[[NSString alloc]initWithData:responceObjct encoding:NSUTF8StringEncoding];
                                     NSDictionary *dicAll=[str JSONValue];
                                     describle = dicAll[@"info"];
                                     if ([[NSString nullToString:dicAll[@"status"]] intValue] == 1) {
                                         NSArray *arr=[dicAll objectForKey:@"data"];
                                         if (arr) {
                                             _requestResults = arr;
                                             state = YES;
                                         }
                                     }
                                 }
                                 callback(error,state,describle);
                             }];
}

- (void)requestParticipationRecordActivityWithTargetView:(UIView *)view
                                              activityID:(NSString *)activityID
                                                callback:(completeCallback)callback{
    
    NSDictionary *parmarter = @{@"userkey":[NSString nullToString:[MDB_UserDefault defaultInstance].usertoken],
                                @"id":[NSString nullToString:activityID]
                                };
    [HTTPManager sendGETRequestUrlToService:URL_BargainActivityJoinLog
                    withParametersDictionry:parmarter
                                       view:view
                             completeHandle:^(NSURLSessionTask *opration, id responceObjct, NSError *error) {
                                 BOOL state = NO;
                                 NSString *describle = @"";
                                 if (responceObjct==nil) {
                                     describle = @"网络错误";
                                 }else{
                                     NSString *str=[[NSString alloc]initWithData:responceObjct encoding:NSUTF8StringEncoding];
                                     NSDictionary *dicAll=[str JSONValue];
                                     describle = dicAll[@"info"];
                                     if ([[NSString nullToString:dicAll[@"status"]] intValue] == 1) {
                                         NSArray *arr=[dicAll objectForKey:@"data"];
                                         if (arr) {
                                             _requestResults = arr;
                                             state = YES;
                                         }
                                     }
                                 }
                                 callback(error,state,describle);
                             }];
}


- (void)requestBargainRecorActivityWithID:(NSString *)itemID
                               targetView:(UIView *)view
                                 callback:(completeCallback)callback{
    NSDictionary *parmarter = @{@"c_id":[NSString nullToString:itemID],
                                @"userkey":[NSString nullToString:[MDB_UserDefault defaultInstance].usertoken]};
    [HTTPManager sendGETRequestUrlToService:URL_BargainActivityHelps
                    withParametersDictionry:parmarter
                                       view:view
                             completeHandle:^(NSURLSessionTask *opration, id responceObjct, NSError *error) {
                                 BOOL state = NO;
                                 NSString *describle = @"";
                                 if (responceObjct==nil) {
                                     describle = @"网络错误";
                                 }else{
                                     NSString *str=[[NSString alloc]initWithData:responceObjct encoding:NSUTF8StringEncoding];
                                     NSDictionary *dicAll=[str JSONValue];
                                     describle = dicAll[@"info"];
                                     if ([[NSString nullToString:dicAll[@"status"]] intValue] == 1) {
                                         NSArray *arr=[dicAll objectForKey:@"data"];
                                         if (arr) {
                                             _requestResults = arr;
                                             state = YES;
                                         }
                                     }
                                 }
                                 callback(error,state,describle);
                             }];
}

@end
