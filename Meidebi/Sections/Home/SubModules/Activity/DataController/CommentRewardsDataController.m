//
//  CommentRewardsDataController.m
//  Meidebi
//
//  Created by fishmi on 2017/5/25.
//  Copyright © 2017年 meidebi. All rights reserved.
//

#import "CommentRewardsDataController.h"
#import "HTTPManager.h"
#import "MDB_UserDefault.h"
#import "Qqshare.h"
@implementation CommentRewardsDataController


- (void)requestCommentRewardsDataInView: (UIView *)view WithCallback:(completeCallback)callback{
    NSDictionary *parameters = @{@"id" : [NSString nullToString:_activityId]};    
    [HTTPManager sendRequestUrlToService:URL_commentRewards withParametersDictionry:parameters view:view completeHandle:^(NSURLSessionTask *opration, id responceObjct, NSError *error) {
        BOOL state = NO;
        NSString *describle = @"";
        if (responceObjct==nil) {
            describle = @"网络错误";

        }else{
            NSString *str=[[NSString alloc]initWithData:responceObjct encoding:NSUTF8StringEncoding];
            NSDictionary *dicAll=[str JSONValue];
            if ([[NSString nullToString:dicAll[@"status"]] intValue] == 1) {
                NSDictionary *dic=[dicAll objectForKey:@"data"];
                if (dic&&dic.count>0) {
                    _requestCommentRewardsDataControllerResults = dic;
                    
                    state = YES;
                }
                
            }else{
                describle = [dicAll objectForKey:@"info"];
            }
        }
        callback(error,state,describle);
    }];
    
}

- (void)requestShareSubjectDataWithCommodityid:(NSString *)commodityid inView:(UIView *)view callback:(completeCallback)callback{
    
    NSDictionary *parameter = @{@"id":[NSString nullToString:commodityid],
                                @"type" : @"4",
                                @"userkey":[NSString nullToString:[MDB_UserDefault defaultInstance].usertoken]};
    [HTTPManager sendGETRequestUrlToService:URL_getshare withParametersDictionry:parameter view:view completeHandle:^(NSURLSessionTask *opration, id responceObjct, NSError *error) {
        NSString *describle = @"网络错误 ！";
        BOOL state = NO;
        if (responceObjct) {
            NSString *str=[[NSString alloc]initWithData:responceObjct encoding:NSUTF8StringEncoding];
            NSDictionary *dictr=[str JSONValue];
            NSString* info = [NSString stringWithFormat:@"%@",[dictr objectForKey:@"info"]];
            describle = info;
            if (info && [info isEqualToString:@"GET_DATA_SUCCESS"]) {
                if ([dictr objectForKey:@"data"]&&[[dictr objectForKey:@"data"]isKindOfClass:[NSDictionary class]]) {
                    _resultShareInfo = [[Qqshare alloc] initWithdic:dictr[@"data"]];
                    state = YES;
                }
            }
        }
        if (callback) {
            callback(error,state,describle);
        }
    }];
    
}

- (void)requestShouDataWithInView:(UIView *)view
                      Commodityid:(NSString *)commodityid
                         callback:(completeCallback)callback{
    NSDictionary *dicURL=@{@"id":commodityid,
                           @"userkey":[NSString nullToString:[MDB_UserDefault defaultInstance].usertoken],
                           @"fetype":@"6"};
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

@end
