//
//  MyAccountOrderListDataController.m
//  Meidebi
//
//  Created by mdb-losaic on 2019/8/13.
//  Copyright © 2019 meidebi. All rights reserved.
//

#import "MyAccountOrderListDataController.h"
#import "HTTPManager.h"

@implementation MyAccountOrderListDataController

/// 订单明细列表
- (void)requestFanLiOrderListInfoDataInView:(UIView *)view
                                    dicpush:(NSDictionary *)dicpush
                                   Callback:(completeCallback)callback
{
    
    [HTTPManager sendRequestUrlToService:URL_Popularize_Order_Detailed withParametersDictionry:dicpush view:view completeHandle:^(NSURLSessionTask *opration, id responceObjct, NSError *error) {
        BOOL state = NO;
        NSString *describle = @"";
        if (responceObjct==nil) {
            describle = @"网络错误";
        }else{
            NSString *str=[[NSString alloc]initWithData:responceObjct encoding:NSUTF8StringEncoding];
            NSDictionary *dicAll=[str JSONValue];
            describle = dicAll[@"info"];
            if ([[NSString nullToString:dicAll[@"status"]] intValue] == 1) {
                if([[dicAll objectForKey:@"data"] isKindOfClass:[NSArray class]])
                {
                    self.arrresult = [dicAll objectForKey:@"data"];
                    state = YES;
                }
            }
        }
        callback(error,state,describle);
    }];
    
}

///返利明细主页
- (void)requestFanLiMainInfoDataInView:(UIView *)view
                               dicpush:(NSDictionary *)dicpush
                              Callback:(completeCallback)callback
{
    
    [HTTPManager sendRequestUrlToService:URL_Popularize_Commission_Detailed withParametersDictionry:dicpush view:view completeHandle:^(NSURLSessionTask *opration, id responceObjct, NSError *error) {
        BOOL state = NO;
        NSString *describle = @"";
        if (responceObjct==nil) {
            describle = @"网络错误";
        }else{
            NSString *str=[[NSString alloc]initWithData:responceObjct encoding:NSUTF8StringEncoding];
            NSDictionary *dicAll=[str JSONValue];
            describle = dicAll[@"info"];
            if ([[NSString nullToString:dicAll[@"status"]] intValue] == 1) {
                if([[dicAll objectForKey:@"data"] isKindOfClass:[NSDictionary class]])
                {
                    self.dicresult = [dicAll objectForKey:@"data"];
                    state = YES;
                }
            }
        }
        callback(error,state,describle);
    }];
}

@end
