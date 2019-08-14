//
//  MyAccountTXJLDataController.m
//  Meidebi
//
//  Created by mdb-losaic on 2019/8/13.
//  Copyright © 2019 meidebi. All rights reserved.
//

#import "MyAccountTXJLDataController.h"
#import "HTTPManager.h"



@implementation MyAccountTXJLDataController
/// 提现记录
- (void)requestTXJLInfoDataInView:(UIView *)view
                          dicpush:(NSDictionary *)dicpush
                         Callback:(completeCallback)callback
{
    [HTTPManager sendRequestUrlToService:URL_Popularize_Tixian_Record withParametersDictionry:dicpush view:view completeHandle:^(NSURLSessionTask *opration, id responceObjct, NSError *error) {
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


@end
