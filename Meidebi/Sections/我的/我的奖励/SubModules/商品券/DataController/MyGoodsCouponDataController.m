//
//  MyGoodsCouponDataController.m
//  Meidebi
//
//  Created by mdb-losaic on 2018/12/28.
//  Copyright © 2018年 meidebi. All rights reserved.
//

#import "MyGoodsCouponDataController.h"
#import "HTTPManager.h"

@implementation MyGoodsCouponDataController

// 用户奖励金统计
- (void)requestmyyouhuiListInView:(UIView *)view
                          dicpush:(NSDictionary *)dicpush
                         Callback:(completeCallback)callback
{
    
    [HTTPManager sendGETRequestUrlToService:My_JiangLiYouHuiQuan_all withParametersDictionry:dicpush view:view completeHandle:^(NSURLSessionTask *opration, id responceObjct, NSError *error) {
        BOOL state = NO;
        NSString *describle = @"";
        if (responceObjct==nil) {
            describle = @"网络错误";
        }else{
            NSString *str=[[NSString alloc]initWithData:responceObjct encoding:NSUTF8StringEncoding];
            NSDictionary *dicAll=[str JSONValue];
            describle = dicAll[@"info"];
            if ([[NSString nullToString:dicAll[@"status"]] intValue] == 1) {
                NSArray *dictemt=[dicAll objectForKey:@"data"];
                if ([dictemt isKindOfClass:[NSArray class]]) {
                    _arrList = dictemt;
                    state = YES;
                }
            }
        }
        callback(error,state,describle);
    }];
    
    
}

@end
