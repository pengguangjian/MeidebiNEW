//
//  TrendDataController.m
//  Meidebi
//
//  Created by mdb-admin on 2017/11/30.
//  Copyright © 2017年 meidebi. All rights reserved.
//

#import "TrendDataController.h"
#import "HTTPManager.h"
#import "MDB_UserDefault.h"
@implementation TrendDataController

- (void)requestTrendListInView:(UIView *)view type:(NSString *)type callback:(completeCallback)callback{
    
    NSDictionary *parameters=@{@"type":[NSString nullToString:type],
                               @"userkey":[NSString nullToString:[MDB_UserDefault defaultInstance].usertoken]};
    
    [HTTPManager sendGETRequestUrlToService:URL_TrendList
                    withParametersDictionry:parameters
                                       view:view
                             completeHandle:^(NSURLSessionTask *opration, id responceObjct, NSError *error) {
                                 BOOL state = NO;
                                 NSString *describle = @"";
                                 if (responceObjct==nil) {
                                     describle = @"网络错误";
                                 }else{
                                     NSString *str=[[NSString alloc]initWithData:responceObjct encoding:NSUTF8StringEncoding];
                                     NSDictionary *dicAll=[str JSONValue];
                                     describle = dicAll[@"info"];
                                     if ([[NSString nullToString:dicAll[@"status"]] intValue] == 1) {
                                         NSArray *subjects = dicAll[@"data"];
                                         if ([subjects isKindOfClass:[NSDictionary class]] || [subjects isKindOfClass:[NSString class]] || [subjects isKindOfClass:[NSNull class]]){
                                             describle = @"未查到相关数据";
                                             callback(nil,state,describle);
                                             return;
                                         };
                                         state = YES;
                                         _requestResults=subjects.mutableCopy;
                                     }
                                 }
                                 callback(error,state,describle);
                             }];
}

@end
