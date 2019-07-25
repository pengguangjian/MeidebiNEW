//
//  MyJiangLiDataController.m
//  Meidebi
//
//  Created by mdb-losaic on 2018/7/18.
//  Copyright © 2018年 meidebi. All rights reserved.
//

#import "MyJiangLiDataController.h"

#import "HTTPManager.h"

@implementation MyJiangLiDataController

// 用户奖励金统计
- (void)requestLeiJiDataInView:(UIView *)view
                       dicpush:(NSDictionary *)dicpush
                      Callback:(completeCallback)callback
{
    [HTTPManager sendRequestUrlToService:My_JiangLiMoney_all withParametersDictionry:dicpush view:view completeHandle:^(NSURLSessionTask *opration, id responceObjct, NSError *error) {
        BOOL state = NO;
        NSString *describle = @"";
        if (responceObjct==nil) {
            describle = @"网络错误";
        }else{
            NSString *str=[[NSString alloc]initWithData:responceObjct encoding:NSUTF8StringEncoding];
            NSDictionary *dicAll=[str JSONValue];
            describle = dicAll[@"info"];
            if ([[NSString nullToString:dicAll[@"status"]] intValue] == 1) {
                NSDictionary *dictemt=[dicAll objectForKey:@"data"];
                if ([dictemt isKindOfClass:[NSDictionary class]]) {
                    _diccancleorder = dictemt;
                    state = YES;
                }
            }
        }
        callback(error,state,describle);
    }];
}

// 用户月奖励金统计
- (void)requestMouthDataInView:(UIView *)view
                       dicpush:(NSDictionary *)dicpush
                      Callback:(completeCallback)callback
{
    
    [HTTPManager sendRequestUrlToService:My_JiangLiMoney_mouth withParametersDictionry:dicpush view:view completeHandle:^(NSURLSessionTask *opration, id responceObjct, NSError *error) {
        BOOL state = NO;
        NSString *describle = @"";
        if (responceObjct==nil) {
            describle = @"网络错误";
        }else{
            NSString *str=[[NSString alloc]initWithData:responceObjct encoding:NSUTF8StringEncoding];
            NSDictionary *dicAll=[str JSONValue];
            describle = dicAll[@"info"];
            if ([[NSString nullToString:dicAll[@"status"]] intValue] == 1) {
                NSArray *arrtemt=[dicAll objectForKey:@"data"];
                if ([arrtemt isKindOfClass:[NSArray class]]) {
                    _arrcancleReason = arrtemt;
                    state = YES;
                }
            }
        }
        callback(error,state,describle);
    }];
    
}


// 奖励明细
- (void)requestDetailDataInView:(UIView *)view
                        dicpush:(NSDictionary *)dicpush
                       Callback:(completeCallback)callback
{
    
    [HTTPManager sendRequestUrlToService:My_JiangLiMoney_detail withParametersDictionry:dicpush view:view completeHandle:^(NSURLSessionTask *opration, id responceObjct, NSError *error) {
        BOOL state = NO;
        NSString *describle = @"";
        if (responceObjct==nil) {
            describle = @"网络错误";
        }else{
            NSString *str=[[NSString alloc]initWithData:responceObjct encoding:NSUTF8StringEncoding];
            NSDictionary *dicAll=[str JSONValue];
            describle = dicAll[@"info"];
            if ([[NSString nullToString:dicAll[@"status"]] intValue] == 1) {
                NSArray *arrtemt=[dicAll objectForKey:@"data"];
                if ([arrtemt isKindOfClass:[NSArray class]]) {
                    _arrdetail = arrtemt;
                    state = YES;
                }
            }
        }
        callback(error,state,describle);
    }];
    
}


@end
