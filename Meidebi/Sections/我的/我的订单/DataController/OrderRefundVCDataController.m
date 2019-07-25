//
//  OrderRefundVCDataController.m
//  Meidebi
//
//  Created by mdb-losaic on 2018/4/24.
//  Copyright © 2018年 meidebi. All rights reserved.
//

#import "OrderRefundVCDataController.h"
#import "HTTPManager.h"
#import "MDB_UserDefault.h"


@implementation OrderRefundVCDataController
// 退款详情
- (void)requestDGHomeDataInView:(UIView *)view
                        dicpush:(NSDictionary *)dicpush
                       Callback:(completeCallback)callback
{
    [HTTPManager sendRequestUrlToService:MyRefundOrderViewUrl withParametersDictionry:dicpush view:view completeHandle:^(NSURLSessionTask *opration, id responceObjct, NSError *error) {
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
@end
