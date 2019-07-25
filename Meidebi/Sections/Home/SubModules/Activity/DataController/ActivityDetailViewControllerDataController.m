//
//  ActivityDetailViewControllerDataController.m
//  Meidebi
//
//  Created by fishmi on 2017/5/25.
//  Copyright © 2017年 meidebi. All rights reserved.
//

#import "ActivityDetailViewControllerDataController.h"
#import "HTTPManager.h"
#import "MDB_UserDefault.h"
#import "Qqshare.h"

@interface ActivityDetailViewControllerDataController ()
@end

@implementation ActivityDetailViewControllerDataController


- (void)requestActivityDetailDataWithInView:(UIView *)view
                                   callback:(completeCallback)callback{
    
    NSDictionary *parameters = @{
                                 @"id" : [NSString nullToString:_activityId],
                                 @"userkey":[NSString nullToString:[MDB_UserDefault defaultInstance].usertoken]
                                 };
    [HTTPManager sendRequestUrlToService:URL_activityDetail withParametersDictionry:parameters view:view completeHandle:^(NSURLSessionTask *opration, id responceObjct, NSError *error) {
        BOOL state = NO;
        NSString *describle = @"";
        if (responceObjct==nil) {
            describle = @"网络错误";
            
        }else{
            NSString *str=[[NSString alloc]initWithData:responceObjct encoding:NSUTF8StringEncoding];
            NSDictionary *dicAll=[str JSONValue];
            if ([[NSString nullToString:dicAll[@"status"]] intValue] == 1) {
                NSDictionary *dic=[dicAll objectForKey:@"data"];
                if (dic) {
                    _requestActivityDetailResults = dic;
                    state = YES;
                }
                
            }
        }
        callback(error,state,describle);
    }];
    
}

- (void)requestActivityShareDataWithJoinID:(NSString *)joinID
                                  callback:(completeCallback)callback{
    NSDictionary *parameters = @{
                                 @"a_id" : [NSString nullToString:joinID],
                                 @"j_id":[NSString nullToString:_activityId]
                                 };
    [HTTPManager sendRequestUrlToService:URL_ActivityJoinShare
                 withParametersDictionry:parameters
                                    view:nil
                          completeHandle:^(NSURLSessionTask *opration, id responceObjct, NSError *error) {
        BOOL state = NO;
        NSString *describle = @"";
        if (responceObjct==nil) {
            describle = @"网络错误";
        }else{
            NSString *str=[[NSString alloc]initWithData:responceObjct encoding:NSUTF8StringEncoding];
            NSDictionary *dicAll=[str JSONValue];
            if ([[NSString nullToString:dicAll[@"status"]] intValue] == 1) {
                NSDictionary *dic=[dicAll objectForKey:@"data"];
                if (dic) {
                    _resultShareInfo = [ShareModel modelWithDict:dic];
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
                           @"type":@"5"};
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

- (void)requestShouDataWithInView:(UIView *)view
                      Commodityid:(NSString *)commodityid
                         callback:(completeCallback)callback{
    NSDictionary *dicURL=@{@"id":[NSString nullToString:commodityid],
                           @"userkey":[NSString nullToString:[MDB_UserDefault defaultInstance].usertoken],
                           @"fetype":@"7"};
    [HTTPManager sendRequestUrlToService:URL_favorite withParametersDictionry:dicURL view:view completeHandle:^(NSURLSessionTask *opration, id responceObjct, NSError *error) {
        NSString *describle = @"";
        BOOL state = NO;
        if (responceObjct) {
            NSString *str=[[NSString alloc]initWithData:responceObjct encoding:NSUTF8StringEncoding];
            NSDictionary *dic=[str JSONValue];
            if ([[NSString stringWithFormat:@"%@",[dic objectForKey:@"info"]] isEqualToString:@"GET_DATA_SUCCESS"]&&[[dic objectForKey:@"status"] integerValue]) {
                if ([[dic objectForKey:@"data"]isKindOfClass:[NSString class]]) {
                    if ([[dic objectForKey:@"data"]isEqualToString:@"取消收藏成功！"]) {
                        _isSuccessShou = NO;
                    }else{
                        _isSuccessShou = YES;
                    }
                }
            }else if ([[NSString stringWithFormat:@"%@",[dic objectForKey:@"info"]] isEqualToString:@"YOUR_ARE_VOTEED"]){
            }
            state = YES;
            describle = dic[@"info"];
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
        NSString *describle = @"";
        BOOL state = NO;
        if (responceObjct) {
            NSString *str=[[NSString alloc]initWithData:responceObjct encoding:NSUTF8StringEncoding];
            NSDictionary *dictResult=[str JSONValue];
            NSInteger status = [dictResult[@"status"] integerValue];
            describle = dictResult[@"info"];
            if (status == 1) {
                if ([dictResult objectForKey:@"data"]) {
                    _dict = dictResult[@"data"];
                    state = YES;
                }
            }
        }
        callback(error,state,describle);
    }];
}




@end
