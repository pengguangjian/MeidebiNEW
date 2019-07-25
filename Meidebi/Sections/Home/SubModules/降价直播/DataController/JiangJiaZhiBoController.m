//
//  JiangJiaZhiBoController.m
//  Meidebi
//
//  Created by mdb-losaic on 2019/3/26.
//  Copyright © 2019年 meidebi. All rights reserved.
//

#import "JiangJiaZhiBoController.h"
#import "HTTPManager.h"

@implementation JiangJiaZhiBoController

/// 获取数据
- (void)requestJiangJiaZhiBoDataInView:(UIView *)view
                                 value:(NSDictionary *)dicpush
                              Callback:(completeCallback)callback
{
    [HTTPManager sendGETRequestUrlToService:URL_JiangJiaZhiBo withParametersDictionry:dicpush view:view completeHandle:^(NSURLSessionTask *opration, id responceObjct, NSError *error) {
        BOOL state = NO;
        NSString *describle = @"网络错误！";
        if (responceObjct){
            NSString *str=[[NSString alloc]initWithData:responceObjct encoding:NSUTF8StringEncoding];
            NSDictionary *dicAll=[str JSONValue];
            if ([[dicAll objectForKey:@"status"]intValue] == 1) {
                NSArray *arr=[dicAll objectForKey:@"data"];
                if (arr) {
                    _requestResults = arr;
                    state = YES;
                }
            }else{
                describle = dicAll[@"info"];
            }
        }
        callback(error,state,describle);
    }];
}
@end
