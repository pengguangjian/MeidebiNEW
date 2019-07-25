//
//  OrderDetaileDataController.m
//  Meidebi
//
//  Created by mdb-losaic on 2018/4/20.
//  Copyright © 2018年 meidebi. All rights reserved.
//

#import "OrderDetaileDataController.h"
#import "Qqshare.h"
#import "HTTPManager.h"
#import "MDB_UserDefault.h"

@interface OrderDetaileDataController ()

@property (nonatomic, strong) Qqshare *resultShareInfo;


@end
@implementation OrderDetaileDataController

// 获取订单详情(直下和拼单)
- (void)requestDGHomeDataInView:(UIView *)view
                        dicpush:(NSDictionary *)dicpush
                       Callback:(completeCallback)callback
{
    
    [HTTPManager sendRequestUrlToService:MyOrderDetailViewUrl withParametersDictionry:dicpush view:view completeHandle:^(NSURLSessionTask *opration, id responceObjct, NSError *error) {
        BOOL state = NO;
        NSString *describle = @"";
        if (responceObjct==nil) {
            describle = @"网络错误";
        }else{
            NSString *str=[[NSString alloc]initWithData:responceObjct encoding:NSUTF8StringEncoding];
            NSDictionary *dicAll=[str JSONValue];
            describle = dicAll[@"info"];
            if ([[NSString nullToString:dicAll[@"status"]] intValue] == 1) {
                NSDictionary *dic=[dicAll objectForKey:@"data"];
                if (dic) {
                    _dicreuselt = dic;
                    state = YES;
                }
            }
        }
        callback(error,state,describle);
    }];
}

// 创建获取分享红包信息
- (void)requestDGHomeHongBaoSharedicpush:(NSDictionary *)dicpush
                                  InView:(UIView *)view
                                Callback:(completeCallback)callback
{
    
    [HTTPManager sendRequestUrlToService:MyOrderDetailPopordercouponinfoUrl withParametersDictionry:dicpush view:view completeHandle:^(NSURLSessionTask *opration, id responceObjct, NSError *error) {
        BOOL state = NO;
        NSString *describle = @"";
        if (responceObjct==nil) {
            describle = @"网络错误";
        }else{
            NSString *str=[[NSString alloc]initWithData:responceObjct encoding:NSUTF8StringEncoding];
            NSDictionary *dicAll=[str JSONValue];
            describle = dicAll[@"info"];
            if ([[NSString nullToString:dicAll[@"status"]] intValue] == 1) {
                NSDictionary *dic=[dicAll objectForKey:@"data"];
                if (dic) {
                    _dicshare = dic;
                    state = YES;
                }
            }
        }
        callback(error,state,describle);
    }];
    
    
}
// 获取分享红包信息
- (void)requestDGHomeGetHongBaoSharedicpush:(NSDictionary *)dicpush
                                     InView:(UIView *)view
                                   Callback:(completeCallback)callback
{
    [HTTPManager sendGETRequestUrlToService:MyOrderSharePayHongBaoViewUrl withParametersDictionry:dicpush view:view completeHandle:^(NSURLSessionTask *opration, id responceObjct, NSError *error) {
        BOOL state = NO;
        NSString *describle = @"";
        if (responceObjct==nil) {
            describle = @"网络错误";
        }else{
            NSString *str=[[NSString alloc]initWithData:responceObjct encoding:NSUTF8StringEncoding];
            NSDictionary *dicAll=[str JSONValue];
            describle = dicAll[@"info"];
            if ([[NSString nullToString:dicAll[@"status"]] intValue] == 1) {
                NSDictionary *dic=[dicAll objectForKey:@"data"];
                if (dic) {
                    _dicshare = dic;
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
