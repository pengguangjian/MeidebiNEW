//
//  RewardDataController.m
//  Meidebi
//
//  Created by ZlJ_losaic on 2017/9/5.
//  Copyright © 2017年 meidebi. All rights reserved.
//

#import "RewardDataController.h"
#import "HTTPManager.h"
#import "MDB_UserDefault.h"

@interface RewardDataController ()

@end

@implementation RewardDataController

- (void)requestSubmitRewardDataWithInView:(UIView *)view
                              commodityid:(NSString *)commodityid
                                     type:(NSString *)type
                                  content:(NSString *)content
                                   amount:(NSString *)amount
                                 callback:(completeCallback)Callback{
    NSDictionary *parameter = @{@"id":[NSString nullToString:commodityid],
                                @"type":[NSString nullToString:type],
                                @"content":[NSString nullToString:content],
                                @"amount":[NSString nullToString:amount],
                                @"userkey":[NSString nullToString:[MDB_UserDefault defaultInstance].usertoken]};
    [HTTPManager sendRequestUrlToService:URL_Reward
                 withParametersDictionry:parameter
                                    view:view
                          completeHandle:^(NSURLSessionTask *opration, id responceObjct, NSError *error) {
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
        Callback(error,state,describle);
    }];
}

- (void)requestRewardDetailListWithInView:(UIView *)view
                              commodityid:(NSString *)commodityid
                                     type:(NSString *)type
                                 callback:(completeCallback)Callback{
    
    NSDictionary *parameter = @{@"id":[NSString nullToString:commodityid],
                                @"type":[NSString nullToString:type]};
    [HTTPManager sendRequestUrlToService:URL_Rewardlog
                 withParametersDictionry:parameter
                                    view:view
                          completeHandle:^(NSURLSessionTask *opration, id responceObjct, NSError *error) {
                              NSString *describle = @"网络错误！";
                              BOOL state = NO;
                              if (responceObjct) {
                                  NSString *str=[[NSString alloc]initWithData:responceObjct encoding:NSUTF8StringEncoding];
                                  NSDictionary *dictResult=[str JSONValue];
                                  NSInteger status = [dictResult[@"status"] integerValue];
                                  describle = dictResult[@"info"];
                                  if (status == 1) {
                                      if ([dictResult objectForKey:@"data"]) {
                                          _results = dictResult[@"data"];
                                          state = YES;
                                      }
                                  }
                              }
                              Callback(error,state,describle);
                          }];

}
@end
