//
//  DaiGouReMenShopDataController.m
//  Meidebi
//
//  Created by mdb-losaic on 2018/4/17.
//  Copyright © 2018年 meidebi. All rights reserved.
//

#import "DaiGouReMenShopDataController.h"
#import "HTTPManager.h"
#import "MDB_UserDefault.h"


@implementation DaiGouReMenShopDataController

// 获取列表数据
- (void)requestDGHomeListDataInView:(UIView *)view
                           Callback:(completeCallback)callback
{
    [HTTPManager sendRequestUrlToService:MainDaiGouHotShopUrl withParametersDictionry:nil view:view completeHandle:^(NSURLSessionTask *opration, id responceObjct, NSError *error) {
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
                    _dicReustData = [dicAll objectForKey:@"data"];
                    state = YES;
                }
                else
                {
                    
                    state = NO;
                }
                
            }
        }
        callback(error,state,describle);
    }];
    
}

@end
