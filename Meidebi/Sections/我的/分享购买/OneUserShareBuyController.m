//
//  OneUserShareBuyController.m
//  Meidebi
//
//  Created by mdb-losaic on 2019/8/12.
//  Copyright © 2019 meidebi. All rights reserved.
//

#import "OneUserShareBuyController.h"
#import "HTTPManager.h"

@implementation OneUserShareBuyController

// 获取我代购返利信息
- (void)requestDGFanLiInfoDataInView:(UIView *)view
                             dicpush:(NSDictionary *)dicpush
                            Callback:(completeCallback)callback
{
    [HTTPManager sendRequestUrlToService:URL_Popularize_Ambassador withParametersDictionry:dicpush view:view completeHandle:^(NSURLSessionTask *opration, id responceObjct, NSError *error) {
        BOOL state = NO;
        NSString *describle = @"";
        if (responceObjct==nil) {
            describle = @"网络错误";
        }else{
            NSString *str=[[NSString alloc]initWithData:responceObjct encoding:NSUTF8StringEncoding];
            NSDictionary *dicAll=[str JSONValue];
            describle = dicAll[@"info"];
            if ([[NSString nullToString:dicAll[@"status"]] intValue] == 1) {
                self.dicresult=[dicAll objectForKey:@"data"];
                state = YES;
            }
        }
        callback(error,state,describle);
    }];
    
}

@end
