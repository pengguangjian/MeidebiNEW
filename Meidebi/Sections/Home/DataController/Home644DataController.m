//
//  Home644DataController.m
//  Meidebi
//
//  Created by mdb-losaic on 2018/7/2.
//  Copyright © 2018年 meidebi. All rights reserved.
//

#import "Home644DataController.h"
#import "HTTPManager.h"
#import "MDB_UserDefault.h"
#import "GMDCircleLoader.h"

@implementation Home644DataController

////列表数据
- (void)requestHomeItemsDataInView:(UIView *)view
                               url:(NSString *)strurl
                            parter:(NSMutableDictionary *)parter
                          Callback:(completeCallback)callback
{
    if([strurl isEqualToString:Home_JingXuan_URL])
    {
        
        [HTTPManager sendGETRequestUrlToService:strurl withParametersDictionry:parter view:view completeHandle:^(NSURLSessionTask *opration, id responceObjct, NSError *error) {
            BOOL state = NO;
            NSString *describle = @"";
            if (responceObjct==nil) {
                describle = @"网络错误";
            }else{
                NSString *str=[[NSString alloc]initWithData:responceObjct encoding:NSUTF8StringEncoding];
                NSDictionary *dicAll=[str JSONValue];
                describle = dicAll[@"info"];
                if ([[NSString nullToString:dicAll[@"status"]] intValue]  ==1) {
//                    if ([dicAll[@"data"] isKindOfClass:[NSArray class]]) {
//                        NSMutableDictionary *dictemp = [NSMutableDictionary new];
//                        [dictemp setObject:dicAll[@"data"] forKey:@"linklist"];
//                        [dictemp setObject:@"" forKey:@"old_artice"];
//                        _resultListDict = dictemp;
//                        state = YES;
//                    }
//                    else
                    if ([dicAll[@"data"] isKindOfClass:[NSDictionary class]]) {
                        _resultListDict = dicAll[@"data"];
                        
                        state = YES;
                    }
                }
            }
            callback(error,state,describle);
        }];
    }
    else
    {
        [HTTPManager sendRequestUrlToService:strurl withParametersDictionry:parter view:view completeHandle:^(NSURLSessionTask *opration, id responceObjct, NSError *error) {
            BOOL state = NO;
            NSString *describle = @"";
            if (responceObjct==nil) {
                describle = @"网络错误";
            }else{
                NSString *str=[[NSString alloc]initWithData:responceObjct encoding:NSUTF8StringEncoding];
                NSDictionary *dicAll=[str JSONValue];
                describle = dicAll[@"info"];
                if ([[NSString nullToString:dicAll[@"status"]] intValue]  ==1) {
                    if ([dicAll[@"data"] isKindOfClass:[NSDictionary class]]) {
                        _resultListDict = dicAll[@"data"];
                        state = YES;
                    }
                }
            }
            callback(error,state,describle);
        }];
    }
    
    
}

////全网优惠列表数据
- (void)requestHomeItemsQWYHDataInView:(UIView *)view
                                   url:(NSString *)strurl
                                parter:(NSMutableDictionary *)parter
                              Callback:(completeCallback)callback
{
    
    [HTTPManager sendGETRequestUrlToService:strurl withParametersDictionry:parter view:view completeHandle:^(NSURLSessionTask *opration, id responceObjct, NSError *error) {
        BOOL state = NO;
        NSString *describle = @"";
        if (responceObjct==nil) {
            describle = @"网络错误";
        }else{
            NSString *str=[[NSString alloc]initWithData:responceObjct encoding:NSUTF8StringEncoding];
            NSDictionary *dicAll=[str JSONValue];
            describle = dicAll[@"info"];
            if ([[NSString nullToString:dicAll[@"status"]] intValue]  ==1) {
                if ([dicAll[@"data"] isKindOfClass:[NSArray class]]) {
                    _arrListqwyh = dicAll[@"data"];
                    state = YES;
                }
            }
        }
        callback(error,state,describle);
    }];
}

////京东列表数据
- (void)requestHomeItemsJDDataInView:(UIView *)view
                                 url:(NSString *)strurl
                              parter:(NSMutableDictionary *)parter
                            Callback:(completeCallback)callback
{
    
    [HTTPManager sendGETRequestUrlToService:strurl withParametersDictionry:parter view:view completeHandle:^(NSURLSessionTask *opration, id responceObjct, NSError *error) {
        BOOL state = NO;
        NSString *describle = @"";
        if (responceObjct==nil) {
            describle = @"网络错误";
        }else{
            NSString *str=[[NSString alloc]initWithData:responceObjct encoding:NSUTF8StringEncoding];
            NSDictionary *dicAll=[str JSONValue];
            describle = dicAll[@"info"];
            NSDictionary *byelited_response = [dicAll objectForKey:@"data"];
            _resultJDDict = byelited_response;
            
            if ([[NSString nullToString:dicAll[@"status"]] intValue] == 1) {
                if ([byelited_response[@"list"] isKindOfClass:[NSArray class]]) {
                    _resultJDListDict = byelited_response[@"list"];
                    state = YES;
                }
            }
        }
        callback(error,state,describle);
    }];
}

@end
