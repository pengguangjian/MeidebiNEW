//
//  PinDanAlterDataController.m
//  Meidebi
//
//  Created by mdb-losaic on 2018/4/18.
//  Copyright © 2018年 meidebi. All rights reserved.
//

#import "PinDanAlterDataController.h"
#import "HTTPManager.h"
#import "MDB_UserDefault.h"

@implementation PinDanAlterDataController

// 获取拼单数据
- (void)requestDGHomeDataInView:(UIView *)view
                      pindan_id:(NSString *)strpindan_id
                       Callback:(completeCallback)callback
{
    NSDictionary *dicpush = @{@"pindan_id":strpindan_id};
    [HTTPManager sendRequestUrlToService:PinDaiAlterUrl withParametersDictionry:dicpush view:view completeHandle:^(NSURLSessionTask *opration, id responceObjct, NSError *error) {
        BOOL state = NO;
        NSString *describle = @"";
        if (responceObjct==nil) {
            describle = @"网络错误";
        }else{
            NSString *str=[[NSString alloc]initWithData:responceObjct encoding:NSUTF8StringEncoding];
            NSDictionary *dicAll=[str JSONValue];
            describle = dicAll[@"info"];
            if ([[NSString nullToString:dicAll[@"status"]] intValue] == 1) {
                NSDictionary *dict=[dicAll objectForKey:@"data"];
                if (dict) {
                    _dicreuset = dict;
                    state = YES;
                }
            }
        }
        callback(error,state,describle);
    }];
    
}
@end
