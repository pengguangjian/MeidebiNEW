//
//  MyOrderMainDataController.m
//  Meidebi
//
//  Created by mdb-losaic on 2018/4/19.
//  Copyright © 2018年 meidebi. All rights reserved.
//

#import "MyOrderMainDataController.h"
#import "Qqshare.h"
#import "HTTPManager.h"
#import "MDB_UserDefault.h"


@interface MyOrderMainDataController ()

@property (nonatomic, strong) Qqshare *resultShareInfo;


@end

@implementation MyOrderMainDataController

// 获取我的订单0
- (void)requestDGHomeDataInView:(UIView *)view
                        dicpush:(NSDictionary *)dicpush
                       Callback:(completeCallback)callback
{
    
    [HTTPManager sendRequestUrlToService:MyOrderMainViewUrl withParametersDictionry:dicpush view:view completeHandle:^(NSURLSessionTask *opration, id responceObjct, NSError *error) {
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
                if (arrtemt) {
                    _arrrequest = arrtemt;
                    state = YES;
                }
            }
        }
        callback(error,state,describle);
    }];
    
}
// 取消订单原因列表
- (void)requestCancleOrderReasonDataInView:(UIView *)view
                                   dicpush:(NSDictionary *)dicpush
                                  Callback:(completeCallback)callback
{
    [HTTPManager sendRequestUrlToService:MyOrderCancleReasonViewUrl withParametersDictionry:dicpush view:view completeHandle:^(NSURLSessionTask *opration, id responceObjct, NSError *error) {
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
                if (arrtemt) {
                    _arrcancleReason = arrtemt;
                    state = YES;
                }
            }
        }
        callback(error,state,describle);
    }];
}

// 取消订单
- (void)requestCancleOrderDataInView:(UIView *)view
                             dicpush:(NSDictionary *)dicpush
                            Callback:(completeCallback)callback
{
    [HTTPManager sendRequestUrlToService:MyOrderCancleViewUrl withParametersDictionry:dicpush view:view completeHandle:^(NSURLSessionTask *opration, id responceObjct, NSError *error) {
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
                if (arrtemt) {
                    _arrrequest = arrtemt;
                    state = YES;
                }
            }
        }
        callback(error,state,describle);
    }];
    
}

// 确认收货
- (void)requestShouHuoOrderDataInView:(UIView *)view
                              dicpush:(NSDictionary *)dicpush
                             Callback:(completeCallback)callback
{
    [HTTPManager sendRequestUrlToService:MyOrderShouHuoViewUrl withParametersDictionry:dicpush view:view completeHandle:^(NSURLSessionTask *opration, id responceObjct, NSError *error) {
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
                if (arrtemt) {
//                    _arrrequest = arrtemt;
                    state = YES;
                }
            }
        }
        callback(error,state,describle);
    }];
    
}

// 删除订单
- (void)requestDelOrderDataInView:(UIView *)view
                          dicpush:(NSDictionary *)dicpush
                         Callback:(completeCallback)callback
{
    [HTTPManager sendRequestUrlToService:MyOrderDelViewUrl withParametersDictionry:dicpush view:view completeHandle:^(NSURLSessionTask *opration, id responceObjct, NSError *error) {
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
                if (arrtemt) {
                    //                    _arrrequest = arrtemt;
                    state = YES;
                }
            }
        }
        callback(error,state,describle);
    }];
    
}

- (void)requestShareSubjectDataWithCommodityid:(NSString *)commodityid inView:(UIView *)view callback:(completeCallback)callback{
    
    NSDictionary *parameter = @{@"id":[NSString nullToString:commodityid],
                                @"userkey":[NSString nullToString:[MDB_UserDefault defaultInstance].usertoken]};
    [HTTPManager sendGETRequestUrlToService:URL_getshare withParametersDictionry:parameter view:view completeHandle:^(NSURLSessionTask *opration, id responceObjct, NSError *error) {
        NSString *describle = @"";
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
@end
